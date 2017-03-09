unit Stmvec1;

INTERFACE
{$IFDEF FPC} {$mode delphi} {$DEFINE AcqElphy2} {$A1} {$Z1} {$ENDIF}


uses windows,
     classes,graphics,forms,controls,menus,stdCtrls,dialogs,math, sysutils,        

     util1,DdosFich,Dgraphic,Dgrad1,dtf0,Dtrace1,
     Dpalette,Ncdef2,formMenu,
     editcont,cood0,
     tpForm0,

     stmDef,stmObj,defForm,
     getVect0,getMat0,visu0,

     varconf1,stmDobj1,
     debug0,
     stmError,
     detSave1,saveObj1,objFile1,saveOpt1,
     DtbEdit2,stmPopup,
     stmPg,
     getColVec1,
     ipps, ippsOvr,
     matlab_matrix,matlab_mat,
     binFile1,
     DoubleExt;


     { stmExe dans Implementation}


var
  FlagConvertExtended:boolean; // utilisé par Elphy64

const
  typesVecteursSupportes=[{G_byte,G_short,}G_smallint,g_word,G_longint,G_single,G_double,G_extended,
                          G_singleComp, G_doubleComp, G_extComp];

  stTypesVecteursSupportes='Smallint|Word|Longint|Single|Double|Extended|'+
                           'SingleComp|DoubleComp|ExtComp';


type
  TVector= class(TDataObj)

           private
                  

                  stSave:AnsiString;
                  vectoSave:Tlist;
                  XstartSave,XendSave,XorgSave:float;
                  AppendSave,contSave:boolean;
                  SaveRec:TsaveRecord;
                  xPaint,ypaint:float;

                  decimale:array[0..2] of byte;
                  

                  i1im,i2im:integer;
                  FdisplayPoints:boolean;
                  immediat:boolean;

                  LastIm:integer;


                  procedure setE(i:integer;x:float);
                  function getE(i:integer):float;
                  procedure setI(i,j:integer);
                  function getI(i:integer):integer;

                  
                  procedure setCpx(i:integer;x:TfloatComp);
                  function getCpx(i:integer):TfloatComp;

                  procedure setIm(i:integer;x:float);
                  function getIm(i:integer):float;

                  function getMdl(i:integer):float;

                
                  procedure onDisplayPoint(i:integer);

                  procedure DsetE(i,j:integer;x:float);
                  function DgetE(i,j:integer):float;
                  procedure DsetI(i,j:integer;x:float);
                  function DgetI(i,j:integer):float;

                  procedure DinvalidateCell(i,j:integer);
                  procedure DinvalidateVector(i:integer);
                  procedure DinvalidateAll;
                  procedure DdblClick(col,x,y:integer);

                  procedure DsetJvalue(b:boolean);
                  function DgetColName(i:integer):AnsiString;

                  procedure NewCursorClick(sender:Tobject);
                  procedure CursorClick(sender:Tobject);

                  procedure createImage(sender:Tobject);

                  procedure setIstart(w:integer);override;
                  procedure setIend(w:integer);override;

                  procedure setDeci(i:integer;w:integer);
                  function getDeci(i:integer):integer;

           protected
                  IendMax:integer;

                  procedure setDx(x:double);  override;
                  procedure setX0(x:double);  override;
                  procedure setDy(x:double);  override;
                  procedure setY0(x:double);  override;

                  procedure setCpxMode(w:byte);  override;

                  procedure setRvalue(x,y:float);virtual;
                  function getRvalue(x:float):float;virtual;



                  procedure fileSaveData(sender:Tobject);override;

                  procedure FileLoadFromVector(sender:Tobject);
                  procedure FileLoadFromObjFile(sender:Tobject);

                  function ChooseCoo1:boolean;override;

                  function getAttValue(i:integer):byte;virtual;
                  procedure SetAttValue(i:integer;w:byte);virtual;

           public
                  editForm:TtableEdit;
                  data:typedataB;
                  dataAtt:typeDataB;        {Attributs introduits pour les vecteurs d'evts colorés }

                  CanFreeData:boolean;
                  {indique que data peut être détruit }

                  OnDP:Tpg2Event;
                  onDisplay:Tpg2Event;
                  onImDisplay:Tpg2Event;

                  onDragDrop:Tpg2Event;

                  FonDragDrop: procedure (x,y:float) of object;

                  ImaxAutorise:integer; {Nombre de lignes déclaré pour vecteur tableau}

                  FonDisplay:procedure (p:pointer) of object;
                  flagPaintEmpty:boolean;
                  flagPartialPaint:boolean;
                  IpartialPaint:integer;

                  Xlevel,Ylevel:float;
                  UseLevel:boolean;

                  OnDPsys:procedure (i:integer) of object;

                  property SmoothFactor:integer read visu.SmoothFactor write visu.SmoothFactor;

                  constructor create;overload;override;
                  constructor create(tNombre:typeTypeG;n1,n2:longint;const Fzero:boolean=true);overload;
                  constructor create32(tNombre:typeTypeG;n1,n2:longint;const Fzero:boolean=true);

                  procedure AddE(i:integer;w:float);

                  destructor destroy;override;
                  class function STMClassName:AnsiString;override;

                  procedure FreeTempData;virtual;

                  procedure initTemp00(n1,n2:longint;tNombre:typeTypeG;KeepTemp,Fzero:boolean);

                  procedure initTemp1(n1,n2:longint;tNombre:typeTypeG;const Fzero:boolean=true);virtual;
                  {initTemp1 crée un tableau suivant la taille
                  demandée. Cette structure sera détruite en même temps que le
                  vecteur. CanFreeData=true , inf.temp=true }

                  procedure modifyTemp1(n1,n2:longint);
                  {Analogue à InitTemp1 mais ne modifie pas le contenu du vecteur
                   Aucun rapport avec ModifyTemp
                  }

                  procedure initDat1(data0:typeDataB;tNombre:typeTypeG);
                  {initDat1 fournit un objet data au vecteur. Cet objet ne sera
                  pas détruit en même temps que le vecteur pas plus que les
                  données associées. CanFreeData=false , inf.temp=false
                  }
                  procedure initDat0(data0:typeDataB;tNombre:typeTypeG);
                  {comme initdat1 mais n'appelle pas invalidate}

                  procedure initDat2(data0:typeDataB;tNombre:typeTypeG;Finvalidate:boolean);
                  {comme initdat1, le flag Finvalidate en plus}

                  procedure initDat1ex(data0:typeDataB;tNombre:typeTypeG);
                  {initDat1ex fournit un objet data au vecteur. Le vecteur a la
                  responsabilité de détruire cet objet data. (pas les données qu'il contient)
                  CanFreeData=true , inf.temp=false
                  }
                  procedure InitAtt(data0:typeDataB);

                  procedure ModifyTemp(NewSize:integer);virtual;
                  {Permet de modifier temporairement la taille du tampon tb. Par
                  exemple, on allonge la taille du tampon pour certaines opérations ISPL
                  Il faut restituer la taille initiale après les opérations en
                  utilisant restoreTemp.

                  Ne modifie pas la variable totSize.
                  NewSize est rangée dans TempSize.
                  }
                  procedure restoreTemp;
                  {A utiliser après ModifyTemp}

                  procedure modifyData;
                  procedure modifyLimits(i1,i2:integer; const WithI1:boolean=true);overload;virtual;
                  procedure modifyLimits(pp:pointer;i1,i2:integer);overload;


                  procedure freeData;

                  procedure display; override;
                  procedure displayEmpty; override;

                  procedure displayInside(FirstUO:typeUO;extWorld,logX,logY:boolean;
                                  const order:integer=-1); override;

                  procedure cadrerX(sender:Tobject);override;
                  procedure cadrerY(sender:Tobject);override;

                  procedure autoscaleX;override;
                  procedure autoscaleY;override;
                  procedure autoscaleY1;override;

                  procedure clear;override;
                  procedure clearAndInvalidate;

                  function initialise(st:AnsiString):boolean;override;

                  procedure BuildInfo(var conf:TblocConf;lecture,tout:boolean);
                    override;

                  procedure completeLoadInfo;override;

                  procedure propVector(stOpt:AnsiString);
                  procedure proprietes(sender:Tobject);override;
                  procedure EditVector(sender:Tobject);
                  procedure EditModal;
                  procedure createEditForm;
                  procedure updateEditForm;


                  {Ces 3 propriétés sont protégées en lecture/écriture}
                  property Jvalue[i:integer]:integer read getI write setI;
                  property Yvalue[i:integer]:float read getE write setE; default;
                  property Rvalue[x:float]:float read getRvalue write setRvalue;

                  property CpxValue[i:integer]:TfloatComp read getCpx write setCpx;
                  property ImValue[i:integer]:float read getIm write setIm;

                  property Mdl[i:integer]:float read getMdl;
                  property AttValue[i:integer]:byte read getAttValue write SetAttValue;

                  procedure saveData(f:Tstream);override;
                  function loadData(f:Tstream):boolean;override;
                  function loadExtendedData(f:Tstream): boolean;

                  procedure saveAsSingle(f:Tstream);override;
                  function loadAsSingle(f:Tstream):boolean;override;

                  procedure SaveToBin(f:Tstream; tp:typetypeG; const i1:integer=0; const i2:integer=-1);
                  procedure LoadFromBin(f:Tstream; ByteStep: integer);

                  procedure initList0(t_nombre:typetypeG;Fscale:boolean);
                  procedure initList(t_nombre:typetypeG);

                  procedure initEventList(t_nombre:typetypeG;dx:float);
                  procedure addtoList(x:float);
                  procedure resetList;
                  procedure SortEventList;
                  procedure Sort(Up:boolean);
                  procedure SortWithIndex(Up:boolean; Vindex: Tvector);
                  procedure ModifyOrder( Vindex: Tvector);
                  procedure RemoveFromList(index:integer);
                  procedure InsertIntoList(index:integer;x:float);

                  procedure fill(y:float);
                  procedure fill1(y:float;i1,i2:integer);
                  procedure fillCpx(y:TfloatComp);
                  procedure fillCpx1(y:TfloatComp;i1,i2:integer);


                  procedure Vmoveto(x,y:float);
                  procedure Vlineto(x,y:float);

                  function inRangeI(i:integer):boolean;
                  function getFirstEvent(x:float;const min1:integer=-1;const max1:integer=-1):integer;
                  function empty:boolean;

                  procedure specialDrop(Irect:Trect;x,y:integer);override;

                  function AdjustIstartIend(source:Tvector):boolean;
                  function AdjustIstartIend1(source:Tvector;tp:typetypeG):boolean;
                  function AdjustIstartIendTpNum(source:Tvector):boolean;

                  procedure extendDim(source:Tvector;tp:typetypeG);
                  function extendDim1(i1,i2:integer;tp:typetypeG):boolean;
                  procedure cadrageX(var i1,i2:integer);
                  procedure ControleReadOnly;

                  function extend(NewMax:integer):boolean;
                  function extendNoCondition(NewMax:integer):boolean;

                  function getPopUp:TpopupMenu;override;

                  procedure invalidate;override;
                  procedure invalidateData;override;

                  Procedure AddInt(vec1:Tvector;x1,x2:float);

                  procedure messageImDisplay(i1,i2:integer);
                  function getInfo:AnsiString;override;

                  procedure getMinMax(var y1,y2:float);

                  {Ces fonctions renvoient l'adresse de tb[0] qui est différente de tb
                   quand Istart<>0 }
                  function tbSmallint:PtabEntier;
                  function tbLong:PtabLong;
                  function tbSingle:PtabSingle;
                  function tbDouble:PtabDouble;
                  function tbSingleComp:PtabSingleComp;
                  function tbDoubleComp:PtabDoubleComp;

                  function sumI:integer;

                  procedure DoImDisplay;override;

                  function clone(Fdata:boolean; const Fref:boolean=true):typeUO;override;

                  procedure copyDataFromVec(source:Tvector;i1,i2,iD:integer);
                  procedure copyDataFrom(p:typeUO);override;

                  procedure setIcount(n:integer);override;

                  function strucModif(tp:typeTypeG;i1,i2:integer):boolean;
                  procedure modify(tNombre:typeTypeG;i1,i2:integer);virtual;

                  procedure Vcopy(vec:Tvector);
                  procedure Vadd(vec:Tvector);
                  procedure VaddSqrs(vec:Tvector);

                  function sum(i1,i2:integer):float;
                  function sumSqrs(i1,i2:integer):float;
                  function sumMdls(i1,i2:integer):float;
                  function sumPhi(i1,i2:integer):float;

                  function maxi0:float;
                  function mini0:float;
                  function maxiX0:float;
                  function miniX0:float;


                  function sum0:float;
                  function sumSqrs0:float;
                  function sumMdls0:float;
                  function sumPhi0:float;


                  procedure NormalizeValues;

                  function IntAbove(x1c,x2c,y0:float;var len:float):float;
                  function IntBelow(x1c,x2c,y0:float;var len:float):float;

                  procedure maxLis(x1,x2:float;N:integer;var Vm,xm:float);
                  procedure Threshold(th:float;Fup,Fdw:boolean);
                  procedure Threshold1(th:float);
                  procedure Threshold2(th1,th2,val1,val2:float);

                  function isCpx:boolean;

                  function DeltaLevel(flag:boolean;x,y:float):float;

                  function getP(i:integer):pointer;

                  function isModified:boolean;override;
                  function isZero:boolean;
                  procedure Vrandom(y1,y2:float);

                  function getMxArray(Const tpdest0:typetypeG = G_none):MxArrayPtr;override;
                  procedure setMxArray(mxArray:MxArrayPtr;Const invertIndices:boolean=false);override;

                  function getMean(x1,x2:float):float;override;
                  function getCpxMean(x1,x2:float):TfloatComp;

                  function Xstart:float;  override;
                  function Xend:float;    override;

                end;



procedure verifierVecteur(var pu:Tvector);
procedure verifierVecteurTemp(var pu:Tvector);
procedure verifierVecteurRW(var pu:Tvector);

procedure VadjustIstartIend(source,dest:Tvector);
{Ajuste Istart, Iend de dest. Modifie les paramètres d'échelle X et Y
 Génère une erreur si impossible}

procedure VadjustIstartIend1(source,dest:Tvector;tp:typetypeG);
{Ajuste Istart, Iend de dest. Affecte dest.tpNum . Modifie les paramètres d'échelle X et Y
 Génère une erreur si impossible}

procedure VadjustIstartIendTpNum(source,dest:Tvector);
{Ajuste Istart, Iend, tpNum de dest. Affecte dest.tpNum . Modifie les paramètres d'échelle X et Y
 Génère une erreur si impossible}


procedure Vmodify(dest:Tvector;tp:typetypeG;i1,i2:integer);
{Essaie de modifier la structure de dest
Génère une erreur si impossible}

procedure VcopyXscale(source,dest:Tvector);
{copie de dx, x0 et unitX}

procedure VcopyYscale(source,dest:Tvector);
{copie de dy et y0 .  Pas unitY}


procedure controleVsourceVdest(var source,dest:Tvector;tp:typetypeG);
{ Ne pas utiliser. Ancienne procédure.
}

{***************** Déclarations STM pour Tvector *****************************}

procedure proTvector_create(name:AnsiString;t:smallint;n1,n2:longint;var pu:typeUO);pascal;
procedure proTvector_create_1(t:smallint;n1,n2:longint;var pu:typeUO);pascal;
procedure proTvector_create_2(var pu:typeUO);pascal;

procedure proTVector_modify(t:smallint;i1,i2:integer;var pu:typeUO);pascal;

procedure proTVector_Jvalue(i:longint;j:longint;var pu:typeUO);pascal;
function fonctionTVector_Jvalue(i:longint;var pu:typeUO):longint;pascal;

procedure proTVector_Yvalue(i:longint;y:float;var pu:typeUO);pascal;
function fonctionTVector_Yvalue(i:longint;var pu:typeUO):float;pascal;

procedure proTVector_Rvalue(x,y:float;var pu:typeUO);pascal;
function fonctionTVector_Rvalue(x:float;var pu:typeUO):float;pascal;

procedure proTVector_getMinMax(var min,max:float;var pu:typeUO);pascal;

function FonctionTvector_Mean(var pu:typeUO):float;pascal;
function FonctionTvector_Mean_1(x1,x2:float;var pu:typeUO):float;pascal;

function FonctionTvector_StdDev(var pu:typeUO):float;pascal;
function FonctionTvector_StdDev_1(x1,x2:float;var pu:typeUO):float;pascal;

function FonctionTvector_CpxMean(var pu:typeUO):TfloatComp;pascal;
function FonctionTvector_CpxMean_1(x1,x2:float;var pu:typeUO):TfloatComp;pascal;

function FonctionTvector_DistriMean(x1,x2:float;var pu:typeUO):float;pascal;
function FonctionTvector_DistriStdDev(x1,x2:float;var pu:typeUO):float;pascal;


function FonctionTvector_Maxi(x1,x2:float;var pu:typeUO):float;pascal;
function FonctionTvector_Mini(x1,x2:float;var pu:typeUO):float;pascal;
function FonctionTvector_MaxiX(x1,x2:float;var pu:typeUO):float;pascal;
function FonctionTvector_MiniX(x1,x2:float;var pu:typeUO):float;pascal;

procedure proTvector_fill(y:float;var pu:typeUO);pascal;
procedure proTvector_fill1(y,x1,x2:float;var pu:typeUO);pascal;
procedure proTvector_fillCpx(y:TfloatComp;var pu:typeUO);pascal;
procedure proTvector_fillCpx1(y:TfloatComp;x1,x2:float;var pu:typeUO);pascal;



procedure proTvector_Vmoveto(x,y:float;var pu:typeUO);pascal;
procedure proTvector_Vlineto(x,y:float;var pu:typeUO);pascal;


procedure proTvector_initEventList(t:smallint;dx:float;var pu:typeUO);pascal;
procedure proTvector_initList(t:smallint;var pu:typeUO);pascal;
procedure proTvector_addToList(x:float;var pu:typeUO);pascal;
procedure proTvector_resetList(var pu:typeUO);pascal;

procedure proTvector_SortEventList(var pu:typeUO);pascal;
procedure proTvector_sort(Up:boolean; var pu:typeUO);pascal;
procedure proTvector_sortWithIndex(Up:boolean; var Vindex: Tvector; var pu:typeUO);pascal;
procedure proTvector_ModifyOrder(var Vindex: Tvector; var pu:typeUO);pascal;

procedure proTvector_removeFromList(i:integer;var pu:typeUO);pascal;
procedure proTvector_InsertIntoList(i:integer;x:float;var pu:typeUO);pascal;

procedure proTvector_getPointColor(p:integer;var pu:typeUO);pascal;
function fonctionTvector_getPointColor(var pu:typeUO):integer;pascal;

procedure proTvector_OnDisplay(p:integer;var pu:typeUO);pascal;
function fonctionTvector_OnDisplay(var pu:typeUO):integer;pascal;

procedure proTvector_OnImDisplay(p:integer;var pu:typeUO);pascal;
function fonctionTvector_OnImDisplay(var pu:typeUO):integer;pascal;


function FonctionTvector_getFirstEvent(x:float;var pu:typeUO):integer;pascal;

procedure proTvector_OnDragDrop(p:integer;var pu:typeUO);pascal;
function fonctionTvector_OnDragDrop(var pu:typeUO):integer;pascal;


function fonctionCompareMseq(var vec1,vec2:Tvector):integer;pascal;
procedure proMseqFMT(var cc,Re,Rs,Data,fmtr:Tvector);pascal;



procedure proTvector_SaveAsText(stName:AnsiString;twoCol1:boolean;deci:smallint;
                                var pu:Tvector);pascal;
procedure proTvector_LoadFromText(stName:AnsiString;NumCol,lig1,lig2:integer;
                                var pu:Tvector);pascal;


procedure proTvector_SaveAsSingle(stName:AnsiString;var pu:Tvector);pascal;
procedure proTvector_SaveAsDouble(stName:AnsiString;var pu:Tvector);pascal;

procedure proTvector_SineWave(amp,Periode,phi:float;var pu:Tvector);pascal;

procedure proTvector_setScaleParams(Dx1,x1,Dy1,y1:float;var pu:Tvector);pascal;

procedure proTVector_CpxValue(i:longint;y:TfloatComp;var pu:typeUO);pascal;
function fonctionTVector_CpxValue(i:longint;var pu:typeUO):TfloatComp;pascal;

procedure proTVector_ImValue(i:longint;y:float;var pu:typeUO);pascal;
function fonctionTVector_ImValue(i:longint;var pu:typeUO):float;pascal;


procedure proTvector_CpxMode(x:integer;var pu:typeUO);pascal;
function fonctionTvector_CpxMode(var pu:typeUO):integer;pascal;

procedure proTvector_Threshold(th:float;Fup,Fdw:boolean;var pu:Tvector);pascal;
procedure proTvector_Threshold1(th:float;var pu:Tvector);pascal;
procedure proTvector_Threshold2(th1,th2,val1,val2:float;var pu:Tvector);pascal;

function FonctionTvector_MedianValue(x1,x2:float;var pu:typeUO):float;pascal;

procedure proTvector_Xlevel(x:float;var pu:typeUO);pascal;
function fonctionTvector_Xlevel(var pu:typeUO):float;pascal;

procedure proTvector_Ylevel(x:float;var pu:typeUO);pascal;
function fonctionTvector_Ylevel(var pu:typeUO):float;pascal;

procedure proTvector_Uselevel(x:boolean;var pu:typeUO);pascal;
function fonctionTvector_Uselevel(var pu:typeUO):boolean;pascal;

function FonctionTvector_Maxi0(var pu:typeUO):float;pascal;
function FonctionTvector_Mini0(var pu:typeUO):float;pascal;
function FonctionTvector_MaxiX0(var pu:typeUO):float;pascal;
function FonctionTvector_MiniX0(var pu:typeUO):float;pascal;
function FonctionTvector_Sum0(var pu:typeUO):float;pascal;
function FonctionTvector_Sum(var pu:typeUO):float;pascal;
function FonctionTvector_Sum_1(x1,x2:float; var pu:typeUO):float;pascal;
function FonctionTvector_SqrSum0(var pu:typeUO):float;pascal;
function FonctionTvector_Mean0(var pu:typeUO):float;pascal;
function FonctionTvector_StdDev0(var pu:typeUO):float;pascal;
function FonctionTvector_MedianValue0(var pu:typeUO):float;pascal;

procedure proTvector_SaveBinaryData(var fbin:TbinaryFile;tp:integer;var pu:typeUO);pascal;
procedure proTvector_LoadBinaryData(var fbin:TbinaryFile;ByteStep:integer; var pu:typeUO);pascal;

procedure proTvector_saveSingleData(var binF, pu:typeUO);pascal;
procedure proTvector_loadSingleData(var binF, pu:typeUO);pascal;

procedure proTvector_SmoothFactor(w:integer ;var pu:typeUO);pascal;
function fonctionTvector_SmoothFactor(var pu:typeUO):integer;pascal;

procedure proTvector_BinFactor(w:integer ;var pu:typeUO);pascal;
function fonctionTvector_BinFactor(var pu:typeUO):integer;pascal;


procedure proTvector_Edit(var pu:typeUO);pascal;

procedure proTbinaryFile_CopyFrom_1(var binF:TbinaryFile;BlockSize,MaxSize:int64; var VMask:Tvector; tp:integer;var index:integer; var pu:typeUO);pascal;
procedure proTbinaryFile_CopyWithDownSampling1(var binF:TbinaryFile;EpSize:int64; ChCount:integer; tp:integer; DSfactor: integer; var pu:typeUO);pascal;
procedure proTbinaryFile_CopyEpisodeWithDownSampling1(var binF:TbinaryFile;var Voffset, VSize, VMask:Tvector; tp:integer; DSfactor: integer; var pu:typeUO);pascal;

IMPLEMENTATION

uses inivect0,dac2File, stmCurs, curProp1,stmVzoom,stmISPL1,
     LoadFromVec1, stmvecU1 ;

var
  E_typeNombre:integer;
  E_modify1:integer;
  E_modify2:integer;

  E_index:integer;
  E_indexOrder:integer;
  E_lineWidth:integer;
  E_data:integer;

  E_readOnly:integer;
  E_vecteur:integer;

  E_compareMseq:integer;
  E_fmt1:integer;
  E_deciText:integer;

  E_vecteurTemp:integer;
  E_Cmode:integer;

  E_IstartIend:integer;
  E_IstartIendTpNum:integer;

{****************** Messages d'erreur ********************}

procedure SortieErreurIndex(i:integer;v:Tvector);
begin
  sortieErreur('Tvector : index out of range' +#10#13+' i='+Istr(i)+' in '+v.ident);
end;

{****************** Methodes de TVector ******************}

procedure TVector.freeTempData;
begin
  freeTemp0;

  if (data<>nil) and CanFreeData then data.free;
  data:=nil;
  dataAtt:=nil;
end;

procedure TVector.initTemp00(n1,n2:longint;tNombre:typeTypeG;KeepTemp,Fzero:boolean);
var
  taille,taille1:longint;
begin
  if (data<>nil) and CanFreeData then data.free;
  data:=nil;
  dataAtt:=nil;

  taille:=tailleTypeG[tNombre]*(n2-n1+1);
  if taille<0 then taille:=0;

  if keepTemp then
  begin
    if (n1>Istart) and (n1<=Iend) then
    begin
      if n2<=Iend
        then taille1:=taille
        else taille1:=(Iend-n1+1)*tailleTypeG[tpNum];
      move(PtabOctet(tb)^[(n1-Istart)*tailleTypeG[tpNum]],tb^,taille1);
    end;
    if not reallocmemory(totSize,taille,Fzero) then MemoryErrorMessage('Tvector.initTemp');
    FtotSize:=taille;
  end
  else initTemp0(tNombre,taille,Fzero);
  CanFreeData:=true;

  with flags do
  begin
    FmaxIndex:=false;
    Findex:=true;
    Ftype:=true;
  end;

  with inf do
  begin
    tpNum:=tNombre;
    Imin:=n1;
    Imax:=n2;
  end;

  case tNombre of
    G_smallint: data:=typedataI.create(tb,1,n1,n1,n2);
    G_word:     data:=typedataW.create(tb,1,n1,n1,n2);

    G_longint: data:=typedataL.create(tb,1,n1,n1,n2);
    G_single:  data:=typedataS.create(tb,1,n1,n1,n2);
    G_double:  data:=typedataD.create(tb,1,n1,n1,n2);
    G_extended:data:=typedataE.create(tb,1,n1,n1,n2);

    G_singleComp:  data:=typedataCpxS.create(tb,1,n1,n1,n2);
    G_doubleComp:  data:=typedataCpxD.create(tb,1,n1,n1,n2);
    G_extComp:     data:=typedataCpxE.create(tb,1,n1,n1,n2);
  end;

  if data<>nil then
    begin
      data.ax:=inf.dxu;
      data.bx:=inf.x0u;
      data.ay:=inf.dyu;
      data.by:=inf.y0u;
    end;

  IendMax:=n2;

  invalidateData;
end;

procedure TVector.initTemp1(n1,n2:longint;tNombre:typeTypeG; const Fzero:boolean=true);
begin
  initTemp00(n1,n2,tNombre,false,Fzero);
end;

procedure Tvector.modifyTemp1(n1,n2:longint);
begin
  initTemp00(n1,n2,tpNum,true,true);
end;

procedure Tvector.ModifyData;
begin
  if tb=nil then exit;

  if assigned(data)
    then data.modifyData(tb);
end;

procedure Tvector.ModifyTemp(NewSize:integer);
begin
  if not reallocmemory(totSize,NewSize,true) then MemoryErrorMessage('Tvector.ModifyTemp');
  TempSize:=NewSIze;
  modifyData;
end;

procedure Tvector.RestoreTemp;
begin
  if not reallocmemory(TempSize,totSize,true) then MemoryErrorMessage('Tvector.ModifyTemp');
  modifyData;
end;


procedure Tvector.initDat0(data0:typeDataB;tNombre:typeTypeG);
begin
  freeTempData;

  data:=data0;

  if data=nil then
  begin
    inf.Imin:=0;
    inf.Imax:=-1;
    exit;
  end;

  CanFreeData:=false;
  inf.temp:=false;
  inf.readOnly:=true;                { Ce readOnly peut être supprimé si on veut autoriser l'écriture
                                       sans autoriser le changement de structure } 

  inf.tpNum:=tNombre;

  inf.Imin:=data0.indiceMin;
  inf.Imax:=data0.indiceMax;

  inf.dxu:=data0.ax;
  inf.x0u:=data0.bx;
  inf.dyu:=data0.ay;
  inf.y0u:=data0.by;

  with flags do
  begin
    FmaxIndex:=false;
    Findex:=false;
    Ftype:=false;
  end;
  IendMax:=inf.Imax;

end;


procedure Tvector.initDat1(data0:typeDataB;tNombre:typeTypeG);
begin
  initDat0(data0,tNombre);
  invalidateData;
end;

procedure Tvector.initDat2(data0:typeDataB;tNombre:typeTypeG;Finvalidate:boolean);
begin
  initDat0(data0,tNombre);
  if Finvalidate then invalidateData;
end;

procedure Tvector.InitAtt(data0:typeDataB);
begin
  DataAtt:=data0;
end;

procedure Tvector.initDat1ex(data0:typeDataB;tNombre:typeTypeG);
begin
  initDat1(data0,tNombre);
  CanFreeData:=true;
end;



procedure Tvector.modifyLimits(i1,i2:integer; const WithI1:boolean=true);
begin
  if assigned(data) then
  begin
    data.modifyLimits(i1,i2);               { modifier indiceMin et indiceMax }

    if withI1 and (data is typedataTab)
      then typedataTab(data).indice1:=i1;   { et indice1 }
  end;

  if assigned(dataAtt) then                 { Idem pour DataAtt }
  begin
    dataAtt.modifyLimits(i1,i2);            { modifier indiceMin et indiceMax }

    if withI1 and (dataAtt is typedataTab)
      then typedataTab(dataAtt).indice1:=i1;{ et indice1 }
  end;

  inf.imin:=i1;
  inf.imax:=i2;
  modifiedData:=true;
end;



procedure Tvector.modifyLimits(pp:pointer;i1,i2:integer);
begin
  if assigned(data) then data.modifyData(pp);
  modifyLimits(i1,i2);
end;


procedure TVector.setIstart(w: integer);
var
  old:integer;
begin
  old:=Istart;
  modifyLimits(w,inf.imax+w-old);
  Iendmax:=Iendmax+w-old;
  invalidate;
end;

procedure TVector.setIend(w: integer);
var
  old:integer;
begin
  { on modifie Istart et Iend en même temps. Icount ne change pas }
  old:=Iend;
  modifyLimits(inf.imin+w-old,w);
  Iendmax:=Iendmax+w-old;
  invalidate;
end;


procedure Tvector.freeData;
begin
  data.free;
  data:=nil;
end;

class function Tvector.STMClassName:AnsiString;
  begin
    STMClassName:='Vector';
  end;

constructor Tvector.create;
begin
  saveRec.init;

  decimale[0]:=3;
  decimale[1]:=3;
  decimale[2]:=3;

  inherited;
end;

constructor Tvector.create(tNombre:typeTypeG;n1,n2:longint;const Fzero:boolean=true);
begin
  create;
  initTemp1(n1,n2,tNombre,Fzero);
end;

constructor Tvector.create32(tNombre:typeTypeG;n1,n2:longint;const Fzero:boolean=true);
begin
  Falign32bytes:= false;
  create(tNombre,n1,n2,Fzero);
end;


destructor TVector.destroy;
var
  i:integer;
begin
  messageToRef(UOmsg_destroy,nil);

  freeTempData;

  editForm.free;

  inherited destroy;
end;

procedure TVector.display;
var
  deltaY:float;
begin
  deltaY:=DeltaLevel(UseLevel,Xlevel,Ylevel);

  affdebug('Tvector Display '+ident,15);
  if FDisplayPoints then visu.displayPoints(Data,onDisplayPoint,i1Im,i2Im,false,deltaY)
  else
    begin
      if flagPaintEmpty then
        begin
          visu.displayEmpty;
          flagPaintEmpty:=false;
        end
      else
      if FlagPartialPaint then
        begin
          visu.displayPoints(Data,onDisplayPoint,Istart,IpartialPaint,false,deltaY);
          FlagPartialPaint:=false;
        end
      else visu.displayTrace(Data,onDisplayPoint,deltaY);

      with OnDisplay do
      if valid then pg.executerProcedure1(ad,tagUO);

      if assigned(FonDisplay) then FonDisplay(self);
    end;

  LastIm:=Iend;

end;

procedure TVector.displayEmpty;
begin
  visu.displayEmpty;
end;

procedure TVector.displayInside(FirstUO:typeUO;extWorld,logX,logY:boolean;const order:integer=-1);
var
  deltaY:float;
begin
  deltaY:=DeltaLevel(UseLevel,Xlevel,Ylevel);

  if FDisplayPoints
    then visu.displayPoints(Data,onDisplayPoint,i1Im,i2Im,true,deltaY)
  else
  if FlagPartialPaint then
    begin
      visu.displayPoints(Data,onDisplayPoint,Istart,IpartialPaint,true,deltaY);
      FlagPartialPaint:=false;
    end
  else
  if not FlagPaintEmpty
    then visu.displayTrace0(Data,extWorld,false,logX,logY,0,0,onDisplayPoint,deltaY);
  LastIm:=Iend;


end;

procedure TVector.cadrerX(sender:Tobject);
begin
  visu0^.cadrerX(data);
end;

procedure TVector.cadrerY(sender:Tobject);
var
  deltaY:float;
  min,max:float;
begin
  visu0^.cadrerY(data);

  deltaY:=DeltaLevel(UseLevel,Xlevel,Ylevel);
  visu0^.Ymin:=visu0^.Ymin-deltaY;
  visu0^.Ymax:=visu0^.Ymax-deltaY;
end;

procedure TVector.autoscaleX;
begin
  visu.cadrerX(data);
end;

procedure TVector.autoscaleY;
var
  deltaY:float;
begin
  visu.cadrerY(data);

  deltaY:=DeltaLevel(UseLevel,Xlevel,Ylevel);
  visu.Ymin:=visu.Ymin-deltaY;
  visu.Ymax:=visu.Ymax-deltaY;
end;

procedure TVector.autoscaleY1;
  begin
    visu.cadrerYlocal(data);
  end;


procedure Tvector.clear;
begin
  if Flags.FmaxIndex then resetList
  else
  begin
    if data<>nil then data.raz;
  end;
  modifiedData:=true;
end;

procedure Tvector.clearAndInvalidate;
begin
  clear;
  invalidateData;
end;

procedure Tvector.setDx(x:double);
begin
  inherited setDx(x);
  if data<>nil then data.ax:=x;
end;

procedure Tvector.setx0(x:double);
begin
  inherited setx0(x);
  if data<>nil then data.bx:=x;
end;

procedure Tvector.setDy(x:double);
begin
  inherited setDy(x);
  if data<>nil then data.ay:=x;
end;

procedure Tvector.setY0(x:double);
begin
  inherited setY0(x);
  if data<>nil then data.by:=x;
end;

procedure Tvector.setCpxMode(w:byte);
begin
  inherited setCpxMode(w);
end;


function Tvector.initialise(st:AnsiString):boolean;
var
  n1,n2:longint;
  tnombre:typetypeG;
begin
  inherited initialise(st);

  if initTvector.execution('New vector: '+st,self,0,'') then
    begin
      Dxu:=inf.dxu;
      X0u:=inf.x0u;
      Dyu:=inf.dyu;
      Y0u:=inf.y0u;
      with inf do initTemp1(Imin,Imax,tpNum);

      initialise:=true;
    end
  else initialise:=false;
end;

procedure Tvector.BuildInfo(var conf:TblocConf;lecture,tout:boolean);
begin
  inherited buildInfo(conf,lecture,tout);
  conf.setvarConf('Deci',decimale,sizeof(decimale));
end;

procedure Tvector.completeLoadInfo;
begin
  inherited completeLoadInfo;

  visu.controle;
  inf.controle;

  If FLoadObjectsMINI then
  begin
    inf.Imin:=0;
    inf.Imax:=-1;
  end;

  initTemp1(inf.Imin,inf.Imax,inf.tpNum);
end;


procedure Tvector.proprietes(sender:Tobject);
begin
  propVector('');
end;

procedure Tvector.propVector(stOpt:AnsiString);
var
  inf1:TinfoDataObj;
begin
  inf1:=inf;
  if initTvector.execution(Ident+' properties',self,ImaxAutorise,stOpt) then
    begin
      if (inf1.dxu<>inf.dxu) or (inf1.x0u<>inf.x0u) or
         (inf1.dyu<>inf.dyu) or (inf1.y0u<>inf.y0u) then
        begin
          Dxu:=inf.dxu;
          X0u:=inf.x0u;
          Dyu:=inf.dyu;
          Y0u:=inf.y0u;
        end;

      if (inf1.Imin<>inf.Imin) or (inf1.Imax<>inf.Imax) or (inf1.tpNum<>inf.tpNum) then
        with flags do
        begin
          if FmaxIndex
            then extend(inf.Imax)
            else initTemp1(inf.imin,inf.imax,inf.tpNum);
        end;



      invalidateData;
    end;
end;


procedure Tvector.DinvalidateCell(i,j:integer);
begin
  invalidateData;
end;

procedure Tvector.DinvalidateVector(i:integer);
begin
  invalidateData;
end;

procedure Tvector.DinvalidateAll;
begin
  invalidateData;
end;

procedure Tvector.DsetJvalue(b:boolean);
begin
  if b then
    begin
      EditForm.getColName:=DgetColName;
      EditForm.getTabValue:=DgetI;
      EditForm.setTabValue:=DsetI;
      EditForm.UseDecimale:=false;
    end
  else
    begin
      EditForm.getColName:=DgetColName;
      EditForm.getTabValue:=DgetE;
      EditForm.setTabValue:=DsetE;
      EditForm.UseDecimale:=true;
    end;
end;

procedure Tvector.DsetI(i,j:integer;x:float);
begin
  if not inf.readOnly then
    case i of
      2:  Jvalue[j]:=roundL(x);
    end;
end;

function Tvector.DgetI(i,j:integer):float;
begin
  case i of
    1: result:=j;
    2: result:=Jvalue[j];
    else result:=0;
  end;
end;

procedure Tvector.DsetE(i,j:integer;x:float);
begin
  if inf.readOnly then exit;
  case i of
    2: Yvalue[j]:=x;
    3: ImValue[j]:=x;
  end;
end;

function Tvector.DgetE(i,j:integer):float;
begin
  case i of
    1: result:=convx(j);
    2: result:=Yvalue[j];
    3: result:=ImValue[j];
    else result:=0;
  end;
end;

function Tvector.DgetColName(i:integer):AnsiString;
begin
  case i of
    1: result:='x';
    2: if isComplex
         then result:='y.Re'
         else result:='y';
    3: if isComplex
         then result:='y.Im'
         else result:='y';
  end;
end;


procedure Tvector.DdblClick(col,x,y:integer);
begin
  with ColParam do
  begin
    left:=x;
    top:=y;
    Caption:= 'Column '+Istr(col);
    enDeci.setVar(decimale[col-1],t_byte);
    enDeci.setMinMax(0,20);
    if showModal=mrOK then
      begin
        updateAllVar(colParam);
        EditForm.Invalidate;
      end;
  end;
end;

procedure Tvector.updateEditForm;
var
  Flag:boolean;
begin
  if not assigned(editForm) then exit;

  {if (Istart<>editForm.ligStart) or (Iend<>editForm.ligEnd) then}
    with editForm do
    begin
    (*
      Flag:=editForm.visible;
      if Flag then editForm.hide;
    *)
      installe(1,Istart,2+ord(isComplex),Iend);
      caption:=ident;

      getColName:=DgetColName;
      getTabValue:=DgetE;
      setTabValue:=DsetE;

      getDeciValue:=self.getDeci;
      setDeciValue:=self.setDeci;

      invalidateCellD:=DinvalidateCell;
      invalidateVectorD:=DinvalidateVector;
      invalidateAllD:=DinvalidateAll;
      dblClickRow0:=DdblClick;

      setKvalueD:=DsetJvalue;
      clearData:=clearAndInvalidate;

      adjustFormSize;
      UseKvalue1.visible:=true;

      File1.visible:=true;
      Load1.visible:=not readOnly;
      Save1.visible:=true;

      Edit1.visible:=true;
      Select1.visible:=true;
      Copy1.visible:=true;
      Clear2.visible:=not readOnly;
      Options1.visible:=true;
      Clear1.visible:=not readOnly;;
      Font1.visible:=true;
      Properties1.visible:=true;
      paste1.visible:=not readOnly;;
      UseKvalue1.visible:=true;
      ImmediateRefresh.visible:=not readOnly;;
      Refresh1.visible:=not readOnly;;


      Fimmediate:=@immediat;

      (* if Flag then editForm.show; *)
    end;

  editForm.invalidate;
end;


procedure Tvector.createEditForm;
begin
  Editform:=TtableEdit.create(formStm);
  updateEditForm;
end;

procedure Tvector.EditVector(sender:Tobject);
begin
  if not assigned(editForm) then createEditForm;
  EditForm.show;
end;

procedure Tvector.EditModal;
begin
  if not assigned(editForm) then createEditForm;
  EditForm.showModal;
end;



const
  blocEvt=1000;


function Tvector.extend(NewMax:integer):boolean;
var
  old:integer;
begin
  result:=false;
  if newmax<=inf.Imax then exit;
  if not (flags.FmaxIndex or Fexpand and (newMax=inf.Imax+1) ) then exit;

  old:=IendMax;
  while IendMax<NewMax do IendMax:=Iendmax+BlocEvt;

  if IendMax<>old then
    begin
      extendTemp((IendMax-Istart+1)*tailleTypeG[inf.tpNum]);
      modifyData;
    end;

  inf.Imax:=newMax;
  data.indicemax:=newMax;
  result:=true;
end;

function Tvector.extendNoCondition(NewMax:integer):boolean;
var
  old:integer;
begin
  result:=false;
  if newmax<=inf.Imax then exit;
  if not inf.temp then exit;

  old:=IendMax;
  while IendMax<NewMax do IendMax:=Iendmax+BlocEvt;

  if IendMax<>old then
    begin
      extendTemp((IendMax-Istart+1)*tailleTypeG[inf.tpNum]);
      modifyData;
    end;

  inf.Imax:=newMax;
  data.indicemax:=newMax;
  result:=true;
end;

procedure Tvector.messageImDisplay(i1,i2:integer);
var
  d:float;
  flag:boolean;
begin
  if i1>i2 then exit;

  i1im:=i1;
  i2im:=i2;

  flag:=false;

  if (visu.modeT=DM_evt1) or (visu.modeT=DM_evt1) then
  begin
    while Yvalue[i1]< Xmin do
    begin
      d:=Xmax-Xmin;
      if d<=0 then exit;
      Xmin:=Xmin-d;
      Xmax:=Xmax-d;
      flag:=true;
    end;

    while Yvalue[i2]> Xmax do
    begin
      d:=Xmax-Xmin;
      if d<=0 then exit;
      Xmin:=Xmin+d;
      Xmax:=Xmax+d;
      flag:=true;
    end;
  end
  else
  begin
    while i1< invconvx(Xmin) do
    begin
      d:=Xmax-Xmin;
      if d<=0 then exit;
      Xmin:=Xmin-d;
      Xmax:=Xmax-d;
      flag:=true;
    end;

    while i2> invconvx(Xmax) do
    begin
      d:=Xmax-Xmin;
      if d<=0 then exit;
      Xmin:=Xmin+d;
      Xmax:=Xmax+d;
      flag:=true;
    end;
  end;

  if flag then
  begin
    invalidate;
    with OnImDisplay do
      if valid then pg.executerProcedure1(ad,tagUO);
  end
  else
    begin
      FdisplayPoints:=true;
      messageToRef(UOmsg_simpleRefresh,nil);

      invalidateForm;

      FdisplayPoints:=false;
    end;
end;

procedure Tvector.setE(i:integer;x:float);
var
  old:integer;
  Flag:boolean;
begin
  if (data=nil) then
    begin
      sortieErreur(E_data);
      exit;
    end;

  old:=inf.Imax;
  if extend(i) then flag:= FimDisplay else flag:=false;

  if (i<IStart) or (i>Iend) then sortieErreurIndex(i,self)
  else
  if inf.readOnly then sortieErreur(E_readOnly)
  else data.setE(i,x);

  modifiedData:=true;
end;



function Tvector.getE(i:integer):float;
begin
  result:=0;

  if (data=nil) then
    begin
      sortieErreur(E_data);
      exit;
    end;

  if (i>=data.indicemin) and (i<=data.indicemax)
    then result:=data.getE(i)
  else
  if (i<data.indicemin) or not Flags.FmaxIndex
    then sortieErreurIndex(i,self);
end;


procedure Tvector.setI(i,j:integer);
var
  old:integer;
  flag:boolean;
begin
  if (data=nil) then
    begin
      sortieErreur(E_data);
      exit;
    end;

  old:=inf.Imax;
  flag:= FimDisplay and extend(i);

  if (i<IStart) or (i>Iend) then sortieErreurIndex(i,self)
  else
  if inf.readOnly then sortieErreur(E_readOnly)
  else data.setI(i,j);

  modifiedData:=true;
end;

function Tvector.getI(i:integer):integer;
begin
  result:=0;

  if (data=nil) then
    begin
      sortieErreur(E_data);
      exit;
    end;

  if (i>=data.indicemin) and (i<=data.indicemax)
    then result:=data.getI(i)
  else
  if (i<data.indicemin) or not Flags.FmaxIndex
    then sortieErreurIndex(i,self);
end;

procedure Tvector.setRvalue(x,y:float);
var
  i:integer;
begin
  if (data=nil) then
    begin
      sortieErreur(E_data);
      exit;
    end;

  i:=data.invconvx(x);
  setE(i,y);
end;

function Tvector.getRvalue(x:float):float;
var
  i:integer;
begin
  if (data=nil) then
    begin
      sortieErreur(E_data);
      result:=0;
      exit;
    end;

  i:=data.invconvx(x);
  result:=getE(i);
end;


procedure Tvector.setCpx(i:integer;x:TfloatComp);
var
  old:integer;
  Flag:boolean;
begin
  if (data=nil) then
    begin
      sortieErreur(E_data);
      exit;
    end;

  old:=inf.Imax;
  if extend(i) then flag:= FimDisplay else flag:=false;

  if (i<IStart) or (i>Iend) then sortieErreurIndex(i,self)
  else
  if inf.readOnly then sortieErreur(E_readOnly)
  else
  begin
    data.setCpx(i,x);
  end;
end;



function Tvector.getCpx(i:integer):TfloatComp;
begin
  result.x:=0;
  result.y:=0;

  if (data=nil) then
  begin
    sortieErreur(E_data);
    exit;
  end;

  if (i>=data.indicemin) and (i<=data.indicemax) then
    begin
      result:=data.getCpx(i);
    end
  else
  if (i<data.indicemin) or not Flags.FmaxIndex
    then sortieErreurIndex(i,self);
end;


procedure Tvector.setIm(i:integer;x:float);
var
  old:integer;
  Flag:boolean;
begin
  if (data=nil) then
    begin
      sortieErreur(E_data);
      exit;
    end;

  old:=inf.Imax;
  if extend(i) then flag:= FimDisplay else flag:=false;

  if (i<IStart) or (i>Iend) then sortieErreurIndex(i,self)
  else
  if inf.readOnly then sortieErreur(E_readOnly)
  else
  begin
    data.setIm(i,x);
  end;
end;



function Tvector.getIm(i:integer):float;
begin
  result:=0;

  if (data=nil) then
  begin
    sortieErreur(E_data);
    exit;
  end;

  if (i>=Istart) and (i<=Iend) then
    begin
      result:=data.getIm(i);
    end
  else
  if (i<Istart) or not Flags.FmaxIndex
    then sortieErreurIndex(i,self);
end;

procedure Tvector.AddE(i:integer;w:float);
begin
  if assigned(data) and (i>=Istart) and (i<=Iend) then data.addE(i,w);
end;

function Tvector.getMdl(i:integer):float;
begin
  if isComplex
    then result:=sqrt(sqr(Yvalue[i])+sqr(ImValue[i]))
    else result:=abs(Yvalue[i]);
end;

procedure Tvector.setAttValue(i:integer;w:byte);
var
  old:integer;
  Flag:boolean;
begin
  if inf.readOnly then sortieErreur(E_readOnly);
  if assigned(dataAtt) and (i>=dataAtt.indiceMin) and (i<=dataAtt.indiceMax)  then
  begin
    dataAtt.setI(i,w);
    modifiedData:=true;
  end;
end;

function Tvector.getAttValue(i:integer):byte;
begin
 if assigned(dataAtt) and (i>=dataAtt.indiceMin) and (i<=dataAtt.indiceMax)
   then result:= dataAtt.getI(i)
   else result:=0;
end;



procedure Tvector.saveData(f:Tstream);
var
  sz:integer;
begin
  sz:=(Iend-Istart+1)*tailleTypeG[tpNum];
  writeDataHeader(f,sz);
  if data=nil then sortieErreur(E_data);

  data.writeBlockToStream(f,Istart,Iend,tpNum)
end;

function Tvector.loadData(f:Tstream):boolean;
var
  size:integer;
begin
  if FlagConvertExtended and (tpNum=g_extended) then
  begin
    FlagConvertExtended:=false;
    result:= loadExtendedData(f);
    exit;
  end;

  result:=readDataHeader(f,size);
  if result=false then exit;

  {Pour les anciens fichiers mal sauvés}
  if size=0 then size:=(Iend-Istart+1)*tailleTypeG[tpNum];

  if size<>(Iend-Istart+1)*tailleTypeG[tpNum] then exit;

  data.readBlockFromStream(f,0,inf.Imin,inf.Imax,inf.tpNum);

  modifiedData:=true;
end;

function Tvector.loadExtendedData(f:Tstream): boolean;
var
  size:integer;
  buf: array of byte;
  i:integer;
begin
  result:=readDataHeader(f,size);
  if result=false then exit;

  {Pour les anciens fichiers mal sauvés}
  if size=0 then size:=(Iend-Istart+1)*10;

  if size<>(Iend-Istart+1)*10 then exit;
  inf.tpNum := g_double;
  with inf do initTemp1(Imin,Imax,tpNum);

  setlength(buf,(inf.Imax-inf.Imin+1)*10);
  f.Read(buf[0],size);

  for i:=0 to Icount-1 do PtabDouble(tb)^[i]:= extendedToDouble(buf[i*10]);



  modifiedData:=true;
end;


procedure Tvector.saveAsSingle(f:Tstream);
var
  res:integer;
begin
  if data=nil then sortieErreur(E_data);
  if inf.temp and (tpNum=G_single)
    then f.Write(tb^,totSize)
    else data.writeBlockToStream(f,Istart,Iend,G_single);
end;

procedure Tvector.SaveToBin(f:Tstream; tp:typetypeG; const i1:integer=0; const i2:integer=-1);
var
  res,iA, iB:integer;
begin
  if data=nil then sortieErreur(E_data);

  if i1>i2 then
  begin
    iA:=Istart;
    iB:=Iend;
  end
  else
  begin
    if i1<Istart then iA:=Istart else iA:=i1;
    if i2>Iend then iB:=Iend else iB:=i2;
    if iA>iB then exit;
  end;

  if inf.temp and (tpNum=tp) and (i1>i2)
    then f.Write(tb^,totSize)
    else data.writeBlockToStream(f,IA,IB,tp);
end;

procedure Tvector.LoadFromBin(f:Tstream; ByteStep: integer);
begin
  if data=nil then sortieErreur(E_data);
  data.ReadBlockFromStream(f, ByteStep, Istart,Iend, tpNum);
end;

function Tvector.loadAsSingle(f:Tstream):boolean;
begin
  result:=inf.temp and assigned(data);
  if result then
    data.readBlockFromStream(f,0,inf.Imin,inf.Imax,G_single);
end;


procedure Tvector.initList0(t_nombre:typetypeG;Fscale:boolean);
var
  OldFlags:TdataObjFlags;
begin
  if not inf.temp or inf.readOnly then exit;
  if not (typetypeG(t_nombre) in typesVecteursSupportes) then exit;

  if Fscale then
    begin
      Inf.Dxu:=1;
      Inf.x0u:=0;
      Inf.Dyu:=1;
      Inf.Y0u:=0;
    end;

  OldFlags:=flags;
  InitTemp1(1,BlocEvt,t_nombre);
  flags:=OldFlags;

  IendMax:=BlocEvt;
  inf.imax:=0;
  if assigned(data) then data.indiceMax:=0;
end;


procedure Tvector.initList(t_nombre:typetypeG);
begin
  initList0(t_nombre,true);
end;

procedure Tvector.resetList;
begin
  initList0(inf.tpNum,false);
end;


procedure Tvector.initEventList(t_nombre:typetypeG;dx:float);
begin
  if dx=0 then exit;

  initList(t_nombre);

  x0u:=0;
  dxu:=dx;
  y0u:=0;
  dyu:=dx;

  visu.modeT:=DM_evt1;
  if (Ymin=0) and (Ymax=100) then visu.Ymin:=-100;

  invalidate;
end;

procedure Tvector.addToList(x:float);
begin
  if Iend >=IendMax then
    begin
      IendMax:=Iend+BlocEvt;
      extendTemp((IendMax-Istart+1)*tailleTypeG[inf.tpNum]);
      modifyData;
    end;

  inc(inf.Imax);
  data.indicemax:=inf.Imax;
  data.setE(inf.Imax,x);
end;

procedure Tvector.RemoveFromList(index:integer);
var
  i:integer;
begin
  for i:=index to Iend-1 do data.setE(i,data.getE(i+1));
  dec(inf.Imax);
  data.indicemax:=inf.Imax;

end;

procedure Tvector.InsertIntoList(index:integer;x:float);
var
  i:integer;
begin
  addToList(0);
  for i:=Iend-1 downto index do data.setE(i+1,data.getE(i));
  data.setE(index,x);
end;


procedure Tvector.sortEventList;
begin
  if assigned(data) then data.sort(true);
end;


procedure TVector.Sort(Up: boolean);
begin
  if assigned(data) then data.sort(Up);
end;

procedure Tvector.SortWithIndex(Up:boolean; Vindex: Tvector);
begin
  if assigned(data) and assigned(Vindex) and assigned(Vindex.data) then data.sortWithIndex(Up,Vindex.data);
end;

procedure Tvector.ModifyOrder( Vindex: Tvector);
var
  i:integer;
  vi: array of integer;
  vf: array of double;
begin
  if inf.tpNum<g_longint then
  begin
    setlength(vi,Icount);
    for i:=Istart to Iend do vi[i-Istart]:= Jvalue[i];
    for i:=Istart to Iend do Jvalue[i]:= vi[ Vindex.Jvalue[i]-Istart];
  end
  else
  begin
    setLength(vf,Icount);
    for i:=Istart to Iend do vf[i-Istart]:= Yvalue[i];
    for i:=Istart to Iend do Yvalue[i]:= vf[ Vindex.Jvalue[i]-Istart];
  end;

end;

procedure Tvector.fill(y:float);
var
  i:integer;
begin
  if data=nil then exit;
  with data do
    for i:=indicemin to indicemax do setE(i,y);
end;

procedure Tvector.fill1(y:float;i1,i2:integer);
var
  i:integer;
begin
  if data=nil then
    begin
      sortieErreur(E_data);
      exit;
    end;

  extend(i2);
  if i1<Istart then i1:=Istart;
  if i2>Iend then i2:=Iend;

  with data do
    for i:=i1 to i2 do setE(i,y);
end;

procedure Tvector.fillCpx(y:TfloatComp);
var
  i:integer;
begin
  if data=nil then exit;
  for i:=Istart to Iend do setCpx(i,y);
end;

procedure Tvector.fillCpx1(y:TfloatComp;i1,i2:integer);
var
  i:integer;
begin
  if data=nil then
    begin
      sortieErreur(E_data);
      exit;
    end;

  extend(i2);
  if i1<Istart then i1:=Istart;
  if i2>Iend then i2:=Iend;

  for i:=i1 to i2 do setCpx(i,y);
end;



procedure Tvector.Vmoveto(x,y:float);
begin
  xpaint:=x;
  ypaint:=y;
end;

procedure Tvector.Vlineto(x,y:float);
var
  i,i1,i2:integer;
  a:float;
begin
  if (data=nil) then
    begin
      sortieErreur(E_data);
      exit;
    end;

  i1:=data.invconvx(xpaint);
  i2:=data.invconvx(x);

  extend(i2);

  if (x=xpaint) then
    begin
      if (i2>=data.indicemin) and (i2<=data.indicemax) then
        begin
           data.setE(i2,y);
           exit;
        end;
    end;

  a:=(y-ypaint)/(x-xpaint);
  if i1<data.indicemin then i1:=data.indicemin;
  if i2>data.indicemax then i2:=data.indicemax;

  for i:=i1 to i2 do data.setE(i,a*(convx(i)-xpaint)+ypaint);

  xpaint:=x;
  ypaint:=y;
end;

function Tvector.inRangeI(i:integer):boolean;
begin
  result:=assigned(data) and (i>=Istart) and (i<=Iend);
end;

{
Renvoie l'indice du premier événement de date supérieure ou égale à x .
Le vecteur doit contenir des dates d'événements, c'est à dire une suite de nombres croissants, sinon le résultat est imprévisible.
Lorsqu'il n'existe aucun événement de date supérieure à x, la fonction renvoie Iend+1 .

La recherche peut être limitée à l'intervalle min--max
}


function Tvector.getFirstEvent(x:float;const min1:integer=-1;const max1:integer=-1):integer;
var
  min,max,k:integer;
  x1:float;
begin
  if not assigned(data) then
  begin
    result:=Iend+1;
    exit;
  end;

  if (min1=-1) and (max1=-1) then
  begin
    min:=Istart;
    max:=Iend;
  end
  else
  begin
    min:=min1;
    if min<Istart then min:=Istart;
    max:=max1;
    if max>Iend then max:=Iend;
  end;

  if max<min then
    begin
      result:=0;
      exit;
    end
  else
  if x<=data.getE(min) then
    begin
      result:=min;
      exit;
    end
  else
  if x>data.getE(max) then
    begin
      result:=max+1;
      exit;
    end;

  repeat
    k:=(max+min) div 2;
    x1:=data.getE(k);
    if x1<x then min:=k
    else
    if x1>x then max:=k;
  until (max-min<=1) or (x=x1);
  if x=x1 then result:=k
          else result:=max;
end;

function Tvector.empty:boolean;
begin
  result:=assigned(data) and (Iend>=Istart);
end;

procedure Tvector.fileSaveData(sender:Tobject);
var
  i:integer;
  ac1:Tdac2file;
begin
  if not assigned(vecToSave) then vecToSave:=Tlist.create;
  if vectoSave.count=0 then vectoSave.add(self);

  DetectSave.installXorg(XorgSave);
  DetectSave.installAppend(AppendSave);
  DetectSave.installContinu(ContSave);

  if not DetectSave.execution(Tvector,ident+' Save',VectoSave,
                             XstartSave,XendSave,Xstart,Xend,
                             saveRec)
    then exit;

  if not sauverFichierStandard(stSave,'DAT') then exit;

  if not AppendSave and fileExists(stSave) then
    if MessageDlg('File already exists. Continue ?',mtConfirmation,[mbYes,mbNo],0)<>mrYes
      then exit;



  ac1:=Tdac2File.create;

  ac1.channelCount:=VecToSave.count;

  ac1.Xorg:=XorgSave;
  for i:=0 to VecToSave.count-1 do
    ac1.setChannel(i+1,Tvector(VecToSave.items[i]),XstartSave,XendSave);

  ac1.continu:=ContSave;
  ac1.InstalleOptions(saveRec);

  if AppendSave then
    begin
      ac1.append(stSave);
      if ac1.error<>0 then
        begin
          messageCentral('Error opening '+stSave);
          ac1.free;
          exit;
        end;
    end
  else
    begin
      ac1.createFile(stSave);
      if ac1.error<>0 then
        begin
          messageCentral('Error creating '+stSave+' '+Istr(ac1.error));
          ac1.free;
          exit;
        end;
    end;

  ac1.save;
  if ac1.error<>0 then
    begin
      messageCentral('Error saving '+stSave+' '+Istr(ac1.error));
      ac1.free;
      exit;
    end;

  ac1.close;
  ac1.free;
end;


procedure Tvector.FileLoadFromVector(sender:Tobject);
begin
  LoadFromVecDlg.execution(self);
end;

procedure Tvector.FileLoadFromObjFile(sender:Tobject);
var
  objF:TobjectFile;
  ob:Tvector;
begin
  objF:=TobjectFile.create;

  try
  with objF do
  begin
    initialise('ObjF');
    command.Caption:='Choose a vector';
    notPublished:=true;
    ChooseObject(Tvector,typeUO(ob));
  end;

  if assigned(ob) then proVcopy(ob,self);

  finally
  objF.free;
  end;
end;

function Tvector.getPopUp:TpopupMenu;
var
  mi,cursorItem:TmenuItem;
  i:integer;
begin

  with PopUps do
  begin
    PopUpItem(pop_Tvector,'Tvector_FileSaveData').onclick:=FileSaveData;
    PopUpItem(pop_Tvector,'Tvector_FileSaveObject').onclick:=SaveObjectToFile;

    PopUpItem(pop_Tvector,'Tvector_FileLoadFromVector').onclick:=FileLoadFromVector;
    PopUpItem(pop_Tvector,'Tvector_FileLoadFromObjectFile').onclick:=FileLoadFromObjFile;

    PopUpItem(pop_Tvector,'Tvector_Clone').onclick:=CreateClone;
    PopUpItem(pop_Tvector,'Tvector_Image').onclick:=CreateImage;

    PopUpItem(pop_Tvector,'Tvector_Coordinates').onclick:=ChooseCoo;
    PopupItem(pop_Tvector,'Tvector_Show').onclick:=self.Show;
    PopupItem(pop_Tvector,'Tvector_Properties').onclick:=Proprietes;
    PopupItem(pop_Tvector,'Tvector_Edit').onclick:=EditVector;

    PopupItem(pop_Tvector,'Tvector_Cursors_New').onclick:=NewCursorClick;

    cursorItem:=PopupItem(pop_Tvector,'Tvector_Cursors');
    with cursorItem do
    begin
      for i:=count-1 downto 1 do
        begin
          mi:=items[i];
          delete(i);
          mi.free;
        end;
    end;

    for i:=1 to sysList.count do
      if (typeUO(syslist[i-1]) is TLcursor) and (TLcursor(syslist[i-1]).rec.obref=self) then
      begin
        mi:=TmenuItem.create(cursorItem);
        mi.caption:=TLcursor(syslist[i-1]).ident;
        mi.tag:=i-1;
        mi.onClick:=CursorClick;
        cursorItem.add(mi);
      end;

    result:=pop_Tvector;
  end;
end;



procedure Tvector.invalidate;
begin
  inherited invalidate;
  {updateEditForm;}
end;

procedure Tvector.invalidateData;
var
  flag:boolean;
begin
  inherited;
  updateEditForm;
end;


procedure Tvector.onDisplayPoint(i:integer);
var
  col:integer;
begin
  if onDP.valid then
  begin
    onDP.pg.executerGetPointColor(onDP.ad,i,col);
    canvasGlb.pen.color:=col;
    canvasGlb.brush.color:=col;
  end
  else
  if assigned(OnDPsys) then OnDPsys(i);
end;

procedure Tvector.specialDrop(Irect:Trect;x,y:integer);
var
  xr,yr:float;
begin
  with Irect do setWindow(left,top,right,bottom);
  Dgraphic.setWorld(Xmin,Ymin,Xmax,Ymax);

  xr:=invconvWx(x);
  yr:=invconvWy(y);

  with onDragDrop do
    if valid then pg.executerOnDragDrop(ad,typeUO(self),xr,yr);

  if assigned(FonDragDrop) then FonDragDrop(xr,yr);
end;

{ExtendDim essaie de modifier au mieux les propriétés du vecteur
 en fonction de source.
}

procedure Tvector.extendDim(source:Tvector;tp:typetypeG);
var
  tp1:typetypeG;
begin
  if inf.readOnly then exit;

  if (tp in typesVecteursSupportes) and flags.Ftype
    then tp1:=tp
    else tp1:=inf.tpNum;

  if flags.Findex then
    begin
      if (source.Istart<>Istart) or (source.Iend<>Iend) or (tp1<>tpNum)
        then initTemp1(source.Istart,source.Iend,tp1);
    end
  else
  if flags.FmaxIndex then
    begin
      if (source.Iend<>Iend)  then initTemp1(Istart,source.Iend,tpNum);
    end;
end;

{Modifie les indices de début et de fin mais pas le type de nombre.
 Renvoie true si l'opération est possible
}
function Tvector.AdjustIstartIend(source:Tvector):boolean;
begin
  result:=false;
  if not inf.temp or inf.readOnly then exit;

  if flags.Findex or flags.FmaxIndex and (source.Istart=1) then
    begin
      if (source.Istart<>Istart) or (source.Iend<>Iend)
        then initTemp1(source.Istart,source.Iend,tpNum);
      result:=true;
    end;
end;


{Modifie les indices de début et de fin et impose un type de nombre.
 Renvoie true si l'opération est possible
}
function Tvector.AdjustIstartIend1(source:Tvector;tp:typetypeG):boolean;
begin
  result:=false;
  if not inf.temp or inf.readOnly then exit;

  if flags.Findex or flags.FmaxIndex and (source.Istart=1) then
    begin
      if (source.Istart<>Istart) or (source.Iend<>Iend) or (tp<>tpNum)
        then initTemp1(source.Istart,source.Iend,tp);
      result:=true;
    end;
end;


function Tvector.AdjustIstartIendTpNum(source:Tvector):boolean;
begin
  result:=false;
  if not inf.temp or inf.readOnly then exit;

  if flags.Ftype and (flags.Findex or flags.FmaxIndex and (source.Istart=1)) then
    begin
      if (source.Istart<>Istart) or (source.Iend<>Iend) or (source.tpNum<>tpNum)
        then initTemp1(source.Istart,source.Iend,source.tpNum);
      result:=true;
    end;
end;


function Tvector.extendDim1(i1,i2:integer;tp:typetypeG):boolean;
var
  tp1:typetypeG;
  ii:integer;
begin
  result:=false;
  if inf.readOnly then exit;

  if (tp in typesVecteursSupportes) and flags.Ftype
    then tp1:=tp
    else tp1:=inf.tpNum;

  if flags.Findex then
    begin
      if (Istart<>i1) or (Iend<>i1) or (tp1<>tpNum) then initTemp1(i1,i2,tp1);
      result:=true;
    end
  else
  if (i1=1) and flags.FmaxIndex  then
    begin
      initTemp1(1,i2,tpNum);
      result:=true;
    end;
end;


procedure Tvector.cadrageX(var i1,i2:integer);
begin
  if i1<Istart then i1:=Istart;
  if i2>Iend then i2:=Iend;

  if i1>i2 then sortieErreur('Tvector : invalid bounds');
end;

procedure Tvector.ControleReadOnly;
begin
  if inf.readOnly then sortieErreur(E_readOnly);
end;


Procedure Tvector.AddInt(vec1:Tvector;x1,x2:float);
var
  i,k:integer;

begin
  if not assigned(data) or
     not assigned(vec1) or vec1.empty then exit;

  for i:=vec1.getFirstEvent(x1) to vec1.getFirstEvent(x2)-1 do
    begin
      k:=trunc((vec1.getE(i+1)-vec1.getE(i))/Dxu);

      if (k>=Istart) and (k<=Iend) then data.addI(k,1);
      if k>Iend then exit;
    end;
end;

function Tvector.getInfo:AnsiString;
begin

  result:= inherited getInfo +
          'onControl='+Bstr(onControl)+CRLF+
          'onScreen='+Bstr(onScreen)+CRLF+
          'NotPublished='+Bstr(NotPublished)+CRLF+
          'Fchild='+Bstr(Fchild)+CRLF+
          'FSload='+Bstr(FsingleLoad)+CRLF+
          'stCOM='+stComment+CRLF+
          'BKcolor='+Istr(BKcolor)+CRLF;

  result:=result+
          'FormRec='+FormRec.info+CRLF+
          'Title='+title0+CRLF;

  result:=result+visu.Info('visu.')+CRLF;

  result:=result+
          inf.info+CRLF+
          'totSize='+Istr(totSize)+CRLF;


end;

procedure Tvector.getMinMax(var y1,y2:float);
var
  min,max:float;
begin
  if assigned(data) then
  begin
    data.LimitesY(min,max,data.indiceMin,data.indiceMax);
    if min<y1 then y1:=min;
    if max>y2 then y2:=max;
  end;
end;

{Dans les fonctions suivantes, le résultat est le pointeur sur l'élément d'indice 0
 même s'il n'existe pas.

 De cette façon, tbSingle[Istart] représente le premier élément du vecteur.
}

function Tvector.tbSmallint:PtabEntier;
begin
  if inf.temp and (tpNum=G_smallint)
    then result:=@PtabEntier(tb)^[-Istart]
    else result:=nil;
end;

function Tvector.tbLong:PtabLong;
begin
  if inf.temp and (tpNum=G_longint)
    then result:=@PtabLong(tb)^[-Istart]
    else result:=nil;
end;

function Tvector.tbSingle:PtabSingle;
begin
  if inf.temp and (tpNum=G_single)
    then result:=@PtabSingle(tb)^[-Istart]
    else result:=nil;
end;

function Tvector.tbDouble:PtabDouble;
begin
  if inf.temp and (tpNum=G_double)
    then result:=@PtabDouble(tb)^[-Istart]
    else result:=nil;
end;

function Tvector.tbSingleComp:PtabSingleComp;
begin
  if inf.temp and (tpNum=G_singleComp)
    then result:=@PtabSingleComp(tb)^[-Istart]
    else result:=nil;
end;

function Tvector.tbDoubleComp:PtabDoubleComp;
begin
  if inf.temp and (tpNum=G_doubleComp)
    then result:=@PtabDoubleComp(tb)^[-Istart]
    else result:=nil;
end;


function Tvector.sumI:integer;
var
  i:integer;
begin
  result:=0;
  if data=nil then exit;
  for i:=Istart to Iend do result:=result+data.getI(i);
end;

procedure Tvector.DoImDisplay;
begin
  messageImDisplay(lastIm+1,Iend);
  lastIm:=Iend;
end;

function Tvector.clone(Fdata:boolean; const Fref:boolean=true):typeUO;
begin
  result:=inherited clone(Fdata);

  Tvector(result).inf.readOnly:=false;
end;

{ CopyDataFromVec ne modifie pas la structure du vecteur et copie toutes les
  données possibles.
}
procedure Tvector.copyDataFromVec(source:Tvector;i1,i2,iD:integer);
var
  i,ifin:integer;
  tailleBuf,n,size:integer;
  buf:PtabEntier;
begin
  if (data=nil) or (source.data=nil) {or (source.dxu<>dxu)} then exit;

  ifin:=id+i2-i1;

  // correction mai 2013
  // on doit transférer de source(i1,i2) vers (id,ifin);
  // on corrige les bornes pour rester dans les deux segments.

  if i1<source.Istart then
  begin
    id:=id+ source.Istart-i1;
    i1:= source.Istart;
  end;

  if i2>source.Iend then
  begin
    ifin:=ifin - (source.Iend-i2);
    i2:=source.Iend;
  end;

  if id< Istart then
  begin
    i1:=i1+Istart-id;
    id:=Istart;
  end;

  if ifin>Iend then
  begin
    i2:=i2-(ifin-Iend);
    ifin:=Iend;
  end;

  if (i2<i1) or (ifin<id) then exit;


  source.data.open;
  data.open;

  {copie par move si possible}
  if source.inf.temp and inf.temp and (source.tpNum=tpNum) and
     ((tpNum>=g_single) or (source.dyu=Dyu) and (source.y0u=y0u))  then
  begin
    size:=tailleTypeG[tpNum];
    move(PtabOctet(source.tb)^[(i1-source.Istart)*size],
                   PtabOctet(tb)^[(id-Istart)*size],
                   (ifin-id+1)*size);
  end
  else
  {copie des smallint avec getBlockI-setBlockI}
  if (tpNum=G_smallint) and (source.tpNum=G_smallint) and
     (dyu=source.dyu) and (y0u=source.y0u)  then
    begin
      tailleBuf:=60000;
      if tailleBuf>maxAvail then tailleBuf:=maxAvail;
      getMem(buf,tailleBuf);

      i:=id;

      repeat
        n:=tailleBuf div 2;
        if i+n>ifin then n:=ifin-i+1;
        source.data.getBlockI(i+i1-id,buf,n);
        data.setBlockI(i,buf,n);
        i:=i+n;
      until i>ifin;

      freemem(buf,tailleBuf);
    end
  else
  {copie des single avec getBlockS-setBlockS}
  if (tpNum=G_single) and (source.tpNum=G_single) then
    begin
      tailleBuf:=60000;
      if tailleBuf>maxAvail then tailleBuf:=maxAvail;
      getMem(buf,tailleBuf);

      i:=id;
      repeat
        n:=tailleBuf div 4;
        if i+n>ifin then n:=ifin-i+1;
        source.data.getBlockS(i+i1-id,PtabSingle(buf),n);
        data.setBlockS(i,PtabSingle(buf),n);
        i:=i+n;
      until i>ifin;

      freemem(buf,tailleBuf);
    end
  else
  {cas général non complexe}
  if (tpNum<G_singleComp) and (source.tpNum<G_single) then
    for i:=id to ifin do
      data.setE(i,source.data.getE(i+i1-id))
  else
  {cas général complexe}
  begin
    for i:=id to ifin do
      data.setCpx(i,source.data.getCpx(i+i1-id));
  end;

  source.data.close;
  data.close;
  modifiedData:=true;
end;

procedure TVector.copyDataFrom(p: typeUO);
begin
  if p is Tvector
    then copyDataFromVec(Tvector(p),Istart,Iend,Tvector(p).Istart);
end;


procedure Tvector.NewCursorClick(sender:Tobject);
var
  cur:TLcursor;
begin
  cur:= TLcursor(nouvelObjet1(TLcursor));
  if assigned(cur) then
  with cur do
  begin
    rec.visible:=true;
    rec.style:=csIndex;
    rec.WinContent:=wcXpY;
    installSource(self);

    show(nil);
  end;
end;


procedure Tvector.CursorClick(sender:Tobject);
begin
  TLcursor(syslist[TmenuItem(sender).tag]).show(nil);
end;



procedure TVector.setIcount(n:integer);
begin
  if strucModif(tpNum,Istart,Istart+n-1)
    then modifyTemp1(Istart,Istart+n-1)
    else sortieErreur('Tvector : cannot modify Icount');
end;


function TVector.ChooseCoo1: boolean;
begin
  result:=inherited chooseCoo1;
end;


{Renvoie true si la structure du vecteur peut être modifiée avec les paramètres
 Ne vérifie pas si i2>=i1 et tp valable.
}
function Tvector.strucModif(tp:typeTypeG;i1,i2:integer):boolean;
begin
  result:= inf.temp and
           not inf.readOnly and
          ((tp=tpNum) and (i1=Istart) and (i2=Iend)
            OR
            flags.Ftype
            and
            (flags.Findex or (flags.FmaxIndex and (i1=1))
           )
          );
end;

procedure Tvector.modify(tNombre:typeTypeG;i1,i2:integer);
begin
  if strucModif(tNombre,i1,i2)
    then initTemp1(i1,i2,tNombre);
end;

procedure TVector.createImage(sender: Tobject);
var
  p:TimageVector;
begin
  typeUO(p):=creerObjet(TimageVector);
  if assigned(p) then
  begin
    p.installSource(self);

    p.Xmin:=Xmin;
    p.Xmax:=Xmax;
    p.Ymin:=Ymin;
    p.Ymax:=Ymax;


    p.show(nil);
  end;
end;


{ Vcopy ne modifie pas tpNum
        appelle intiTemp1 seulement si nécessaire
}
procedure TVector.Vcopy(vec:Tvector);
var
  i:integer;
begin
  if not inf.temp or not assigned(vec) or (vec.Iend<vec.Istart)
    then exit;

  if (Istart<>vec.Istart) or (Iend<>vec.Iend)
    then initTemp1(vec.Istart,vec.Iend,tpNum);

  if vec.inf.temp and (vec.tpNum=tpNum)
    then move(vec.tb^,tb^,totSize)
  else
  if isCpx then
    for i:=Istart to Iend do Cpxvalue[i]:=vec.Cpxvalue[i]
  else
  for i:=Istart to Iend do Yvalue[i]:=vec.Yvalue[i];
end;


procedure TVector.Vadd(vec:Tvector);
var
  i:integer;
  ok:boolean;
  z,zvec:TfloatComp;
begin
  IPPStest;
  if not inf.temp or not assigned(vec) or (Istart<>vec.Istart) or (Iend<>vec.Iend)
  or (Iend<Istart)
    then exit;

  ok:=true;
  if vec.inf.temp and (vec.tpNum=tpNum) then
    case tpNum of
      G_single: ippsAdd(vec.tbS, tbS, Icount);
      G_double: ippsAdd(vec.tbD, tbD, Icount);
      G_SingleComp: ippsAdd(vec.tbSC, tbSC, Icount);
      G_DoubleComp: ippsAdd(vec.tbDC, tbDC, Icount);

      else ok:=false;
    end
  else ok:=false;

  if not ok then
    begin
      if isCpx then
        for i:=Istart to Iend do
          begin
            z:=Cpxvalue[i];
            zvec:=vec.Cpxvalue[i];
            z.x:=z.x+zvec.x;
            z.y:=z.y+zvec.y;
            Cpxvalue[i]:=z;
          end
      else
        for i:=Istart to Iend do Yvalue[i]:=Yvalue[i]+vec.Yvalue[i];
    end;

  IPPSend;
end;

procedure TVector.VaddSqrs(vec:Tvector);
var
  i:integer;
  ok:boolean;
begin
  if not inf.temp or not assigned(vec) or (Istart<>vec.Istart) or (Iend<>vec.Iend)
  or (Iend<Istart)
    then exit;

  if vec.isCpx then
    for i:=Istart to Iend do
      data.addE(i,sqr(vec.data.getE(i))+sqr(vec.data.getIm(i)))
  else
    for i:=Istart to Iend do
      data.addE(i,sqr(vec.data.getE(i)));

end;

function TVector.sum(i1, i2: integer): float;
begin
  result:=data.sum(i1,i2);
end;

function TVector.sumSqrs(i1, i2: integer): float;
begin
  result:=sqr(data.NormL2(i1,i2));
end;


function TVector.sumMdls(i1, i2: integer): float;
begin
  result:=sqr(data.NormL1(i1,i2));
end;

function TVector.sumPhi(i1, i2: integer): float;
var
  i:integer;
  x,y:float;
begin
  result:=0;
  y:=0;
  if isCpx then
    for i:=i1 to i2 do
      y:=y+data.getIm(i);

  x:=0;
  for i:=i1 to i2 do
    x:=x+data.getE(i);

  if x<>0
    then result:=arctan2(y,x);
end;


function TVector.sum0: float;
begin
  result:=sum(Istart,Iend);
end;

function TVector.sumSqrs0: float;
begin
  result:=sumSqrs(Istart,Iend);
end;


function TVector.sumMdls0: float;
begin
  result:=sumMdls(Istart,Iend);
end;

function TVector.sumPhi0: float;
begin
  result:=sumPhi(Istart,Iend);
end;

function Tvector.maxi0:float;
begin
  if assigned(data)
    then result:=data.maxi(Istart,Iend)
    else result:=0;
end;

function Tvector.mini0:float;
begin
  if assigned(data)
    then result:=data.mini(Istart,Iend)
    else result:=0;
end;

function Tvector.maxiX0:float;
begin
  if assigned(data)
    then result:=convx(data.maxiX(Istart,Iend))
    else result:=0;
end;

function Tvector.miniX0:float;
begin
  if assigned(data)
    then result:=convx(data.miniX(Istart,Iend))
    else result:=0;
end;




procedure Tvector.NormalizeValues;
var
  i:integer;
  x,y,m:float;
begin
  if isCpx then
    for i:=Istart to Iend do
    begin
      x:=data.getE(i);
      y:=data.getIm(i);
      m:=sqrt(sqr(x)+sqr(y));
      if m>0 then
      begin
        data.setE(i,x/m);
        data.setIm(i,y/m);
      end;
    end;
end;


function Tvector.IntAbove(x1c,x2c,y0:float;var len:float):float;
var
  i,j:integer;
  tot:integer;
  Ytot,y:float;
  J0:integer;
  i1c,i2c:integer;
  cntLen:integer;
begin
  i1c:=invConvX(x1c);
  i2c:=invConvX(x2c);
  if i1c<Istart then i1c:=Istart;
  if i2c>Iend then i2c:=Iend;

  data.open;
  Ytot:=0;
  cntLen:=0;
  for i:=I1c to I2c do
  begin
    y:=data.getE(i);
    if y>=y0 then
    begin
      Ytot:=Ytot+y-Y0;
      inc(cntLen);
    end;
  end;
  len:=cntLen*Dxu;
  result:=Dxu*Ytot;

  data.close;
end;

function Tvector.IntBelow(x1c,x2c,y0:float;var len:float):float;
var
  i,j:integer;
  tot:integer;
  Ytot,y:float;
  J0:integer;
  i1c,i2c:integer;
  cntLen:integer;
begin
  i1c:=invConvX(x1c);
  i2c:=invConvX(x2c);

  data.open;

  Ytot:=0;
  cntLen:=0;
  for i:=I1c to I2c do
  begin
    y:=data.getE(i);
    if y<=y0 then
    begin
      Ytot:=Ytot+Y0-y;
      inc(cntLen);
    end;
  end;
  len:=cntLen*Dxu;
  result:=Dxu*Ytot;

  data.close;
end;

{ MaxLis trouve le max sur les valeurs moyennes de groupes de N points consécutifs
  et renvoie  la valeur trouvée vm ainsi que la position vt.
}
procedure TVector.maxLis(x1, x2: float; N: integer; var Vm, xm: float);
var
  i:integer;
  i1,i2,Nt:integer;
  v:float;
  im:integer;
begin
  i1:=invconvx(x1);
  i2:=invconvx(x2);
  Nt:=i2-i1+1;
  if N>Nt then exit;

  v:=0;
  for i:=0 to N-1 do v:=v+Yvalue[i1+i];

  vm:=v;
  im:=0;
  for i:=N to Nt-1 do
  begin
     v:=v+Yvalue[i1+i]-Yvalue[i1+i-N];
     if v>vm then
       begin
         vm:=v;
         im:=i-N+1;
       end;
  end;
  vm:=vm/N;
  xm:=convx(i1+im);
end;

procedure Tvector.Threshold(th:float;Fup,Fdw:boolean);
var
  i:integer;
  y:float;
begin
  for i:=Istart to Iend do
  begin
    y:=Yvalue[i]-th;
    if Fup and (y>0) then Yvalue[i]:=y
    else
    if Fdw and (y<0) then Yvalue[i]:=-y
    else Yvalue[i]:=0;
  end;
end;

procedure Tvector.Threshold1(th:float);
var
  i:integer;
begin
  for i:=Istart to Iend do
    Yvalue[i]:=ord(Yvalue[i]>=th);
end;

procedure Tvector.Threshold2(th1,th2,val1,val2:float);
var
  i:integer;
  y:float;
begin
  for i:=Istart to Iend do
  begin
    y:=Yvalue[i];
    if y<th1 then Yvalue[i]:=val1
    else
    if y>th2 then Yvalue[i]:=val2;
  end;
end;


function TVector.DeltaLevel(flag:boolean;x, y: float):float;
begin
  if flag and (x>=Xstart) and (x<=Xend) and assigned(data)
    then result:=Rvalue[x]-y
    else result:=0;
end;


function TVector.getP(i: integer): pointer;
begin
  result:=data.getP(i);
end;

function TVector.isModified: boolean;
begin
  result:=inherited isModified;
end;

function Tvector.isZero: boolean;
var
  i:integer;
begin
  result:=true;
  for i:=Istart to Iend do
    if Yvalue[i]<>0 then
    begin
      result:=false;
      exit;
    end;
end;

procedure TVector.Vrandom(y1, y2: float);
var
  i:integer;
begin
  if readOnly then exit;
  for i:=Istart to Iend do
    Yvalue[i]:=y1+(y2-y1)*random;
end;


function Tvector.getMxArray(Const tpdest0:typetypeG = G_none):MxArrayPtr;
var
  OKmove:boolean;
  complexity:mxComplexity;
  classID:mxClassID;
  t:pointer;
  i:integer;
  tpDest:typetypeG;
begin
  result:=nil;
  if not testMatlabMat then exit;
  if not testMatlabMatrix then exit;

  if (Icount<=0) then
  begin
    sortieErreur('Tvector.SaveToMatFile : source is empty');
    exit;
  end;

  if tpDest0=G_none
    then tpDest:= g_double
    else tpDest:=tpDest0;

  if not (tpDest in MatlabTypes) then
  begin
    sortieErreur('Tvector.SaveToMatFile : invalid type');
    exit;
  end;

  OKmove:= inf.temp and (tpNum in [G_single..G_double]) and (complexity=mxReal) and (tpNum=tpDest);

  classId:=TpNumToClassId(tpDest);
  complexity:=tpNumToComplexity(tpDest);

  result:=mxCreateNumericMatrix(Icount,1,classID,complexity);
  if result=nil then
  begin
    sortieErreur('Tvector.SaveToMatFile : error 1');
    exit;
  end;

  t:= mxGetPr(result);
  if t=nil then
  begin
    sortieErreur('Tvector.SaveToMatFile : error 2');
    exit;
  end;

  if OKmove then  move(tb^,t^,Icount*tailleTypeG[tpNum])
  else
  begin
    case tpDest of
      G_byte:         for i:=Istart to Iend do PtabOctet(t)^[i-Istart]:=Jvalue[i];
      G_short:        for i:=Istart to Iend do PtabShort(t)^[i-Istart]:=Jvalue[i];
      G_smallint:     for i:=Istart to Iend do PtabEntier(t)^[i-Istart]:=Jvalue[i];
      G_word:         for i:=Istart to Iend do PtabWord(t)^[i-Istart]:=Jvalue[i];
      G_longint:      for i:=Istart to Iend do PtabLong(t)^[i-Istart]:=Jvalue[i];
      G_single,
      G_singleComp:   for i:=Istart to Iend do PtabSingle(t)^[i-Istart]:=Yvalue[i];
      G_double,
      G_doubleComp,
      G_real,
      G_extended:     for i:=Istart to Iend do PtabDouble(t)^[i-Istart]:=Yvalue[i];
    end;

    t:= mxGetPi(result);
    if (complexity=mxComplex) and assigned(t) then
      if tpDest=g_singleComp
        then for i:=Istart to Iend do PtabSingle(t)^[i-Istart]:=Imvalue[i]
        else for i:=Istart to Iend do PtabDouble(t)^[i-Istart]:=Imvalue[i];
  end;
end;

procedure Tvector.setMxArray(mxArray:MxArrayPtr;Const invertIndices:boolean=false);
var
  classID:mxClassID;
  isComp:boolean;
  t:pointer;
  tp:typetypeG;
  Nx,Ny:integer;
  OKmove:boolean;
  i:integer;
  Ndim:integer;
  PNb:PtabLong1;
  getV:TUgetV;
begin
  if not inf.temp then exit;
  if not assigned(mxArray) then exit;

  classID:=mxGetClassID(mxArray);
  isComp:= (mxGetPi(mxArray)<>nil);
  tp:=classIDtoTpNum(classID,isComp);

  case classID of
    mxInt8_class:   getV:= UgetShort;
    mxUInt8_class:  getV:= UgetByte;
    mxInt16_class:  getV:= UgetSmallInt;
    mxUInt16_class: getV:= Ugetword;
    mxInt32_class:  getV:= Ugetlong;
    mxUInt32_class: getV:= Ugetlongword;
    mxsingle_class: getV:= UgetSingle;
    mxDouble_class: getV:= UgetDouble;
    else exit;
  end;

  if not(tp in typesVecteursSupportes) then
  case tp of
    g_byte,g_short: tp:=g_smallint;
  end;

  Ndim:=mxgetNumberOfDimensions(mxArray);
  pNb:=mxgetDimensions(mxArray);

  nx:=pNb^[1];
  if Ndim>1 then ny:=pNb^[2] else ny:=1;

  if (nx=1) and (ny>1) then nx:=ny;

  t:= mxGetPr(mxArray);

  if assigned(t) and (Nx>0) then
  begin
    initTemp1(Istart,Istart+nx-1,tp);
    OKmove:= (tpNum in [G_byte..G_single,G_double]);

    if oKmove then move(t^,tb^,Icount*tailleTypeG[tpNum])
    else
    for i:=Istart to Iend do Yvalue[i]:= getV(t,i -Istart);

    if isComp then
    begin
      t:= mxGetPi(mxArray);
      for i:=Istart to Iend do Imvalue[i]:=getV(t,i-Istart);
    end;
  end;
end;


function TVector.getMean(x1, x2: float): float;
var
   i1,i2:integer;
begin
  if assigned(data) then
  begin
    i1:=data.invConvX(x1);
    i2:=data.invConvX(x2);
    cadrageX(i1,i2);
    result:= data.moyenne(i1,i2);
  end
  else result:=0;
end;

function TVector.getCpxMean(x1, x2: float): TfloatComp;
var
   i1,i2:integer;
begin
  if assigned(data) then
  begin
    i1:=data.invConvX(x1);
    i2:=data.invConvX(x2);
    cadrageX(i1,i2);
    result:= data.moyenneComp(i1,i2);
  end
  else result:=CpxNumber(0,0);
end;


{****************************************************************************}

procedure verifierVecteur(var pu:Tvector);
begin
  if (@pu=nil) or not assigned(pu) or not assigned(pu.data)
    then sortieErreur(E_Vecteur);
end;

procedure verifierVecteurTemp(var pu:Tvector);
begin
  if (@pu=nil) or not assigned(pu) or not assigned(pu.data)
    then sortieErreur(E_Vecteur);
  if not pu.inf.temp {or not assigned(pu.tb)}
    then sortieErreur(E_VecteurTemp);
end;

procedure verifierVecteurRW(var pu:Tvector);
begin
  verifierVecteur(pu);
  pu.ControleReadOnly;
end;

{***************** Méthodes STM pour Tvector ********************************}

procedure proTvector_create(name:AnsiString;t:smallint;n1,n2:longint;var pu:typeUO);
begin
  if not (typeTypeG(t) in typesVecteursSupportes)
    then sortieErreur(E_typeNombre);

  if n2<n1-1 then  sortieErreur(E_indexOrder);

  createPgObject(name,pu,Tvector);

  with Tvector(pu) do
  begin
    initTemp1(n1,n2,TypetypeG(t));
  end;
end;

procedure proTvector_create_1(t:smallint;n1,n2:longint;var pu:typeUO);
begin
  proTvector_create('',t,n1,n2,pu);
end;

procedure proTvector_create_2(var pu:typeUO);
begin
  proTvector_create('',ord(g_single),0,0,pu);
end;

procedure proTVector_modify(t:smallint;i1,i2:integer;var pu:typeUO);
  begin
    if not assigned(pu) then proTvector_create('',t,i1,i2,pu);
    verifierObjet(pu);
    with Tvector(pu) do
    begin
      if not strucModif(typetypeG(t),i1,i2) then sortieErreur(E_modify2);

      if i2<i1-1 then  sortieErreur(E_indexOrder);
      if not (typetypeG(t) in typesVecteursSupportes)
        then  sortieErreur(E_modify1);

      modify(TypetypeG(t),i1,i2);
    end;
  end;



procedure proTVector_Jvalue(i:longint;j:longint;var pu:typeUO);
  begin
    verifierVecteur(Tvector(pu));
    with Tvector(pu) do Jvalue[i]:=j;
  end;

function fonctionTVector_Jvalue(i:longint;var pu:typeUO):longint;
  begin
    verifierVecteur(Tvector(pu));

    result:=Tvector(pu).Jvalue[i];
  end;


procedure proTVector_Yvalue(i:longint;y:float;var pu:typeUO);
  begin
    verifierVecteur(Tvector(pu));
    with Tvector(pu) do Yvalue[i]:=y;
  end;

function fonctionTVector_Yvalue(i:longint;var pu:typeUO):float;
  begin
    verifierVecteur(Tvector(pu));
    result:=Tvector(pu).Yvalue[i];
  end;


procedure proTVector_Rvalue(x,y:float;var pu:typeUO);
  var
    i:longint;
  begin
    verifierVecteur(Tvector(pu));
    with Tvector(pu) do Rvalue[x]:=y;
  end;

function fonctionTVector_Rvalue(x:float;var pu:typeUO):float;
  begin
    verifierVecteur(Tvector(pu));
    with Tvector(pu) do
      fonctionTVector_Rvalue:=getRvalue(x);{ getE(invconvX(x));}
  end;



procedure proTVector_getMinMax(var min,max:float;var pu:typeUO);
var
  min1,max1:float;
begin
  verifierVecteur(Tvector(pu));
  with Tvector(pu) do getMinMax(min,max);
end;

function FonctionTvector_Mean(var pu:typeUO):float;
begin
  verifierVecteur(Tvector(pu));
  with Tvector(pu) do
    result:=getMean(Xstart,Xend);
end;

function FonctionTvector_Mean_1(x1,x2:float;var pu:typeUO):float;
begin
  verifierVecteur(Tvector(pu));
  result:= Tvector(pu).getMean(x1,x2);
end;

function FonctionTvector_CpxMean(var pu:typeUO):TfloatComp;
begin
  verifierVecteur(Tvector(pu));
  with Tvector(pu) do
    result:=getCpxMean(Xstart,Xend);
end;

function FonctionTvector_CpxMean_1(x1,x2:float;var pu:typeUO):TfloatComp;
  var
    i1,i2:longint;
  begin
    verifierVecteur(Tvector(pu));
    with Tvector(pu) do
    result:=getCpxMean(x1,x2);
  end;


function FonctionTvector_MedianValue(x1,x2:float;var pu:typeUO):float;
  var
    i,i1,i2:longint;
    t:TArrayOfDouble;
  begin
    verifierVecteur(Tvector(pu));
    with Tvector(pu) do
    begin
      i1:=data.invConvX(x1);
      i2:=data.invConvX(x2);
      cadrageX(i1,i2);

      setLength(t,i2-i1+1);
      for i:=i1 to i2 do t[i-i1]:=Yvalue[i];
      result:=mediane(t,i2-i1+1) ;
    end;
  end;


function FonctionTvector_StdDev(var pu:typeUO):float;
  begin
    verifierVecteur(Tvector(pu));
    with Tvector(pu) do
    begin
      result:= data.StdDev(Istart,Iend);
    end;
  end;

function FonctionTvector_StdDev_1(x1,x2:float;var pu:typeUO):float;
  var
    i1,i2:longint;
  begin
    verifierVecteur(Tvector(pu));
    with Tvector(pu) do
    begin
      i1:=data.invConvX(x1);
      i2:=data.invConvX(x2);
      cadrageX(i1,i2);
      result:= data.StdDev(i1,i2);
    end;
  end;


function FonctionTvector_Mean0(var pu:typeUO):float;
var
  i1,i2:longint;
begin
  verifierVecteur(Tvector(pu));
  with Tvector(pu) do
  begin
    result:= data.moyenne(istart,iend);
  end;
end;

function FonctionTvector_MedianValue0(var pu:typeUO):float;
var
  i:longint;
  t:TArrayOfDouble;
begin
  verifierVecteur(Tvector(pu));
  with Tvector(pu) do
  begin
    setLength(t,iend-istart+1);
    for i:=istart to iend do t[i-istart]:=Yvalue[i];
    result:=mediane(t,iend-istart+1) ;
  end;
end;


function FonctionTvector_StdDev0(var pu:typeUO):float;
begin
  verifierVecteur(Tvector(pu));
  with Tvector(pu) do
  begin
    result:= data.StdDev(istart,iend);
  end;
end;


function FonctionTvector_DistriMean(x1,x2:float;var pu:typeUO):float;
  var
    i1,i2:longint;
  begin
    verifierVecteur(Tvector(pu));
    with Tvector(pu) do
    begin
      i1:=data.invConvX(x1);
      i2:=data.invConvX(x2);
      cadrageX(i1,i2);
      result:= data.moyenneDistri(i1,i2);
    end;
  end;

function FonctionTvector_DistriStdDev(x1,x2:float;var pu:typeUO):float;
  var
    i1,i2:longint;
  begin
    verifierVecteur(Tvector(pu));
    with Tvector(pu) do
    begin
      i1:=data.invConvX(x1);
      i2:=data.invConvX(x2);
      cadrageX(i1,i2);
      result:= data.StdDevDistri(i1,i2);
    end;
  end;


function FonctionTvector_Maxi(x1,x2:float;var pu:typeUO):float;
  var
    i1,i2:longint;
  begin
    verifierVecteur(Tvector(pu));
    with Tvector(pu) do
    begin
      i1:=data.invConvX(x1);
      i2:=data.invConvX(x2);
      cadrageX(i1,i2);
      FonctionTvector_Maxi:= data.Maxi(i1,i2);
    end;
  end;

function FonctionTvector_Mini(x1,x2:float;var pu:typeUO):float;
  var
    i1,i2:longint;
  begin
    verifierVecteur(Tvector(pu));
    with Tvector(pu) do
    begin
      i1:=data.invConvX(x1);
      i2:=data.invConvX(x2);
      cadrageX(i1,i2);
      FonctionTvector_Mini:= data.Mini(i1,i2);
    end;
  end;

function FonctionTvector_MaxiX(x1,x2:float;var pu:typeUO):float;
  var
    i1,i2:longint;
  begin
    verifierVecteur(Tvector(pu));
    with Tvector(pu) do
    begin
      i1:=data.invConvX(x1);
      i2:=data.invConvX(x2);
      cadrageX(i1,i2);
      result:= convx(data.MaxiX(i1,i2));
    end;
  end;

function FonctionTvector_MiniX(x1,x2:float;var pu:typeUO):float;
  var
    i1,i2:longint;
  begin
    verifierVecteur(Tvector(pu));
    with Tvector(pu) do
    begin
      i1:=data.invConvX(x1);
      i2:=data.invConvX(x2);
      cadrageX(i1,i2);
      result:= convx(data.MiniX(i1,i2));
    end;
  end;


procedure proTvector_fill(y:float;var pu:typeUO);
var
  i:integer;
begin
  verifierVecteur(Tvector(pu));
  with Tvector(pu) do fill(y);
end;

procedure proTvector_fill1(y,x1,x2:float;var pu:typeUO);
var
  i,i1,i2:integer;
begin
  verifierVecteur(Tvector(pu));
  with Tvector(pu) do
  begin
    i1:=data.invConvX(x1);
    i2:=data.invConvX(x2);
    {cadrageX(i1,i2);}
    fill1(y,i1,i2);
  end;
end;

procedure proTvector_fillCpx(y:TfloatComp;var pu:typeUO);
var
  i:integer;
begin
  verifierVecteur(Tvector(pu));
  with Tvector(pu) do fillCpx(y);
end;

procedure proTvector_fillCpx1(y:TfloatComp;x1,x2:float;var pu:typeUO);
var
  i,i1,i2:integer;
begin
  verifierVecteur(Tvector(pu));
  with Tvector(pu) do
  begin
    i1:=data.invConvX(x1);
    i2:=data.invConvX(x2);
    {cadrageX(i1,i2);}
    fillCpx1(y,i1,i2);
  end;
end;



procedure proTvector_Vmoveto(x,y:float;var pu:typeUO);
begin
  verifierVecteur(Tvector(pu));
  with Tvector(pu) do Vmoveto(x,y);
end;

procedure proTvector_Vlineto(x,y:float;var pu:typeUO);pascal;
begin
  verifierVecteur(Tvector(pu));
  with Tvector(pu) do Vlineto(x,y);
end;


procedure proTvector_initEventList(t:smallint;dx:float;var pu:typeUO);
begin
  if not assigned(pu) then proTvector_create('',t,0,-1,pu);
  verifierVecteur(Tvector(pu));
  with Tvector(pu) do
  begin
    if not inf.temp or inf.readOnly then sortieErreur(E_modify2);
    if not (typetypeG(t) in typesVecteursSupportes)
        then  sortieErreur(E_modify1);
    if dx=0 then sortieErreur(E_parametre);

    initEventList(typetypeG(t),dx);
  end;
end;

procedure proTvector_initList(t:smallint;var pu:typeUO);
begin
  if not assigned(pu) then proTvector_create('',t,0,-1,pu);

  verifierVecteur(Tvector(pu));
  with Tvector(pu) do
  begin
    if not inf.temp or inf.readOnly then sortieErreur(E_modify2);
    if not (typetypeG(t) in typesVecteursSupportes)
        then  sortieErreur(E_modify1);

    initList(typetypeG(t));
    invalidateData;
  end;
end;


procedure proTvector_addToList(x:float;var pu:typeUO);
begin
  verifierVecteur(Tvector(pu));
  with Tvector(pu) do
  begin
    if not inf.temp or inf.readOnly then sortieErreur(E_modify2);
    addToList(x);
  end;
end;

procedure proTvector_resetList(var pu:typeUO);
begin
  verifierVecteur(Tvector(pu));
  with Tvector(pu) do
  begin
    resetList;
  end;
end;

procedure proTvector_sortEventList(var pu:typeUO);
begin
  verifierVecteur(Tvector(pu));
  with Tvector(pu) do
  begin
    SortEventList;
  end;
end;

procedure proTvector_sort(Up:boolean; var pu:typeUO);
begin
  verifierVecteur(Tvector(pu));
  with Tvector(pu) do
  begin
    Sort(up);
  end;
end;

procedure proTvector_sortWithIndex(Up:boolean; var Vindex: Tvector; var pu:typeUO);
begin
  verifierVecteur(Tvector(pu));
  verifierVecteur(Vindex);

  with Tvector(pu) do
  begin
    if (Vindex.Istart<>Istart) or  (Vindex.Iend<>Iend) then sortieErreur( 'Tvector.sortWithIndex : Vindex has bad limits');
    SortWithIndex(up,Vindex);
  end;
end;


procedure proTvector_ModifyOrder(var Vindex: Tvector; var pu:typeUO);
begin
  verifierVecteur(Tvector(pu));
  verifierVecteur(Vindex);

  with Tvector(pu) do
  begin
    if (Vindex.Istart<>Istart) or  (Vindex.Iend<>Iend) then sortieErreur( 'Tvector.ModifyOrder : Vindex has bad limits');
    ModifyOrder(Vindex);
  end;
end;
procedure proTvector_removeFromList(i:integer;var pu:typeUO);
begin
  verifierVecteur(Tvector(pu));
  with Tvector(pu) do
  begin
    if (i<Istart) or (i>Iend) then sortieErreurIndex(i,Tvector(pu));
    removeFromList(i);
  end;
end;

procedure proTvector_InsertIntoList(i:integer;x:float;var pu:typeUO);
begin
  verifierVecteur(Tvector(pu));
  with Tvector(pu) do
  begin
    if (i<Istart) or (i>Iend) then sortieErreurIndex(i,Tvector(pu));
    InsertIntoList(i,x);
  end;
end;

procedure proTvector_getPointColor(p:integer;var pu:typeUO);
begin
  verifierVecteur(Tvector(pu));
  with Tvector(pu).onDP do setAd(p);
end;

function fonctionTvector_getPointColor(var pu:typeUO):integer;
begin
  verifierVecteur(Tvector(pu));
  result:=Tvector(pu).OnDP.ad;
end;

procedure proTvector_OnDisplay(p:integer;var pu:typeUO);
begin
  verifierVecteur(Tvector(pu));
  with Tvector(pu).onDisplay do setAd(p);
end;

function fonctionTvector_OnDisplay(var pu:typeUO):integer;
begin
  verifierVecteur(Tvector(pu));
  result:=Tvector(pu).OnDisplay.ad;
end;

procedure proTvector_OnImDisplay(p:integer;var pu:typeUO);
begin
  verifierVecteur(Tvector(pu));
  with Tvector(pu).onImDisplay do setAd(p);
end;

function fonctionTvector_OnImDisplay(var pu:typeUO):integer;
begin
  verifierVecteur(Tvector(pu));
  result:=Tvector(pu).OnImDisplay.ad;
end;


function FonctionTvector_getFirstEvent(x:float;var pu:typeUO):integer;
begin
  verifierVecteur(Tvector(pu));
  result:=Tvector(pu).getFirstEvent(x);
end;

procedure proTvector_onDragDrop(p:integer;var pu:typeUO);
begin
  verifierVecteur(Tvector(pu));
  with Tvector(pu).onDragDrop do setad(p);
end;

function fonctionTvector_onDragDrop(var pu:typeUO):integer;
begin
  verifierVecteur(Tvector(pu));
  result:=Tvector(pu).onDragDrop.ad;
end;

{
function fonctionCompareMseq(var vec1,vec2:Tvector):integer;
var
  size,res:integer;
  st1,st2:AnsiString;
  i,k,sz0:integer;
begin
  verifierVecteur(vec1);
  verifierVecteur(vec2);

  result:=-1;
  if vec1.Iend-vec1.Istart<>vec2.Iend-vec2.Istart then exit;
  if vec1.tpnum<>vec2.tpNum then exit;

  with vec1 do
  begin
    sz0:=tailletypeG[tpNum];
    size:=(Iend-Istart+1)*sz0;
  end;

  setLength(st1,size*2);

  with vec1 do
  begin
    for i:=Istart to Iend do
      begin
        k:=Jvalue[i];
        move(k,st1[(i-Istart)*sz0+1],sz0);
      end;
     move(st1[1],st1[1+size],size);
  end;

  setLength(st2,size);
  with vec2 do
  begin
    for i:=Istart to Iend do
      begin
        k:=Jvalue[i];
        move(k,st2[(i-Istart)*sz0+1],sz0);
      end;
  end;

  res:=pos(st2,st1);

  if (res-1) mod sz0<>0 then exit;

  result:=(res-1) div sz0;
end;
}

function CpMseqLong(a,b:PtabLong;max:integer):integer;
var
  i,j:integer;
begin
  i:=0;
  repeat
    j:=0;
    while (j<max) and (b^[j]=a^[(i+j) mod max]) do inc(j);
    inc(i);
  until (j=max) or (i=max);

  if j=max
    then result:=i-1
    else result:=-1;
end;

function CpMseqSmall(a,b:PtabEntier;max:integer):integer;
var
  i,j:integer;
begin
  i:=0;
  repeat
    j:=0;
    while (j<max) and (b^[j]=a^[(i+j) mod max]) do inc(j);
    inc(i);
  until (j=max) or (i=max);

  if j=max
    then result:=i-1
    else result:=-1;
end;


function fonctionCompareMseq(var vec1,vec2:Tvector):integer;
begin
  verifierVecteur(vec1);
  verifierVecteur(vec2);

  result:=-1;
  if (vec1.Iend-vec1.Istart<>vec2.Iend-vec2.Istart)
      or
     (vec1.tpnum<>vec2.tpNum)
      or
     not ((vec1.inf.temp) and (vec2.inf.temp))
   then sortieErreur(E_CompareMseq);


  case vec1.tpNum of
    g_longint: result:=
        CpMseqLong(PtabLong(vec1.tb),PtabLong(vec2.tb),vec1.Iend-vec1.Istart+1);
    G_smallint: result:=
        CpMseqSmall(PtabEntier(vec1.tb),PtabEntier(vec2.tb),vec1.Iend-vec1.Istart+1);
  end;

end;

procedure fmt1(lg :longint; cc,Re,Rs,Data,fmtr:PtabLong);
var
  a,b,i,mtSortie,dist,mtentree,blockStart,block,paire,x1,x2: longint;
begin
{permutation sur les colonnes (G)}
  for i:=0 to (lg-1) do
      begin
        mtEntree:=Re^[i];
        cc^[mtEntree]:=data[i];
      end;

 {FWT}
  dist:= 1;
  blockStart:= lg;
    repeat
      x1:=0;
      blockStart:=blockStart div 2;
      for block:=blockStart downTo 0 do
          begin
            x2:= x1+dist;
            for paire:=0 to (dist-1) do
                begin
                  a:=cc^[x1];
                  b:=cc^[x2];
                  cc^[x1]:=(a+b);
                  cc^[x2]:=(a-b);
                  inc(x1);
                  inc(x2);
                end;
            x1:=x2;
            end;
      dist:=(dist+dist) and lg;
    until (dist=0);

{permutation sur les lignes (T)}
 { fmtr.Yvalue[0]:=-1;}
  for i:=0 to (lg-1) do
      begin
        mtSortie:=Rs^[i];
        fmtr^[i]:=cc^[mtSortie];
      end;
end;

procedure proMseqFMT(var cc,Re,Rs,Data,fmtr:Tvector);
var
  lg:integer;
begin
  verifierVecteur(cc);
  verifierVecteur(Re);
  verifierVecteur(Rs);
  verifierVecteur(Data);
  verifierVecteur(fmtr);

  lg:=cc.Iend;

  if (cc.Istart<>0) or
     (Re.Istart<>0) or
     (Rs.Istart<>0) or
     (Data.Istart<>0) or
     (fmtr.Istart<>0) or

     (Re.Iend<>lg-1) or
     (Rs.Iend<>lg-1) or
     (Data.Iend<>lg-1) or
     (fmtr.Iend<>lg-1) or

     (cc.tpNum<>G_longint) or
     (Re.tpNum<>G_longint) or
     (Rs.tpNum<>G_longint) or
     (Data.tpNum<>G_longint) or
     (fmtr.tpNum<>G_longint) or

     not cc.inf.temp or
     not Re.inf.temp or
     not Rs.inf.temp or
     not Data.inf.temp or
     not fmtr.inf.temp

    then sortieErreur(E_fmt1);

    fmt1(lg,cc.tb,Re.tb,Rs.tb,Data.tb,fmtr.tb);

end;

procedure proTvector_SaveAsText(stName:AnsiString;twoCol1:boolean;deci:smallint;
                                var pu:Tvector);
var
  i:integer;
  st:AnsiString;
  f:text;
begin
  verifierVecteur(pu);
  controleParam(deci,0,30,E_deciText);

  if stName='' then exit;

  try
  assignFile(f,stName);
  rewrite(f);

  with Tvector(pu) do
  for i:=Istart to Iend do
    begin
      if twocol1
        then st:=Estr(convx(i),deci)+#9+Estr(Yvalue[i],deci)
        else st:=Estr(Yvalue[i],deci);
      writeln(f,st);
      {if (i mod 10000=0) and testerFinPg
        then break;}
    end;

  closeFile(f);
  except
  closeFile(f);
  sortieErreur('Unable to create file '+stName);
  end;

end;


procedure proTvector_LoadFromText(stName:AnsiString;NumCol,lig1,lig2:integer;var pu:Tvector);
var
  i:integer;
  st:AnsiString;
  f:text;
  lig,c,pc:integer;
  stMot:AnsiString;
  tp:typelexBase;
  error:integer;
  x:float;
  oldExpand:boolean;

const
  charSep=[#9,';',' ',','];

begin
  verifierVecteurTemp(pu);
  controleParam(NumCol,1,1000,E_deciText);

  if stName='' then exit;
  if lig1<1 then lig1:=1;
  if lig2<1 then lig2:=maxEntierLong;

  try
  assignFile(f,stName);
  reset(f);

  lig:=0;
  while (lig<lig1) and not eof(f) do
  begin
    inc(lig);
    readln(f,st);
  end;

  with Tvector(pu) do
  begin
    error:=0;
    initTemp1(Istart,Istart-1,tpNum);
    oldExpand:=Fexpand;
    Fexpand:=true;

    while (lig<=lig2) and (error=0) do
    begin
      pc:=0;
      c:=0;
      repeat
        lireUlexBase(st,pc,stMot,tp,x,error,charSep);
        inc(c);
        if (c=numCol) then
          if(tp=nombreB)
            then {addToList(x)} Yvalue[Istart+lig-lig1]:=x
            else error:=-1;
      until (c=numcol) or (error<>0);

      if eof(f) then break;
      readln(f,st);
      inc(lig);
    end;

    Fexpand:=oldExpand;
  end;
  closeFile(f);
  except
  closeFile(f);
  sortieErreur('Unable to load file '+stName);
  end;
end;

procedure proTvector_SaveAsSingle(stName:AnsiString;var pu:Tvector);
var
  i:integer;
  st:AnsiString;
  f:TfileStream;
  w:single;
  res:integer;
begin
  verifierVecteur(pu);
  if stName='' then exit;

  f:=nil;
  try
  f:=TfileStream.create(stName,fmCreate);

  with Tvector(pu) do
  for i:=Istart to Iend do
    begin
      w:=Yvalue[i];
      f.Write(w,sizeof(w));
    end;

  f.free;
  except
  f.free;
  sortieErreur('Unable to create file '+stName);
  end;
end;

procedure proTvector_SaveAsDouble(stName:AnsiString;var pu:Tvector);
var
  i:integer;
  st:AnsiString;
  f:TfileStream;
  w:double;
  res:integer;
begin
  verifierVecteur(pu);
  if stName='' then exit;

  f:=Nil;
  try
  f:=TfileStream.Create(stName,fmCreate);

  with Tvector(pu) do
  for i:=Istart to Iend do
    begin
      w:=Yvalue[i];
      f.Write(w,sizeof(w));
    end;

  f.free;
  except
  f.Free;
  sortieErreur('Unable to create file '+stName);
  end;
end;

procedure proTvector_SineWave(amp,Periode,phi:float;var pu:Tvector);
var
  i:integer;
  a1,a2:float;
begin
  verifierVecteur(pu);

  with Tvector(pu) do
  begin
    a1:=2*pi/periode*Dxu;
    a2:=2*pi/periode*x0u+phi;
    for i:=Istart to Iend do
      Yvalue[i]:=amp*sin(a1*i+a2);
  end;
end;



{controleVsourceVdest appelle extendDim
 rend les paramètres d'échelle suivant X de dest égaux à ceux de source,
 ET
 rend les paramètres d'échelle suivant Y de dest égaux à ceux de source à
 condition que source et dest soient de type ENTIER.
}
procedure controleVsourceVdest(var source,dest:Tvector;tp:typetypeG);
  begin
    verifierVecteur(source);
    verifierVecteur(dest);

    dest.controleReadOnly;
    dest.extendDim(source,tp);

    dest.dxu:=source.dxu;
    dest.x0u:=source.x0u;

    if (dest.tpNum <=G_longint) and (dest.tpNum <=G_longint) then
      begin
        dest.dyu:=source.dyu;
        dest.y0u:=source.y0u;
      end;
  end;


procedure proTvector_setScaleParams(Dx1,x1,Dy1,y1:float;var pu:Tvector);
begin
  verifierVecteur(Tvector(pu));

  if (Dx1=0) or (Dy1=0) then sortieErreur(E_parametre);

  with pu do
  begin
    Dxu:=Dx1;
    x0u:=x1;
    Dyu:=Dy1;
    y0u:=y1;
  end;
end;

{******************************* Gestion des complexes ***********************}

procedure proTVector_CpxValue(i:longint;y:TfloatComp;var pu:typeUO);
  begin
    verifierVecteur(Tvector(pu));
    with Tvector(pu) do CpxValue[i]:=y;
  end;

function fonctionTVector_CpxValue(i:longint;var pu:typeUO):TfloatComp;
  begin
    verifierVecteur(Tvector(pu));
    result:=Tvector(pu).CpxValue[i];
  end;

procedure proTVector_ImValue(i:longint;y:float;var pu:typeUO);
  begin
    verifierVecteur(Tvector(pu));
    with Tvector(pu) do ImValue[i]:=y;
  end;

function fonctionTVector_ImValue(i:longint;var pu:typeUO):float;
  begin
    verifierVecteur(Tvector(pu));
    result:=Tvector(pu).ImValue[i];
  end;


procedure proTvector_CpxMode(x:integer;var pu:typeUO);
begin
  verifierVecteur(Tvector(pu));

  if (x>=0) and (x<=3)
    then  Tvector(pu).CpxMode:=x
    else sortieErreur(E_Cmode);
end;

function fonctionTvector_CpxMode(var pu:typeUO):integer;
begin
  verifierVecteur(Tvector(pu));
  result:=Tvector(pu).visu.CpxMode;
end;

procedure VadjustIstartIend(source,dest:Tvector);
begin
  if not dest.adjustIstartIend(source)
    then sortieErreur(E_IstartIend);

  dest.dxu:=source.dxu;
  dest.x0u:=source.x0u;
  dest.unitX:=source.unitX;

  if (source.tpNum <=G_longint) and (dest.tpNum <=G_longint) then
    begin
      dest.dyu:=source.dyu;
      dest.y0u:=source.y0u;
    end;
  dest.unitY:=source.unitY;
end;

procedure VadjustIstartIend1(source,dest:Tvector;tp:typetypeG);
begin
  if not dest.adjustIstartIend1(source,tp)
    then sortieErreur(E_IstartIend);

  dest.dxu:=source.dxu;
  dest.x0u:=source.x0u;
  dest.unitX:=source.unitX;

  if (source.tpNum <=G_longint) and (dest.tpNum <=G_longint) then
    begin
      dest.dyu:=source.dyu;
      dest.y0u:=source.y0u;
    end;
  dest.unitY:=source.unitY;
end;


procedure VadjustIstartIendTpNum(source,dest:Tvector);
begin
  if not dest.adjustIstartIendTpNum(source)
    then sortieErreur(E_IstartIendTpNum);

  dest.dxu:=source.dxu;
  dest.x0u:=source.x0u;
  dest.unitX:=source.unitX;

  if (source.tpNum <=G_longint) and (dest.tpNum <=G_longint) then
    begin
      dest.dyu:=source.dyu;
      dest.y0u:=source.y0u;
    end;
  dest.unitY:=source.unitY;
end;

procedure Vmodify(dest:Tvector;tp:typetypeG;i1,i2:integer);
begin
  verifierObjet(typeUO(dest));
  with dest do
  begin
    if not strucModif(tp,i1,i2) then sortieErreur(E_modify2);

    if i2<i1-1 then  sortieErreur(E_indexOrder);
    if not (tp in typesVecteursSupportes)
      then  sortieErreur(E_modify1);

    dest.initTemp1(i1,i2,tp);
  end;
end;

procedure VcopyXscale(source,dest:Tvector);
begin
  dest.dxu:=source.dxu;
  dest.x0u:=source.x0u;
  dest.unitX:=source.unitX;
end;

procedure VcopyYscale(source,dest:Tvector);
begin
  if (source.tpNum <=G_longint) and (dest.tpNum <=G_longint) then
    begin
      dest.dyu:=source.dyu;
      dest.y0u:=source.y0u;
    end;
  dest.unitY:=source.unitY;
end;

procedure proTvector_Threshold(th:float;Fup,Fdw:boolean;var pu:Tvector);
begin
  verifierVecteur(pu);
  pu.Threshold(th,Fup,Fdw);
end;

procedure proTvector_Threshold1(th:float;var pu:Tvector);
begin
  verifierVecteur(pu);
  pu.Threshold1(th);
end;

procedure proTvector_Threshold2(th1,th2,val1,val2:float;var pu:Tvector);
begin
  verifierVecteur(pu);
  pu.Threshold2(th1,th2,val1,val2);
end;

function TVector.isCpx: boolean;
begin
  result:=tpNum>=G_singleComp;
end;

procedure proTvector_Xlevel(x:float;var pu:typeUO);
begin
  verifierVecteur(Tvector(pu));
  Tvector(pu).Xlevel:=x;
end;

function fonctionTvector_Xlevel(var pu:typeUO):float;
begin
  verifierVecteur(Tvector(pu));
  result:=Tvector(pu).Xlevel;
end;

procedure proTvector_Ylevel(x:float;var pu:typeUO);
begin
  verifierVecteur(Tvector(pu));
  Tvector(pu).Ylevel:=x;
end;

function fonctionTvector_Ylevel(var pu:typeUO):float;
begin
  verifierVecteur(Tvector(pu));
  result:=Tvector(pu).Ylevel;
end;


procedure proTvector_Uselevel(x:boolean;var pu:typeUO);
begin
  verifierVecteur(Tvector(pu));
  Tvector(pu).UseLevel:=x;
end;

function fonctionTvector_Uselevel(var pu:typeUO):boolean;
begin
  verifierVecteur(Tvector(pu));
  result:=Tvector(pu).UseLevel;
end;


function FonctionTvector_Maxi0(var pu:typeUO):float;
begin
  verifierVecteur(Tvector(pu));
  result:=Tvector(pu).maxi0;
end;

function FonctionTvector_Mini0(var pu:typeUO):float;
begin
  verifierVecteur(Tvector(pu));
  result:=Tvector(pu).mini0;
end;

function FonctionTvector_MaxiX0(var pu:typeUO):float;
begin
  verifierVecteur(Tvector(pu));
  result:=Tvector(pu).maxiX0;
end;

function FonctionTvector_MiniX0(var pu:typeUO):float;
begin
  verifierVecteur(Tvector(pu));
  result:=Tvector(pu).miniX0;
end;

function FonctionTvector_Sum0(var pu:typeUO):float;
begin
  verifierVecteur(Tvector(pu));
  result:=Tvector(pu).sum0;
end;

function FonctionTvector_Sum(var pu:typeUO):float;
begin
  verifierVecteur(Tvector(pu));
  result:=Tvector(pu).sum0;
end;

function FonctionTvector_Sum_1(x1,x2:float;var pu:typeUO):float;
var
  i1,i2: integer;
begin
  verifierVecteur(Tvector(pu));
  with Tvector(pu) do
  begin
    i1:=data.invConvX(x1);
    i2:=data.invConvX(x2);
    cadrageX(i1,i2);
    result:= sum(i1,i2);
  end;
end;


function FonctionTvector_SqrSum0(var pu:typeUO):float;
begin
  verifierVecteur(Tvector(pu));
  result:=Tvector(pu).SumSqrs0;
end;

procedure proTvector_SaveBinaryData(var fbin:TbinaryFile;tp: integer;var pu:typeUO);
begin
  verifierVecteur(Tvector(pu));
  verifierObjet(typeUO(fbin));
  Tvector(pu).SaveToBin(fbin.f,typetypeG(tp));

end;

procedure proTvector_LoadBinaryData(var fbin:TbinaryFile;ByteStep:integer; var pu:typeUO);pascal;
begin
  verifierVecteur(Tvector(pu));
  verifierObjet(typeUO(fBin));
  Tvector(pu).LoadFromBin(fbin.f,ByteStep);
end;



procedure proTvector_saveSingleData(var binF, pu:typeUO);
begin
  verifierVecteur(Tvector(pu));
  verifierObjet(binF);

  TbinaryFile(binF).saveAsSingle(pu);
end;

procedure proTvector_loadSingleData(var binF, pu:typeUO);
var
  ok:boolean;
begin
  verifierVecteur(Tvector(pu));
  verifierObjet(binF);

  ok:=TbinaryFile(binF).loadAsSingle(pu);
end;




function TVector.getDeci(i: integer): integer;
begin
  result:=decimale[i-1];
end;

procedure TVector.setDeci(i, w: integer);
begin
  decimale[i-1]:=w;
end;

function Tvector.Xstart:float;
begin
  if modeT in [DM_Evt1, DM_Evt2] then
  begin
    if Icount>0
      then result:=Yvalue[Istart]
      else result:=0;
  end
  else result:= inherited Xstart;
end;

function Tvector.Xend:float;
begin
  if modeT in [DM_Evt1, DM_Evt2] then
  begin
    if Icount>0
      then result:=Yvalue[Iend]
      else result:=0;
  end
  else result:= inherited Xend;
end;


procedure proTvector_SmoothFactor(w:integer ;var pu:typeUO);
begin
  verifierObjet(pu);
  Tvector(pu).SmoothFactor:= abs(w);
end;

function fonctionTvector_SmoothFactor(var pu:typeUO):integer;
begin
  verifierObjet(pu);
  result:= Tvector(pu).SmoothFactor;
end;

procedure proTvector_BinFactor(w:integer ;var pu:typeUO);
begin
  verifierObjet(pu);
  Tvector(pu).SmoothFactor:= -abs(w);
end;

function fonctionTvector_BinFactor(var pu:typeUO):integer;
begin
  verifierObjet(pu);
  result:= abs(Tvector(pu).SmoothFactor);
end;


procedure proTvector_Edit(var pu:typeUO);
begin
  verifierVecteur(Tvector(pu));
  Tvector(pu).editVector(nil);
end;

{
 CopyFrom_1 permet de copier efficacement les données analogiques d'un fichier Elphy multiplexé:
 BlockSize est la taille du bloc de données à traiter (en bytes)
 MaxSize permet de limiter la taille écrite dans le fichier destination. En général, on donnera la valeur zéro à maxSize.

 Vmask est un vecteur qui permet d'indiquer la structure d'un agrégat. Sa longueur (Icount) doit être égale à la taille d'un agrégat.
Les valeurs successives de Vmask correspondent au numéro du canal . Quand on ne veut pas sauver le canal, on remplace la valeur par zéro.
Dans le cas le plus simple, un agrégat correspondant à un fichier de cinq canaux contiendra par exemple (1,2,3,4,5) mais comme Elphy autorise le
sous-échantillonnage sur certaines voies, la structure de l'agrégat peut être nettement plus compliquée. Dans notre exemple, si la voie 5 a été
décimée avec un facteur 3, on aura (1,2,3,4,5,1,2,3,4,1,2,3,4)

 tp est le type des données (voir (Types numériques)@(types de nombre) ). Ce type est conservé pendant la copie.
 index est une variable entière qui doit être initialisée à zéro quand on commence le traitement d'un fichier continu ou bien quand
on commence le traitement d'un épisode. Dans les autre cas, cete valeur ne doit pas être modifiée.
}
procedure proTbinaryFile_CopyFrom_1(var binF:TbinaryFile;BlockSize, MaxSize:int64; var VMask:Tvector; tp:integer;var index:integer; var pu:typeUO);
var
  mask:array of boolean;
  Nmask:integer;
  i,cnt,sz,cnt2:integer;
  fsrc,fdest: Tfilestream;

  tb: array of byte;
begin
  verifierObjet(pu);
  verifierObjet(typeUO(binF));
  verifierObjet(typeUO(Vmask));

  Nmask:=Vmask.Icount;
  setlength(mask,Nmask);
  for i:=0 to high(mask) do mask[i]:= (Vmask[Vmask.Istart+i]<>0);

  fdest:= TbinaryFile(pu).f;
  fsrc:= TbinaryFile(binF).f;
  sz:= tailletypeG[typetypeG(tp)];

  setlength(tb,BlockSize);
  fsrc.Read(tb[0],BlockSize);

  cnt:= 0;
  cnt2:=0;
  while (cnt<=BlockSize-sz) do
  begin
    if mask[index] then
    begin
      move(tb[cnt],tb[cnt2],sz);
      inc(cnt2,sz);
    end;
    inc(index);
    if index>high(mask) then index:=0;
    inc(cnt,sz);
  end;

  if (MaxSize>0) and (MaxSize-fdest.size<cnt2) then cnt2:= MaxSize-fdest.size;
  fdest.Write(tb[0],cnt2);

end;

procedure proTbinaryFile_CopyEpisodeWithDownSampling1(var binF:TbinaryFile;var Voffset, VSize, VMask:Tvector; tp:integer; DSfactor: integer; var pu:typeUO);
var
  mask:array of integer;
  sizes: array of integer;
  offsets: array of integer;
  Nblock, Nmask:integer;
  i,j, cnt,sz,cnt2, block:integer;
  fsrc,fdest: Tfilestream;
  fmem: array of TmemoryStream;

  tb: array of byte;
  max:integer;
  chan, chanOrder: array of integer;
  Nchan: integer;

  Ichan: array of integer;
  Wchan: array of double;
  index, ch:integer;
  wi:smallint;

begin
  verifierObjet(pu);
  verifierObjet(typeUO(binF));
  verifierObjet(typeUO(Vsize));
  verifierObjet(typeUO(Voffset));
  verifierObjet(typeUO(Vmask));

  Nmask:=Vmask.Icount;
  setlength(mask,Nmask);
  for i:=0 to high(mask) do mask[i]:= round(Vmask[Vmask.Istart+i]);

  Nchan:=0;
  max:=round(Vmask.maxi0);
  setLength(chan,max);
  setLength(chanOrder,max+1);

  for i:= 1 to max do
    for j:= 0 to high(mask) do
      if mask[j]=i then
      begin
        chan[Nchan]:=i;
        inc(Nchan);
        break;
      end;

  fillchar(chanOrder[0],(max+1)*sizeof(integer),0);
  for i:= 0 to Nchan-1 do chanOrder[chan[i]]:= i+1;

  for i:= 0 to Nmask-1 do mask[i]:= ChanOrder[mask[i]];  // Exemple: 0 3 7 9 11 est remplacé par 0 1 2 3 4

  Nblock:= Voffset.Icount;
  if (Nblock=0) or (Vsize.Icount<>Nblock) then sortieErreur('TbinaryFile.CopyEpisodeWithDownSampling : bad number of blocks');
  setLength(Sizes,Nblock);
  setLength(offsets,Nblock);

  for i:=0 to Nblock-1 do
  begin
    Sizes[i]:=round(Vsize[Vsize.Istart+i]);
    offsets[i]:=round(Voffset[Voffset.Istart+i]);
  end;

  fdest:= TbinaryFile(pu).f;
  fsrc:=  TbinaryFile(binF).f;
  sz:=   tailletypeG[typetypeG(tp)];

  setLength(Ichan,Nchan+1);
  setLength(Wchan,Nchan+1);
  fillchar(Ichan[0],(Nchan+1)*sizeof(integer),0);
  fillchar(Wchan[0],(Nchan+1)*sizeof(double),0);

  setLength(fmem,Nchan);
  for i:= 0 to Nchan-1 do fmem[i]:= TmemoryStream.Create;

  index:=0;

  try

  for block:=0 to Nblock-1 do
  begin
    fsrc.Position:=offsets[block];
    setlength(tb,Sizes[block]);
    fsrc.Read(tb[0],Sizes[block]);

    cnt:= 0;
    cnt2:=0;

    while (cnt<=Sizes[block]-sz) do
    begin
      ch:= mask[index];
      if ch>0 then
      begin
        wchan[ch]:= wchan[ch]+ Psmallint(@tb[cnt])^;
        inc(Ichan[ch]);
        if Ichan[ch]=DSfactor then
        begin
          wi:= round(wchan[ch]/DSfactor);
          fmem[ch-1].write(wi,sz);
          wchan[ch]:=0;
          Ichan[ch]:=0;
        end;
      end;
      inc(index);
      if index>high(mask) then index:=0;
      inc(cnt,sz);
    end;
  end;

  for i:= 0 to Nchan-1 do
  begin
    fmem[i].Position:=0;
    fdest.CopyFrom(fmem[i],fmem[i].Size);
  end;

  finally
  for i:= 0 to Nchan-1 do fmem[i].Free;
  end;
end;


{  Le fichier binF contient des données multiplexées: ChCount canaux de type tp
   binF est correctement positionné. Les données occupent EpSize octets.
   On sous-échantillonne ( un groupe de DSfactor échantillons est remplacé par sa moyenne).
   Le type destination est toujours single (?)
   On obtient un bloc de EpSize div DXfactor octets
   Si le nb de samples n'est pas un multiple de DSfactor, les échantillons du dernier groupe (incomplet) sont oubliés.

   Deux options:
     1 - créer un segment par canal  :  le plus pratique au final mais ce n'est pas valable pour un fichier continu car l'épisode doit être chargé en mémoire
     2 - créer un fichier multiplexé  : le plus facile.

}
procedure proTbinaryFile_CopyWithDownSampling1(var binF:TbinaryFile;EpSize:int64; ChCount:integer; tp:integer; DSfactor: integer; var pu:typeUO);
var
  i, j, sz, sz1, Nt, Nb, N, n1, n2:integer;
  NbAg:integer;
  NsampPerChannel: integer;
  fsrc,fdest: Tfilestream;

  BlockSize,size, RestSize:integer;
  tbS,tbD: pointer;
  ss: array[1..256] of single;

begin
  verifierObjet(pu);
  verifierObjet(typeUO(binF));

  fdest:= TbinaryFile(pu).f;
  fsrc:= TbinaryFile(binF).f;
  sz:= tailletypeG[typetypeG(tp)];

  Nt:= EpSize div sz;
  NSampPerChannel:= Nt div (ChCount*DSfactor);

  BlockSize:= 1000000;
  if BlockSize>EpSIze then BlockSize:= EpSize;

  BlockSize:= (BlockSize div (DSfactor*ChCount))*DSfactor*ChCount;

  getmem(tbS,BlockSize);
  Nb:= BlockSize div sz;

  getmem(tbD, NsampPerChannel*sizeof(single)*ChCount );

  try

  N:=0;   // index dans un groupe

  fillchar(ss,sizeof(ss),0);

  size:=0;
  n2:=0;
  repeat
    if size+BlockSize>EpSIze then sz1:= Epsize-size else sz1:= BlockSize;
    fsrc.Read(tbS^,sz1);

    Nb:= sz1 div sz;
    NbAg:= Nb div ChCount;

    case typetypeG(tp) of
      g_smallint:
          for i:= 0 to NbAg-1 do
          begin
            for j:= 1 to ChCount do
              ss[j]:=ss[j]+PtabEntier(tbS)^[i*ChCount+j-1];
            inc(N);
            if N=DSfactor then
            begin
              for j:= 1 to ChCount do
              begin
                PtabSingle(tbD)^[(j-1)*NsampPerChannel+n2]:= ss[j]/DSfactor;
                ss[j]:=0;
              end;
              inc(n2);
              N:=0;
            end;
          end;
      g_single:
          for i:= 0 to NbAg-1 do
          begin
            for j:= 1 to ChCount do
              ss[j]:=ss[j]+PtabSingle(tbS)^[i*ChCount+j-1];
            inc(N);
            if N=DSfactor then
            begin
              for j:= 1 to ChCount do
              begin
                PtabSingle(tbD)^[(j-1)*NsampPerChannel+n2]:= ss[j]/DSfactor;
                ss[j]:=0;
              end;
              inc(n2);
              N:=0;
            end;
          end;
    end;
    fdest.Write(tbD^,NsampPerChannel*sizeof(single)*ChCount);
    size:=size+sz1;
  until size>=EpSize;

  finally
  freemem(tbS);
  freemem(tbD);
  end;
end;


Initialization
AffDebug('Initialization Stmvec1',0);
  installError(E_typeNombre,'Tvector.create: Type not supported');
  installError(E_modify1,'Tvector.modify: type not supported');
  installError(E_modify2,'Tvector: modification unauthorized ');

  installError(E_index, 'Tvector: index out of range');
  installError(E_indexOrder,'Tvector: start index must be lower than end index');
  installError(E_data, 'Tvector: no valid data or index out of range');

  installError(E_readOnly, 'Tvector: cannot modify the data');
  installError(E_vecteur, 'Tvector: not assigned or no valid data ');
  installError(E_vecteurTemp, 'Tvector: data not in memory ');

  installError(E_CompareMSeq, 'Tvector.compareMseq: invalid vector');
  installError(E_fmt1, 'Tvector.fmt: invalid data');
  installError(E_deciText, 'Tvector.saveAsText: DecimalPlaces out of range');

  installError(E_Cmode, 'Tvector: Cmode out of range ');
  installError(E_IstartIend, 'Tvector: cannot modify bounds ');
  installError(E_IstartIendTpNum, 'Tvector: cannot modify bounds or type');

  registerObject(Tvector,data);
end.
