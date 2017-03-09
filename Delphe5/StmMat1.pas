unit StmMat1;

INTERFACE
{$IFDEF FPC} {$mode delphi} {$DEFINE AcqElphy2} {$A1} {$Z1} {$ENDIF}


uses windows,sysutils,math,
     classes,graphics,forms,controls,menus,

     util1,Gdos,DdosFich,Dgraphic,Dgrad1,dtf0,Dtrace1,tbe0,
     Dpalette,Ncdef2,formMenu,stmPopUp,
     editcont,matCooD0,
     tpForm0,Daffmat,

     stmDef,stmObj,defForm,
     getVect0,getMat0,visu0,
     inivect0,
     varconf1,stmDobj1,
     stmError,stmPg,

     DtbEdit2,debug0,
     stmGraph2,BmatCont1,

     gl,glu,cgTypes,cgLight,
     GlGsU1,
     stmVec1,
     {$IFDEF DX11}  {$ELSE} DXTypes, Direct3D9G, D3DX9G, {$ENDIF}

     BmEx1,
     getmatValue1,getmatValue2,
     DibG,
     IPPI,IPPdefs,
     objFile1, tiff0,
     geometry1,
     stmRegion1,
     matlab_matrix,matlab_mat,
     DXgrid1;


     {stmCplot1 dans implementation}




type
  TMatrix=  class(TDataObj)
            private
              FonControl:boolean;
              FManagedMem:boolean;
              FselSize,FmarkSize:integer;
            protected
              externalTemp:boolean;          { introduit pour TOIseq }

              mark:PtabBoolean;

              FselPix,FmarkPix:PtabBoolean;

              FsingleSel,FsingleMark:boolean;

              LastSelPix,LastMarkPix:Tpoint;

              TbDeci:array of byte;
              deciSize:integer;

              editForm:TtableEdit;
              regEditor:Tform;

              FRegionList:TregionList;

              FinvCell:boolean;
              invCol,invRow:integer;  {cellule invalidée}
              nbCol,nblig:integer;

              {selectColor,MarkColor:integer;}

              selectMode,MarkMode:boolean;


              FpalName:AnsiString;


              Cplot:TXYplot;

              CLevelCount:integer;
              CZmin,CZmax:float;
              CFsel,CFmark,CFvalue:boolean;
              Cvalue:float;
              ClineWidth:integer;
              Czero:float;
              Cpolygons:boolean;
              CusePos:boolean;

              onSelect,onMark,onHint:Tpg2Event;

              FTransparentValue:double;
              FTransparent:boolean;

              DXGrid: TDXgrid;

              procedure MemManagerEvent;override;

              procedure setE(i,j:integer;x:float);
              function getE(i,j:integer):float;
              procedure setI(i,j,k:integer);
              function getI(i,j:integer):integer;

              procedure setR(x,y,z:float);
              function getR(x,y:float):float;

              procedure setCpx(i,j:integer;w:TfloatComp);
              function getCpx(i,j:integer):TfloatComp;
              procedure setIm(i,j:integer;w:float);
              function getIm(i,j:integer):float;

              procedure setDeci(i:integer;w:integer);
              function getDeci(i:integer):integer;

              function getScore(i,j:integer;seuil1,seuil2:float):integer;

              procedure DinvalidateCell(i,j:integer);virtual;
              procedure DinvalidateVector(i:integer);virtual;
              procedure DinvalidateAll;

              procedure DsetKvalue(b:boolean);

              procedure DsetI(i,j:integer;x:float);virtual;
              function DgetI(i,j:integer):float;virtual;

              procedure DsetE(i,j:integer;x:float);virtual;
              function DgetE(i,j:integer):float;virtual;
              function DgetColName(i:integer):Ansistring;

              procedure setSelPix(i,j:integer;w:boolean);
              function getSelPix(i,j:integer):boolean;

              procedure setMarkPix(i,j:integer;w:boolean);
              function getMarkPix(i,j:integer):boolean;

              function isSelected:boolean;

              procedure verifierIndices(i,j:integer);

              procedure setTheta(x:single);

              procedure setPalColor(n:integer;x:integer);
              function getPalColor(n:integer):integer;

              procedure setChildNames;override;
              procedure BuildContour(sender:Tobject);
              procedure createCplot;

              procedure CgetZminZmax(var min,max:float);

              procedure OnselectEvent(x,y:integer);
              procedure OnMarkEvent(x,y:integer);

              procedure EditValueDlg(x,y,xp,yp:integer);
              function ValueHint(z:TfloatComp):AnsiString;

              procedure modifyLimits(i1,i2,j1,j2:integer);
              procedure setIstart(w:integer);override;
              procedure setIend(w:integer);override;
              procedure setJstart(w:integer);override;
              procedure setJend(w:integer);override;

              function getJstart:longint;override;
              function getJend:longint;  override;

              procedure FileLoadFromMatrix(sender:Tobject);
              procedure FileLoadFromObjFile(sender:Tobject);

              function getRegionList:TregionList;

              procedure ProcessMessage (id:integer;source:typeUO;p:pointer);override;

              function getOnControl:boolean;override;
              procedure setOnControl(v:boolean);override;
              procedure setFlagOnControl(v:boolean);override;

              Function ManagedMem: boolean;override;
            public

              degP:typeDegre; {theta fait double emploi avec visu.theta}

              data:TdataTbB;

              dpal:TDpalette;

              wf:TWFoptions;
              inf3D:Tmatinf3D;
              Command3D:Tform;

              Fcontour:boolean;

              property RegionList:TregionList read getRegionList;

              constructor create;overload;override;
              constructor create(tNombre:typeTypeG; n1,n2,m1,m2:longint);overload;

              procedure initTemp0(ad:pointer;n1,n2,m1,m2:longint;tNombre:typeTypeG);
              procedure initTemp(n1,n2,m1,m2:longint;tNombre:typeTypeG);virtual;
              procedure initTempEx(ad:pointer;n1,n2,m1,m2:longint;tNombre:typeTypeG);
              procedure setImageOptions;

              procedure InitDataTemp;virtual;
              procedure modifyAd(ad:pointer);

              class function STMClassName:AnsiString;override;
              class function SupportType(tp:typetypeG):boolean;virtual;

              function isVisual:boolean;override;
              function getDispPriority: integer;override;


              destructor destroy;override;

              procedure display3D;


              procedure freeDXresources;override;
              procedure display3DX(Idevice: IDirect3DDevice9);override;
                            
              procedure display; override;
              procedure displayInside(FirstUO:typeUO;extWorld,logX,logY:boolean;const order:integer=-1);
                                 override;

              procedure cadrerX(sender:Tobject);override;
              procedure cadrerY(sender:Tobject);override;
              procedure cadrerZ(sender:Tobject);override;
              procedure cadrerC(sender:Tobject);override;

              function ChooseCoo1:boolean;override;
              procedure createForm;override;

              procedure CreateRegEditor;
              procedure ShowDesignForm;
              procedure ShowSelectWindow(sender:Tobject);

              procedure recupLumParam(l1,l2,g:integer);
              procedure incI(x,y:longint);

              procedure clear;override;

              procedure afficheC;override;

              function dialogForm:TclassGenForm;override;
              procedure installDialog(var form1:Tgenform;var newF:boolean);override;

              procedure setDx(x:double);  override;
              procedure setX0(x:double);  override;
              procedure setDy(x:double);  override;
              procedure setY0(x:double);  override;

              procedure setDz(x:double);  override;
              procedure setZ0(x:double);  override;

              procedure AutoScaleX;      override;
              procedure AutoScaleY;      override;
              procedure AutoScaleZ;      override;
              procedure autoscaleC;
              procedure AutoScaleZsym;
              procedure autoscaleZmax(vmin:float);

              property theta:single read degP.theta write setTheta;

              property Gamma:single read visu.gamma write visu.gamma;
              property TwoCol:boolean read visu.twoCol write visu.TwoCol;
              property PalColor[n:integer]:integer read getPalColor write setPalColor;
              property DisplayMode:byte read visu.modeMat write visu.modeMat;
              property PalName:AnsiString read FpalName write FPalName;

              function initialise(st:AnsiString):boolean;override;

              procedure BuildInfo(var conf:TblocConf;lecture,tout:boolean);override;
              procedure completeLoadInfo;override;

              procedure Doncontrol(sender:Tobject);
              function getPopUp:TpopUpMenu;override;

              procedure matProp(stOpt:AnsiString);
              procedure proprietes(sender:Tobject);override;
              procedure EditMatrix(sender:Tobject);
              procedure EditModal;

              procedure SelectPixel(sender:Tobject);
              procedure MarkPixel(sender:Tobject);

              procedure createEditForm;virtual;

              procedure modify(t:typetypeG;i1,j1,i2,j2:integer);virtual;

              procedure saveData(f:Tstream);override;
              function loadData(f:Tstream):boolean;override;

              procedure saveAsSingle(f:Tstream);override;
              function loadAsSingle(f:Tstream):boolean;override;

              procedure saveAsSingle1(f:Tstream; Fbyline:boolean);
              function loadAsSingle1(f:Tstream; Fbyline:boolean):boolean;


              procedure saveAsText(fileName:AnsiString; decimalPlaces:integer);
              procedure loadFromText(fileName:AnsiString);

             {Ces 2 propriétés sont protégées en lecture/écriture}
              property Kvalue[i,j:integer]:integer read getI write setI;
              property Zvalue[i,j:integer]:float read getE write setE;default;
              property Rvalue[x,y:float]:float read getR write setR;

              property CpxValue[i,j:integer]:TfloatComp read getCpx write setCpx;
              property ImValue[i,j:integer]:float read getIm write setIm;

              function Ystart:float;  override;
              function Yend:float;    override;

              function ConnectedPixels(seuil1,seuil2:float):integer;
              function getInsideWindow:Trect;override;

              function getSmoothVal(i,j:integer):float;
              function getSmoothSel(i,j:integer):boolean;
              function getSmoothMark(i,j:integer):boolean;

              function getInfo:AnsiString;override;

              property SelPix[i,j:integer]:boolean read getSelPix write setSelPix;
              property MarkPix[i,j:integer]:boolean read getMarkPix write setMarkPix;
              property SelectColor:integer read visu.selectCol write visu.selectCol;
              property MarkColor:integer read visu.MarkCol write visu.MarkCol;


              function SelPixCount:integer;
              function MarkPixCount:integer;

              function MouseDownMG(numOrdre:integer;Irect:Trect;
                Shift: TShiftState; Xc,Yc,X,Y: Integer):boolean; override;
              function MouseMoveMG(x,y:integer):boolean;override;
              procedure MouseUpMG(x,y:integer; mg:typeUO);override;


              procedure getMinMaxI(var Vmin,Vmax:integer);

              procedure getMinMax(var Vmin,Vmax:float);overload;
              procedure getMinMax(var Vmin,Vmax:float;var Imini,Jmini,Imaxi,Jmaxi:integer);overload;

              procedure getMinMaxWithTH(th1,th2:float;var Vmin,Vmax:float);

              function getRvalue(x,y:float):float;virtual;

              procedure saveToStream(f:Tstream;Fdata:boolean);override;
              function loadFromStream(f:Tstream;size:LongWord;Fdata:boolean):boolean;override;

              procedure Show3Dcommands(sender:Tobject);
              procedure createCommand3D;

              function sum(i1,i2,j1,j2:integer):float;
              function sumSqrs(i1,i2,j1,j2:integer):float;
              function sumMdls(i1,i2,j1,j2:integer):float;

              function Mean(i1,i2,j1,j2:integer):float;
              function CpxMean(i1,i2,j1,j2:integer):TfloatComp;

              function StdDev(i1,i2,j1,j2:integer):float;

              procedure ColtoVec(n:integer;vec:Tvector);virtual;
              procedure VecToCol(vec:Tvector;n:integer);virtual;
              procedure LinetoVec(n:integer;vec:Tvector);virtual;
              procedure VecToLine(vec:Tvector;n:integer);virtual;

//              procedure createTexture(d3dDevice:IDIRECT3DDEVICE8;var Texture:IDIRECT3DTEXTURE8);
              procedure CopyMat( mat: Tmatrix);

              procedure Threshold(th:float;Fup,Fdw:boolean);
              procedure Threshold1(th:float);
              procedure Threshold2(th1,th2,val1,val2:float);

              procedure ClearSelPix;
              procedure ClearMarkPix;

              function withZ:boolean;override;

              procedure BuildCnxMap(seuil:float;FilterMode:integer;NbFil:integer;const AbsMode:boolean=false);

              procedure CenterOfGravity(var xG,yG:float);

              procedure invalidate;override;
              procedure invalidateData;override;

              procedure MatToDib(var matDib:Tdib;Fraw:boolean);
              function DibToMat(matDib:Tdib):boolean;

              function loadFromBMP(stF:AnsiString):boolean;
              function saveAsBMP(stF:AnsiString):boolean;

              function Cell(i,j:integer):pointer;
              function isSquare:boolean;
              procedure transposeM2;               {transpose une matrice carrée en place }

              { Ces fonctions doivent être surchargées par Tmat et TmatImage
                Pour Tmatrix, elles échangent le rôle de x et y  }
              function stepIPP:integer;virtual;
              function sizeIPP:IPPIsize;overload;virtual;
              function sizeIPP(n1,n2:integer):IPPIsize;overload;virtual;
              function rectIPP(x1,y1,w1,h1:integer):IPPIrect;virtual;

              procedure copyDataFrom(p:typeUO);override;

              function getP(i,j:integer):pointer;
              function EltSize:integer;


              procedure add(src1,src2:Tmatrix);
              procedure sub(src1,src2:Tmatrix);

              procedure addNum(w:float);
              procedure mulnum(w:float);

              procedure fill(w:float);
              procedure adjustEditForm;

              function loadFromSTK(stF:AnsiString;num:integer):boolean;

              procedure setMapScale(Xextent,Yextent,Iorg,Jorg:float);

              function getMxArray(Const tpdest0:typetypeG = G_none):MxArrayPtr;override;
              procedure setMxArray(mxArray:MxArrayPtr;Const invertIndices:boolean=false);override;

              property Transparent: boolean read Ftransparent Write Ftransparent;
              property TransparentValue: double read FtransparentValue write FtransparentValue;

              function getMatPos(var xp,yp: integer):boolean;
              function getMainWorld(var x1,y1,x2,y2: float): boolean;

              procedure Distri(vec: Tvector);
              procedure AddE(i,j:integer;w:float);

              function is3D:boolean;override;
              
              procedure Circle(xC,yC,Rc,value: float;Ffill:boolean);
              procedure polygons(plot:TXYplot;val1,val2:float;Ffill:boolean);
            end;


procedure verifierMatrice(var pu:Tmatrix);
procedure verifierMatriceTemp(var pu:Tmatrix);
procedure MadjustIndex(src,dest:Tmatrix);
procedure MadjustIndexTpNum(src,dest:Tmatrix);

procedure McopyXYscale(source,dest:Tmatrix);
procedure McopyZscale(source,dest:Tmatrix);

procedure Mmodify(dest:Tmatrix;tp:typetypeG;i1,i2,j1,j2:integer);
{Attention, l'ordre des params est différent de Tmatrix.modify}


{***************** Déclarations STM pour Tmatrix *****************************}

procedure proTmatrix_create(name:AnsiString;
                   t:smallint;i1,i2,j1,j2:longint;var pu:typeUO);pascal;
procedure proTmatrix_create_1(t:smallint;i1,i2,j1,j2:longint;var pu:typeUO);pascal;
procedure proTmatrix_create_2(var pu:typeUO);pascal;

procedure proTmatrix_createImage(name:AnsiString;
                   t:smallint;n1,n2:longint;var pu:typeUO);pascal;
procedure proTmatrix_createImage_1(t:smallint;n1,n2:longint;var pu:typeUO);pascal;


function fonctionTMatrix_Jstart(var pu:typeUO):longint;pascal;
procedure proTMatrix_Jstart(w:integer;var pu:typeUO);pascal;

function fonctionTMatrix_Jend(var pu:typeUO):longint;pascal;
procedure proTMatrix_Jend(w:integer;var pu:typeUO);pascal;
function fonctionTMatrix_Jcount(var pu:typeUO):longint;pascal;

function fonctionTMatrix_Ystart(var pu:typeUO):float;pascal;
function fonctionTMatrix_Yend(var pu:typeUO):float;pascal;


function fonctionTMatrix_Kvalue(i,j:longint;var pu:typeUO):longint;pascal;
procedure proTMatrix_Kvalue(i,j:longint;w:longint;var pu:typeUO);pascal;

function fonctionTMatrix_Zvalue(i,j:longint;var pu:typeUO):float;pascal;
procedure proTMatrix_Zvalue(i,j:longint;w:float;var pu:typeUO);pascal;

function fonctionTMatrix_Cpxvalue(i,j:longint;var pu:typeUO):TfloatComp;pascal;
procedure proTMatrix_CpxValue(i,j:longint;w:TfloatComp;var pu:typeUO);pascal;
function fonctionTMatrix_Mdlvalue(i,j:longint;var pu:typeUO):float;pascal;

function fonctionTMatrix_Rvalue(x,y:float;var pu:typeUO):float;pascal;
procedure proTMatrix_Rvalue(x,y,w:float;var pu:typeUO);pascal;

procedure proTMatrix_ImValue(i,j:integer;y:float;var pu:typeUO);pascal;
function fonctionTmatrix_ImValue(i,j:integer;var pu:typeUO):float;pascal;

procedure proTmatrix_CpxMode(x:integer;var pu:typeUO);pascal;
function fonctionTmatrix_CpxMode(var pu:typeUO):integer;pascal;


procedure proTmatrix_Dz(x:float;var pu:typeUO);pascal;
function fonctionTmatrix_Dz(var pu:typeUO):float;pascal;

procedure proTmatrix_Z0(x:float;var pu:typeUO);pascal;
function fonctionTmatrix_Z0(var pu:typeUO):float;pascal;

function FonctionTmatrix_convZ(i:longint;var pu:typeUO):float;pascal;
function FonctionTmatrix_invconvZ(x:float;var pu:typeUO):longint;pascal;

procedure proTMatrix_getMinMaxI(var Vmin,Vmax:longint;var pu:typeUO);pascal;

procedure proTMatrix_getMinMax(var Vmin,Vmax:float;var pu:typeUO);pascal;
procedure proTMatrix_getMinMax_1(var Vmin,Vmax:float;var Imini,Jmini,Imaxi,Jmaxi:integer;var pu:typeUO);pascal;

procedure proTmatrix_getMinMaxWithTH(th1,th2:float;var Vmin,Vmax:float;var pu:typeUO);pascal;

function fonctionTmatrix_Zmin(var pu:typeUO):float;pascal;
procedure proTmatrix_Zmin(x:float;var pu:typeUO);pascal;

function fonctionTmatrix_Zmax(var pu:typeUO):float;pascal;
procedure proTmatrix_Zmax(x:float;var pu:typeUO);pascal;


function fonctionTmatrix_theta(var pu:typeUO):float;pascal;
procedure proTmatrix_theta(x:float;var pu:typeUO);pascal;

function fonctionTmatrix_LogZ(var pu:typeUO): boolean;pascal;
procedure proTmatrix_LogZ(w: boolean;var pu:typeUO);pascal;

function fonctionTmatrix_AspectRatio(var pu:typeUO):float;pascal;
procedure proTmatrix_AspectRatio(x:float;var pu:typeUO);pascal;

function fonctionTmatrix_PixelRatio(var pu:typeUO):float;pascal;
procedure proTmatrix_PixelRatio(x:float;var pu:typeUO);pascal;

function fonctionTmatrix_gamma(var pu:typeUO):float;pascal;
procedure proTmatrix_gamma(x:float;var pu:typeUO);pascal;

function fonctionTmatrix_TwoColors(var pu:typeUO):boolean;pascal;
procedure proTmatrix_TwoColors(x:boolean;var pu:typeUO);pascal;

function fonctionTmatrix_PalColor(n:smallint;var pu:typeUO):smallInt;pascal;
procedure proTmatrix_PalColor(n:smallInt;x:smallInt;var pu:typeUO);pascal;

procedure proTmatrix_PalName(x:AnsiString;var pu:typeUO);pascal;
function fonctionTmatrix_PalName(var pu:typeUO):AnsiString;pascal;


procedure proTmatrix_AutoscaleZ(var pu:typeUO);pascal;
procedure proTmatrix_AutoscaleZsym(var pu:typeUO);pascal;
procedure proTmatrix_AutoscaleZmax(Vmin:float;var pu:typeUO);pascal;
procedure proTmatrix_AutoscaleXYZ(var pu:typeUO);pascal;

procedure proTmatrix_modify(t:integer;i1,i2,j1,j2:longint;var pu:typeUO);pascal;
procedure proTmatrix_setPosition(x,y,dx,dy,theta1:float;var pu:typeUO);pascal;
procedure proTmatrix_UsePosition(b:boolean;var pu:typeUO);pascal;
function fonctionTmatrix_UsePosition(var pu:typeUO):boolean;pascal;

procedure proTmatrix_onControl(b:boolean;var pu:typeUO);pascal;
function fonctionTmatrix_onControl(var pu:typeUO):boolean;pascal;

procedure proTmatrix_fill(x:float;var pu:typeUO);pascal;
procedure proTmatrix_inc(x,y:integer;var pu:typeUO);pascal;
procedure proTmatrix_dec(x,y:integer;var pu:typeUO);pascal;

function fonctionTmatrix_ConnectedPixels(seuil1,seuil2:float;var pu:typeUO):integer;pascal;
procedure proTmatrix_BuildCnxMap(seuil:float;var pu:typeUO);pascal;
procedure proTmatrix_BuildCnxMap_1(seuil:float;mode:integer;var pu:typeUO);pascal;

procedure proTmatrix_DisplayMode(x:smallint;var pu:typeUO);pascal;
function fonctionTmatrix_DisplayMode(var pu:typeUO):smallint;pascal;



procedure proTmatrix_UseWF(x:boolean;var pu:typeUO);pascal;
function fonctionTmatrix_UseWF(var pu:typeUO):boolean;pascal;

procedure proTmatrix_dxWF(x:float;var pu:typeUO);pascal;
function fonctionTmatrix_dxWF(var pu:typeUO):float;pascal;

procedure proTmatrix_dyWF(x:float;var pu:typeUO);pascal;
function fonctionTmatrix_dyWF(var pu:typeUO):float;pascal;

procedure proTmatrix_Mleft(x:float;var pu:typeUO);pascal;
function fonctionTmatrix_Mleft(var pu:typeUO):float;pascal;

procedure proTmatrix_Mtop(x:float;var pu:typeUO);pascal;
function fonctionTmatrix_Mtop(var pu:typeUO):float;pascal;

procedure proTmatrix_Mright(x:float;var pu:typeUO);pascal;
function fonctionTmatrix_Mright(var pu:typeUO):float;pascal;

procedure proTmatrix_Mbottom(x:float;var pu:typeUO);pascal;
function fonctionTmatrix_Mbottom(var pu:typeUO):float;pascal;



procedure proAddMatrix(var m,m1,m2:Tmatrix);pascal;
procedure proSubMatrix(var m,m1,m2:Tmatrix);pascal;
procedure proMultiplyMatrix(var m,m1,m2:Tmatrix);pascal;
procedure proDivideMatrix(var m,m1,m2:Tmatrix);pascal;

procedure proIncrementMatrix(var m,m1:Tmatrix;x:float);pascal;
procedure proKmultiplyMatrix(var m,m1:Tmatrix;x:float);pascal;


procedure proTmatrix_SelPix(i,j:integer;w:boolean;var pu:typeUO);pascal;
function fonctionTmatrix_SelPix(i,j:integer;var pu:typeUO):boolean;pascal;
procedure proTmatrix_SelColor(w:integer;var pu:typeUO);pascal;
function fonctionTmatrix_SelColor(var pu:typeUO):integer;pascal;

procedure proTmatrix_markPix(i,j:integer;w:boolean;var pu:typeUO);pascal;
function fonctionTmatrix_markPix(i,j:integer;var pu:typeUO):boolean;pascal;
procedure proTmatrix_markColor(w:integer;var pu:typeUO);pascal;
function fonctionTmatrix_markColor(var pu:typeUO):integer;pascal;

function fonctionTmatrix_Contour(var pu:typeUO):pointer;pascal;

function fonctionTmatrix_D3_D0(var pu:typeUO):float;pascal;
procedure proTmatrix_D3_D0(x:float;var pu:typeUO);pascal;

function fonctionTmatrix_D3_FOV(var pu:typeUO):float;pascal;
procedure proTmatrix_D3_FOV(x:float;var pu:typeUO);pascal;

function fonctionTmatrix_D3_ThetaX(var pu:typeUO):float;pascal;
procedure proTmatrix_D3_ThetaX(x:float;var pu:typeUO);pascal;

function fonctionTmatrix_D3_ThetaY(var pu:typeUO):float;pascal;
procedure proTmatrix_D3_ThetaY(x:float;var pu:typeUO);pascal;

function fonctionTmatrix_D3_ThetaZ(var pu:typeUO):float;pascal;
procedure proTmatrix_D3_ThetaZ(x:float;var pu:typeUO);pascal;

function fonctionTmatrix_D3_mode(var pu:typeUO):integer;pascal;
procedure proTmatrix_D3_mode(x:integer;var pu:typeUO);pascal;

function fonctionTmatrix_sum(var pu:typeUO):float;pascal;
function fonctionTmatrix_sum_1(i1,i2,j1,j2:integer;var pu:typeUO):float;pascal;

function fonctionTmatrix_SqrSum(var pu:typeUO):float;pascal;
function fonctionTmatrix_SqrSum_1(i1,i2,j1,j2:integer;var pu:typeUO):float;pascal;

function fonctionTmatrix_sumMdls(i1,i2,j1,j2:integer;var pu:typeUO):float;pascal;


function fonctionTmatrix_mean(var pu:typeUO):float;pascal;
function fonctionTmatrix_mean_1(i1,i2,j1,j2:integer;var pu:typeUO):float;pascal;

function fonctionTmatrix_CpxMean(var pu:typeUO):TfloatComp;pascal;
function fonctionTmatrix_CpxMean_1(i1,i2,j1,j2:integer;var pu:typeUO):TfloatComp;pascal;


function fonctionTmatrix_StdDev(var pu:typeUO):float;pascal;
function fonctionTmatrix_StdDev_1(i1,i2,j1,j2:integer;var pu:typeUO):float;pascal;

function fonctionTmatrix_mean0(var pu:typeUO):float;pascal;
function fonctionTmatrix_StdDev0(var pu:typeUO):float;pascal;
function fonctionTmatrix_sum0(var pu:typeUO):float;pascal;

procedure proTMatrix_VecToLine(var vec: Tvector;n:integer;var pu:typeUO);pascal;
procedure proTMatrix_VecToCol( var vec: Tvector;n: integer;var pu:typeUO);pascal;
procedure proTMatrix_LineToVec(n: integer; var vec: Tvector;var pu:typeUO);pascal;
procedure proTMatrix_ColToVec(n: integer; var vec: Tvector;var pu:typeUO);pascal;

procedure proZscoreMap(var src,dest:Tmatrix;Vmoy,Vsig,Zseuil:float;Fabove,Fzero:boolean);pascal;

procedure proTMatrix_CopyMat( var mat: Tmatrix;var pu:typeUO);pascal;

procedure proTmatrix_Threshold(th:float;Fup,Fdw:boolean;var pu:typeUO);pascal;
procedure proTmatrix_Threshold1(th:float;var pu:typeUO);pascal;
procedure proTmatrix_Threshold2(th1,th2,val1,val2:float;var pu:typeUO);pascal;


procedure proTmatrix_ClearSelPix(var pu:typeUO);pascal;
procedure proTmatrix_ClearMarkPix(var pu:typeUO);pascal;
procedure proTmatrix_SingleSel(w:boolean;var pu:typeUO);pascal;
function fonctionTmatrix_SingleSel(var pu:typeUO):boolean;pascal;
procedure proTmatrix_SingleMark(w:boolean;var pu:typeUO);pascal;
function fonctionTmatrix_SingleMark(var pu:typeUO):boolean;pascal;

procedure proTmatrix_OnSelect(p:integer;var pu:typeUO);pascal;
function fonctionTmatrix_OnSelect(var pu:typeUO):integer;pascal;

procedure proTmatrix_OnMark(p:integer;var pu:typeUO);pascal;
function fonctionTmatrix_OnMark(var pu:typeUO):integer;pascal;

procedure proTmatrix_OnHint(p:integer;var pu:typeUO);pascal;
function fonctionTmatrix_OnHint(var pu:typeUO):integer;pascal;


function fonctionTmatrix_SelectON(var pu:typeUO):boolean;pascal;
procedure proTmatrix_SelectON(x:boolean;var pu:typeUO);pascal;

function fonctionTmatrix_MarkON(var pu:typeUO):boolean;pascal;
procedure proTmatrix_MarkON(x:boolean;var pu:typeUO);pascal;

procedure proTmatrix_ShowContour(var pu:typeUO);pascal;

procedure proTMatrix_CenterOfGravity(var xG, yG: float;var pu:typeUO);pascal;

function fonctionTmatrix_loadFromBMP(stF:AnsiString;var pu:typeUO):boolean;pascal;
function fonctionTmatrix_saveAsBMP(stF:AnsiString;var pu:typeUO):boolean;pascal;

procedure proTmatrix_AngularMode(w:integer;var pu:typeUO);pascal;
function fonctionTmatrix_AngularMode(var pu:typeUO):integer;pascal;

procedure proTmatrix_AngLineWidth(w:integer;var pu:typeUO);pascal;
function fonctionTmatrix_AngLineWidth(var pu:typeUO):integer;pascal;

procedure proTmatrix_Edit(var pu:typeUO);pascal;
function fonctionTmatrix_Cmin(var pu:typeUO):float;pascal;
procedure proTmatrix_Cmin(x:float;var pu:typeUO);pascal;

function fonctionTmatrix_Cmax(var pu:typeUO):float;pascal;
procedure proTmatrix_Cmax(x:float;var pu:typeUO);pascal;
procedure proTmatrix_AutoscaleC(var pu:typeUO);pascal;

procedure proTmatrix_AgFilter(seuil:float;nbAg:integer; var pu:typeUO);pascal;
procedure proTmatrix_AgFilter_1(seuil:float;nbAg:integer;AbsMode:boolean; var pu:typeUO);pascal;

function fonctionTmatrix_loadFromSTK(stF:AnsiString;num:integer;var pu:typeUO):boolean;pascal;
procedure proTmatrix_ShowDesignWindow(var pu:typeUO);pascal;

procedure proTmatrix_setMapScale(Xextent,Yextent,Iorg,Jorg:float;var pu:typeUO);pascal;
procedure proMatToSectors(var mat:Tmatrix;var vec:Tvector;xa,ya,xb,yb,thresh:float;nb:integer);pascal;

function fonctionTmatrix_regionList(var pu:typeUO):pointer;pascal;

procedure proTmatrix_Full2DPalette(w:boolean;var pu:typeUO);pascal;
function fonctionTmatrix_Full2DPalette(var pu:typeUO):boolean;pascal;

procedure proTmatrix_saveSingleData(var binF, pu:typeUO);pascal;
procedure proTmatrix_saveSingleData_1(var binF:typeUO;FbyLine:boolean;var  pu:typeUO);pascal;

procedure proTmatrix_loadSingleData(var binF, pu:typeUO);pascal;
procedure proTmatrix_LoadSingleData_1(var binF:typeUO;FbyLine:boolean;var pu:typeUO);pascal;

function fonctionTMatrix_Transparent(var pu:typeUO):boolean;pascal;
procedure proTMatrix_Transparent(w:boolean;var pu:typeUO);pascal;

function fonctionTMatrix_TransparentValue(var pu:typeUO):float;pascal;
procedure proTMatrix_TransparentValue(w:float;var pu:typeUO);pascal;
procedure proTmatrix_distri(var vec, pu:typeUO);pascal;


procedure proTMatrix_loadFromText(fileName: AnsiString; var pu: Tmatrix);pascal;
procedure proTMatrix_saveAsText(fileName: AnsiString; decimalPlaces: integer; var pu: Tmatrix);pascal;

procedure proTMatrix_Circle(xC, yC, Rc, value: float;Ffill:boolean;var pu:Tmatrix);pascal;
procedure proTMatrix_Polygons(var plot:TXYplot; val1,val2: float;Ffill:boolean;var pu:Tmatrix);pascal;

function fonctionGetPalNameList: AnsiString;pascal;

IMPLEMENTATION

uses inimat0,stmCplot1,mat3Dform,stmMatU1,loadFromMat1,regEditor1, BinFile1;

var
  E_index:integer;
  E_modify1:integer;
  E_modify2:integer;
  E_indexOrder:integer;
  E_data:integer;
  E_create1:integer;
  E_create2:integer;
  E_displayMode:integer;
  E_aspectRatio:integer;
  E_copyMat:integer;

  E_Cmode:integer;




{********************* Méthodes de TMatrix ****************************}

constructor Tmatrix.create;
begin
  inherited;

  visu.color:=longint(2) shl 16+1;
  keepRatio:=true;


  ClevelCount:=10;
  ClineWidth:=1;

  with inf3D do
  begin
    D0:=100;
    fov:=60;
    thetaX:=-50;
    thetaY:=0;
    thetaZ:=0;
  end;
end;

constructor TMatrix.create(tNombre: typeTypeG; n1, n2, m1, m2: Integer);
begin
  create;
  initTemp(n1,n2,m1,m2,tNombre);
end;

destructor TMatrix.destroy;
begin
  data.free;
  data:=nil;

  if externalTemp then
  begin
    tbTemp:=nil;
    externalTemp:=false;
  end;

  editForm.free;
  FRegionList.free;
  FRegionList:=nil;
  regEditor.Free;
  regEditor:=nil;

  if FselPix<>nil then freemem(FselPix);
  if FmarkPix<>nil then freemem(FmarkPix);

  Cplot.free;
  Command3D.free;

  inherited destroy;
end;

procedure Tmatrix.createCplot;
begin
  if not assigned(Cplot) then
  begin
    Cplot:=TcontourPlot.create;
    Fcontour:=true;
    AddTochildList(Cplot);
  end;

  Cplot.setWorld(Xmin,Ymin,Xmax,Ymax);
  Cplot.cpx:=cpx;
  Cplot.cpy:=cpy;

  messageToRef(UOmsg_addObject,Cplot);
end;

procedure Tmatrix.setChildNames;
begin
  if assigned(Cplot) then
  with Cplot do
  begin
    ident:=self.ident+'.Contour';
    notPublished:=true;
    Fchild:=true;
  end;
end;

procedure Tmatrix.MemManagerEvent;
begin
  if assigned(data) then data.modifyAd(tb);
end;

procedure TMatrix.initTemp0(ad:pointer;n1,n2,m1,m2:longint;tNombre:typeTypeG);
var
  taille: int64;

begin
  data.free;
  data:=nil;

  nbcol:=n2-n1+1;
  nblig:=m2-m1+1;
  taille:=int64(tailleTypeG[tNombre])*nbCol*nbLig;

  if inf.temp and not externalTemp
    then freeTemp0
    else tbTemp:=nil;

  if ad<>nil then
  begin
    tbTemp:=ad;
    inf.tpNum:=tNombre;
    inf.temp:=true;
    externalTemp:=true;
    FtotSize:=taille;
  end
  else
  begin
    FmanagedMem:=true;
    inherited initTemp0(tNombre,taille,true);
    externalTemp:=false;
  end;
    
  with inf,visu do
  begin
    inf.imin:=n1;
    inf.imax:=n2;
    inf.jmin:=m1;
    inf.jmax:=m2;
  end;

  case tNombre of
    G_byte:      data:=TdatatbByte.create(tb^,n1,n2,m1,m2);
    G_short:     data:=TdatatbShort.create(tb^,n1,n2,m1,m2);
    G_smallint:  data:=TdatatbI.create(tb^,n1,n2,m1,m2);
    G_longint:   data:=TdatatbL.create(tb^,n1,n2,m1,m2);
    G_single:    data:=TdatatbS.create(tb^,n1,n2,m1,m2);
    G_double:    data:=TdatatbD.create(tb^,n1,n2,m1,m2);
    G_extended:  data:=TdatatbE.create(tb^,n1,n2,m1,m2);

    G_singleComp: data:=TdataTbScomp.create(tb^,n1,n2,m1,m2);
    G_doubleComp: data:=TdataTbDcomp.create(tb^,n1,n2,m1,m2);
    G_ExtComp:    data:=TdataTbExtcomp.create(tb^,n1,n2,m1,m2);
  end;

  if data<>nil then
    begin
      data.ax:=inf.dxu;
      data.bx:=inf.x0u;
      data.ay:=inf.dyu;
      data.by:=inf.y0u;
      data.az:=inf.dzu;
      data.bz:=inf.z0u;
    end;

  {PixelRatio:=1;}

  invalidate;
end;

procedure TMatrix.initTemp(n1,n2,m1,m2:longint;tNombre:typeTypeG);
begin
  { Si l'objet est externalTemp, la réallocation ne peut se faire que par initTempEx .
    Si un programme demande une réallocation du buffer avec des paramètres identiques,
    on ne fait rien.
    Sinon, on génère une erreur.
  }
  if (tb<>nil) and inf.temp and externalTemp  then
  begin
    if (tNombre<>inf.tpNum) or (n1<>inf.imin) or (n2<>inf.imax) or (m1<>inf.jmin) or (m2<>inf.jmax)
      then sortieErreur('Tmatrix : this object cannot be modified');
    invalidate;
    exit;
  end;

  initTemp0(nil,n1, n2, m1, m2, tNombre);
end;

procedure Tmatrix.initTempEx(ad:pointer;n1, n2, m1, m2: Integer; tNombre: typeTypeG);
begin
  initTemp0(ad,n1, n2, m1, m2, tNombre);
end;

procedure Tmatrix.setImageOptions;
begin
  inverseY:=true;
  keepRatio:=true;

  palColor[1]:=7;
  palColor[2]:=7;
end;

procedure Tmatrix.InitDataTemp;
begin
  with inf do initTemp(Imin,Imax,Jmin,Jmax,tpNum);
end;

class function Tmatrix.STMClassName:AnsiString;
begin
  STMClassName:='Matrix';
end;

procedure Tmatrix.modifyAd(ad:pointer);
begin
  tbTemp:=ad;
  data.modifyAd(ad);
end;

class Function Tmatrix.SupportType(tp:typetypeG):boolean;
begin
  result:= tp in [G_byte,G_short,G_smallint,{g_word,}g_longint,g_single,g_double,g_extended,
                  G_singleComp, G_doubleComp, G_extComp];
end;

function Tmatrix.isVisual:boolean;
begin
  isVisual:=true;
end;

function Tmatrix.getDispPriority: integer;
begin
  result:=1;
end;



procedure Tmatrix.display3D;

const
  spec: array [0..3] of GLfloat = (0.5, 0.5, 0.5, 0.5);
  spec1: array [0..3] of GLfloat = (1, 1, 1, 1);

var
  i,j:integer;
  asp:float;
  Kf,a,b:float;
  L: TCGLight;
  xC,yc:float;
  IendEff,JendEff:integer;
  Vmin,Vmax:float;

  norms:array of array of array of Tvector3s;
  norm0:array of array of Tvector3s;

  zz:float;
type
  Tcol=record
         r,g,b,a:byte;
       end;
var
  col:integer;
  col1:Tcol absolute col;

function get3DV(i,j:integer):float;
begin
  if visu.inverseX then i:=IendEff+Istart-i;
  if visu.inverseY then j:=JendEff+Jstart-j;

  result:=getSmoothVal(i,j);
end;


procedure calculeNorms;
var
  i,j:integer;
begin
  setLength(norms,2,IendEff-Istart+1,JendEff-Jstart+1);
  setLength(norm0,IendEff-Istart+1,JendEff-Jstart+1);


  for i:=Istart to IendEff-1 do
  for j:=Jstart to JendEff-1 do
    begin
      norms[0,i-Istart,j-Jstart]:=
        getTriangleNormal(i,j+1,get3DV(i,j+1)*a+b,
                          i,j,get3DV(i,j)*a+b,
                          i+1,j,get3DV(i+1,j)*a+b);

      norms[1,i-Istart,j-Jstart]:=
        getTriangleNormal(i+1,j,get3DV(i+1,j)*a+b,
                          i+1,j+1,get3DV(i+1,j+1)*a+b,
                          i,j+1,get3DV(i,j+1)*a+b);
    end;


  for i:=1 to IendEff-1-Istart-1 do
  for j:=1 to JendEff-1-Jstart-1 do
    if (i>0) and (j>0) and (i<IendEff-Istart) and (j<JendEff-Jstart) then
    begin
      norm0[i,j].x:=norms[0,i,j].x+norms[0,i,j-1].x+norms[0,i-1,j].x+
                    norms[1,i-1,j-1].x+norms[1,i-1,j].x+norms[1,i,j-1].x;
      norm0[i,j].y:=norms[0,i,j].y+norms[0,i,j-1].y+norms[0,i-1,j].y+
                    norms[1,i-1,j-1].y+norms[1,i-1,j].y+norms[1,i,j-1].y;
      norm0[i,j].z:=norms[0,i,j].z+norms[0,i,j-1].z+norms[0,i-1,j].z+
                    norms[1,i-1,j-1].z+norms[1,i-1,j].z+norms[1,i,j-1].z;

    end
    else norm0[i,j]:=norms[0,i,j];

end;



begin
  if BmExGlb=nil then exit;
  if (data=nil) or (data.Imax<data.Imin) or (data.Jmax<data.Jmin) then exit;

  case visu.modeMat of
    0:    begin
            IendEff:=Iend;
            JendEff:=Jend;
          end;
    1,2:  begin
            IendEff:=Istart+(Iend-Istart+1)*3-1;
            JendEff:=Jstart+(Jend-Jstart+1)*3-1;
          end;
  end;

  Kf:=(IendEff-Istart+1+JendEff-Jstart+1)/2;
  xc:=(Istart+IendEff)/2;
  yc:=(Jstart+JendEff)/2;

  selectClipRgn(BMexGlb.canvas.handle,0);

  data.modeCpx:=cpxMode mod 4;

  if not BmExGlb.initGLpaint then exit;
  TRY
    if inf3D.mode in [2,3] then
    begin
      glEnable(GL_DEPTH_TEST);
      {glEnable(GL_AUTO_NORMAL);}
      glEnable(GL_NORMALIZE);
      glLightModeli(GL_LIGHT_MODEL_TWO_SIDE, GL_TRUE);
      glShadeModel(GL_smooth);

    end;

    glViewPort(x1act,BmExGlb.height-y2act,x2act-x1act,y2act-y1act);
    asp:=(x2act-x1act)/(y2act-y1act);

    glMatrixMode(GL_PROJECTION);
    glLoadIdentity;
    gluPerspective(inf3D.fov,asp,1,1000);
    glMatrixMode(GL_MODELVIEW);

    glClearColor(1,0,0,0);
    glClear({GL_COLOR_BUFFER_BIT or} GL_DEPTH_BUFFER_BIT);
    glColor3f(0,0,1);

    glLoadIdentity;
    if inf3D.mode in [2,3] then
    begin
      L := TCGLight.Create(GL_LIGHT0);
      L.Position := cgVector(-100,0,100);

      L.Diffuse :=CGColorF(1,1,1,1);

      {L.Ambient:=CGColorF(1,0,0,1);}

      L.Infinite:=true;
      L.Enable;
    end;



    glLoadIdentity;
    gluLookAt(0,0,inf3D.D0/100*Kf,0,0,0,0,1,0);

    glRotatef(inf3D.thetaX,1,0,0);    {rotation autour de Ox}
    glRotatef(inf3D.thetaZ,0,0,1);    {rotation autour de Oz}


    glRotatef(theta,0,0,1);           {rotation propre}
    with data do
      glTranslatef(-xc,-yc,0); {centrage autour de O}


    a:=KF/(Zmax-Zmin);
    b:=-Kf/(Zmax-Zmin)*Zmin-Kf/2;


    case inf3D.mode of
      1:begin
          for i:=Istart to IendEff do
          begin
            glBegin(GL_LINE_STRIP);
            for j:=Jstart to JendEff do
              glVertex3f(i,j,get3DV(i,j)*a+b);
            glEnd;
          end;

          for j:=Jstart to JendEff do
          begin
            glBegin(GL_LINE_STRIP);
            for i:=Istart to IendEff do
              glVertex3f(i,j,get3DV(i,j)*a+b);
            glEnd;
          end;
        end;

      2:begin
          calculeNorms;

          glMaterialf(GL_FRONT, GL_SHININESS, 40);
          glMaterialfv(GL_FRONT, GL_SPECULAR, @spec[0]);

          glBegin(GL_Triangles);
          for i:=Istart to IendEff-1 do
            begin
              for j:=Jstart to JendEff-1 do
              begin
                glNormal3fv(@norm0[i-Istart,j-Jstart+1]);
                glVertex3f(i,j+1,get3DV(i,j+1)*a+b);

                glNormal3fv(@norm0[i-Istart,j-Jstart]);
                glVertex3f(i,j,get3DV(i,j)*a+b);

                glNormal3fv(@norm0[i-Istart+1,j-Jstart]);
                glVertex3f(i+1,j,get3DV(i+1,j)*a+b);

                glNormal3fv(@norm0[i-Istart+1,j-Jstart]);
                glVertex3f(i+1,j,get3DV(i+1,j)*a+b);

                glNormal3fv(@norm0[i-Istart+1,j-Jstart+1]);
                glVertex3f(i+1,j+1,get3DV(i+1,j+1)*a+b);

                glNormal3fv(@norm0[i-Istart,j-Jstart+1]);
                glVertex3f(i,j+1,get3DV(i,j+1)*a+b);
              end;
            end;
          glEnd;

          l.free;
        end;

      3:begin
          calculeNorms;

          dpal:=TDpalette.create;
          with visu do
          dpal.setColors(TmatColor(color).col1,TmatColor(color).col2,TwoCol,0);
          dpal.setType(palName);

          Vmin:=1E100;
          Vmax:=-1E100;
          getMinmax(Vmin,Vmax);

          dpal.SetPalette(Vmin*a+b,Vmax*a+b,gamma);

          glMaterialf(GL_FRONT, GL_SHININESS, 40);
          glMaterialfv(GL_FRONT, GL_SPECULAR, @spec[0]);
          glMaterialfv(GL_FRONT, GL_emission, @spec[1]);

          glColorMaterial(GL_FRONT_AND_BACK,GL_emission);
          glEnable(GL_Color_Material);

          glBegin(GL_Triangles);

          for i:=Istart to IendEff-1 do
            begin
              for j:=Jstart to JendEff-1 do
              begin
                zz:=get3DV(i,j+1)*a+b;
                col:=dpal.colorPal(zz);
                glColor3f(col1.r/255,col1.g/255,col1.b/255);
                glNormal3fv(@norm0[i-Istart,j-Jstart+1]);
                glVertex3f(i,j+1,zz);

                zz:=get3DV(i,j)*a+b;
                col:=dpal.colorPal(zz);
                glColor3f(col1.r/255,col1.g/255,col1.b/255);
                glNormal3fv(@norm0[i-Istart,j-Jstart]);
                glVertex3f(i,j,zz);

                zz:=get3DV(i+1,j)*a+b;
                col:=dpal.colorPal(zz);
                glColor3f(col1.r/255,col1.g/255,col1.b/255);
                glNormal3fv(@norm0[i-Istart+1,j-Jstart]);
                glVertex3f(i+1,j,zz);

                glNormal3fv(@norm0[i-Istart+1,j-Jstart]);
                glVertex3f(i+1,j,zz);

                zz:=get3DV(i+1,j+1)*a+b;
                col:=dpal.colorPal(zz);
                glColor3f(col1.r/255,col1.g/255,col1.b/255);
                glNormal3fv(@norm0[i-Istart+1,j-Jstart+1]);
                glVertex3f(i+1,j+1,zz);

                zz:=get3DV(i,j+1)*a+b;
                col:=dpal.colorPal(zz);
                glColor3f(col1.r/255,col1.g/255,col1.b/255);
                glNormal3fv(@norm0[i-Istart,j-Jstart+1]);
                glVertex3f(i,j+1,zz);
              end;
            end;

          glEnd;

          l.free;
          dpal.Free;
        end;


      4:begin
          glCullFace(GL_back);
          glEnable(GL_Cull_Face);
          glEnable(GL_DEPTH_TEST);
          glPolygonMode(GL_front_and_back,GL_line);
          glBegin(GL_Triangles);
          for i:=Istart to IendEff-1 do
            begin
              for j:=Jstart to JendEff-1 do
              begin
                TriangleWith2edges(i,j+1,get3DV(i,j+1)*a+b,
                                   i,j,get3DV(i,j)*a+b,
                                   i+1,j,get3DV(i+1,j)*a+b
                                   );

                TriangleWith2edges(i+1,j,get3DV(i+1,j)*a+b,
                                   i+1,j+1,get3DV(i+1,j+1)*a+b,
                                   i,j+1,get3DV(i,j+1)*a+b
                                   );
              end;
            end;
          glEnd;

        end;

    end;
  FINALLY
    BmExGlb.doneGLpaint;
    data.modeCpx:=0;
  END;
end;

procedure Tmatrix.freeDXresources;
begin
  if assigned(DXgrid) then DXgrid.freeResources;
end;

procedure Tmatrix.display3DX(Idevice: IDirect3DDevice9);
begin
  if not assigned(DXgrid) then DXgrid:=TDXgrid.create;
  DXgrid.initData(self);
  DXgrid.InitResources(Idevice);

  DXgrid.Display(Idevice,self);
end;

function Tmatrix.isSelected:boolean;
var
  i:integer;
begin
  result:=true;

  if assigned(FselPix) then
    for i:=0 to nblig*nbcol-1 do
      if FselPix[i] then exit;
  if assigned(FmarkPix) then
    for i:=0 to nblig*nbcol-1 do
      if FmarkPix[i] then exit;

  result:=false;
end;

procedure Tmatrix.display;
var
  x1,y1,x2,y2:integer;
  rectS:Trect;
  getSel,getMark:function(i,j:integer):boolean of object;

begin
  if isSelected then
  begin
    getSel:=getSelPix;
    getMark:=getMarkPix;
  end
  else
  begin
    getSel:=nil;
    getMark:=nil;
  end;

    if FinvCell then
      begin
        if inf3D.mode=0
          then visu.displayMat(data,palName,true,InvCol,InvRow,@wf, degP,getSel,getMark,FTransparentValue,Ftransparent);
      end
    else
    begin
      if (inf3D.mode in [1..4]) then display3D
      else
      visu.displayMat(data,palName,false,0,0,@wf,degP,getSel,getMark);
    end;

end;

procedure Tmatrix.displayInside(FirstUO:typeUO;extWorld,logX,logY:boolean;const order:integer=-1);
begin
  if isSelected
    then visu.displayMat0(data,extWorld,palName,false,0,0,@wf,degP,
                     getSelPix,getMarkPix,
                     FTransparentValue,Ftransparent)
    else visu.displayMat0(data,extWorld,palName,false,0,0,@wf,degP,
                     nil,nil,
                     FTransparentValue,Ftransparent);


end;


procedure Tmatrix.DinvalidateCell(i,j:integer);
var
  index:integer;
begin
  if isComplex
    then index:=Istart+(i-Istart) div 2
    else index:=i;

  FinvCell:=true;
  invCol:=index;
  invRow:=j;
  messageToRef(UOmsg_SimpleRefresh,nil);
  invalidateForm;
  FinvCell:=false;
end;

procedure Tmatrix.DinvalidateVector(i:integer);
begin
  invalidate;
end;

procedure Tmatrix.DinvalidateAll;
begin
  invalidate;
end;

procedure Tmatrix.DsetKvalue(b:boolean);
begin
  if b then
    begin
      EditForm.getTabValue:=DgetI;
      EditForm.setTabValue:=DsetI;
      EditForm.UseDecimale:=false;
    end
  else
    begin
      EditForm.getTabValue:=getE;
      EditForm.setTabValue:=setE;
      EditForm.UseDecimale:=true;
    end;
end;

procedure Tmatrix.DsetI(i,j:integer;x:float);
begin
  setI(i,j,roundL(x));
end;

function Tmatrix.DgetI(i,j:integer):float;
begin
  result:=getI(i,j);
end;

procedure Tmatrix.DsetE(i,j:integer;x:float);
var
  index:integer;
begin
  if isComplex then
  begin
    index:=Istart+(i-Istart) div 2 ;
    case (i-Istart) mod 2 of
      0: Zvalue[index,j]:=x;
      1: Imvalue[index,j]:=x;
    end;
  end
  else Zvalue[i,j]:=x;
end;


function Tmatrix.DgetE(i,j:integer):float;
var
  index:integer;
begin
  if isComplex then
  begin
    index:=Istart+(i-Istart) div 2 ;
    case (i-Istart) mod 2 of
      0: result:= Zvalue[index,j];
      1: result:= Imvalue[index,j];
    end;
  end
  else result:=Zvalue[i,j];
end;

function Tmatrix.DgetColName(i:integer):Ansistring;
var
  index:integer;
begin
  if isComplex then
  begin
    index:=Istart+(i-Istart) div 2 ;
    case (i-Istart) mod 2 of
      0: result:= Istr(index)+'.Re';
      1: result:= Istr(index)+'.Im';
    end;
  end
  else result:=Istr(i);
end;


procedure TMatrix.afficheC;
var
  affMat:typeAffmat;
  x,y,dx,dy:integer;
  degW:typeDegre;
begin
  with degP do
    if (dx<=0) or (dy<=0) then exit;

  // on crée un deg en pixels
  with degW do
  begin
    x:=degToXc(degP.x);
    y:=degToYc(degP.y);
    dx:=degToPixC(degP.dx);
    dy:=degToPixC(degP.dy);
    theta:=degP.theta;
    Fuse:=false;
    Fcontrol:=true;
  end;

  visu.displayMat0(data,false,palName,false,0,0,@wf,degW,
                     getSelPix,getMarkPix,
                     0,false,true);

end;


procedure TMatrix.cadrerX(sender:Tobject);
  begin
    if data=nil then exit;
    if Dxu>0 then
    begin
      visu0^.Xmin:=data.convx(data.iMin);
      visu0^.Xmax:=data.convX(data.iMax+1);
    end
    else
    begin
      visu0^.Xmin:=data.convx(data.iMax);
      visu0^.Xmax:=data.convX(data.iMin-1);
    end
  end;

procedure TMatrix.cadrerY(sender:Tobject);
  begin
    if data=nil then exit;
    if Dyu>0 then
    begin
      visu0^.Ymin:=data.convy(data.jMin);
      visu0^.Ymax:=data.convy(data.jMax+1);
    end
    else
    begin
      visu0^.Ymin:=data.convy(data.jMax);
      visu0^.Ymax:=data.convy(data.jMin-1);
    end;
  end;

procedure TMatrix.cadrerZ(sender:Tobject);
  var
    Vmin,Vmax:float;
  begin
    if data=nil then exit;
    Vmin:=1E300;
    Vmax:=-1E300;

    data.modeCpx:=visu0^.cpxMode mod 4;
    data.getMinMaxE(Vmin,Vmax);
    data.modeCpx:=0;

    visu0^.Zmin:=Vmin;
    visu0^.Zmax:=Vmax;
  end;

procedure TMatrix.cadrerC(sender:Tobject);
var
  Vmin,Vmax:float;
begin
  if data=nil then exit;
  Vmin:=1E300;
  Vmax:=-1E300;

  case visu0^.cpxMode of
    4: data.modeCpx:=1;
    5: data.modeCpx:=0;
    6: data.modeCpx:=3;
    7: data.modeCpx:=2;
  end;

  data.getMinMaxE(Vmin,Vmax);
  data.modeCpx:=0;

  visu0^.Cmin:=Vmin;
  visu0^.Cmax:=Vmax;
end;


function Tmatrix.ChooseCoo1:boolean;
var
  chg:boolean;
  title0:Ansistring;
  palName0:Ansistring;
  wf0:TwfOptions;
  degP0:typeDegre;
begin
  Initvisu0;

  title0:=title;
  palName0:=palName;
  wf0:=wf;
  degP0:=degP;

  if Matcood.choose(title0,visu0^,palName0,@wf,degP0,cadrerX,cadrerY,cadrerZ,cadrerC) then
    begin
      chg:= not visu.compare(visu0^) or (title<>title0)
            or (palName0<>palName) or not compareMem(@wf,@wf0,sizeof(wf))
            or not Comparemem(@degP,@degP0,sizeof(degP));
      visu.Assign(visu0^);
      title:=title0;
      palName:=palName0;
      degP:=degP0;

    end
  else chg:=false;

  DoneVisu0;
  chooseCoo1:=chg;
end;


procedure Tmatrix.recupLumParam(l1,l2,g:integer);
begin
  with inf,visu do
  begin
    Zmax:=l1;
    Zmin:=l2;
    gamma:=g;
  end;
end;

procedure Tmatrix.createForm;
var
  st:AnsiString;
begin
  with inf,visu do
  begin
    form:=TpForm.create(formStm);
    with TpForm(form) do
    begin
      Uplot:=self;
      caption:=ident;
      form.color:=BKcolor;
      form.font.color:=ClWhite;
      beginDragG:=GbeginDrag;
      {coordinates1.onClick:=ChooseCoo;}
    end;
  end;
end;

function Tmatrix.getRegionList:TregionList;
begin
  if not assigned(FregionList) then
  begin
    FregionList:=TregionList.create;
    FregionList.ident:=ident+'.regions';
    addToChildList(FregionList);
  end;
  result:=FregionList;
end;

procedure Tmatrix.createRegEditor;
begin
  if not assigned(regEditor) then
  begin
    regEditor:=TregEditor.create(formStm);
    regEditor.Caption:=ident+' regions';
    TregEditor(regEditor).install(self,self,regionList);
  end;
end;

procedure Tmatrix.ShowDesignForm;
begin
  createRegEditor;
  TregEditor(regEditor).show;
end;

procedure Tmatrix.ShowSelectWindow(sender:Tobject);
begin
  showDesignForm;
end;


procedure Tmatrix.incI(x,y:longint);
begin
  data.addI(x,y,1);
end;

procedure Tmatrix.clear;
begin
  if data<>nil then data.raz;
end;


function Tmatrix.DialogForm:TclassGenForm;
begin
  DialogForm:=TgetMatrix;
end;

procedure Tmatrix.installDialog(var form1:Tgenform;var newF:boolean);
begin
  installForm(form1,newF);

  with TgetMatrix(Form1) do
  begin
    onshowD:=self.show;
    onControlD:=setOnControl;
    VonControl:=onControl;
    CbOnControl.setVar(VonControl);
  end;
end;

procedure Tmatrix.modifyLimits(i1,i2,j1,j2:integer);
begin
  inf.imin :=i1;
  inf.imax :=i2;
  inf.jmin :=j1;
  inf.jmax :=j2;

  if assigned(data) then
  begin
    data.imin :=i1;
    data.imax :=i2;
    data.jmin :=j1;
    data.jmax :=j2;
  end;

end;

procedure Tmatrix.setIstart(w: integer);
var
  old:integer;
begin
  old:=Istart;
  modifyLimits(w,Iend+w-old,Jstart,Jend);
end;

procedure Tmatrix.setIend(w: integer);
var
  old:integer;
begin
  old:=Iend;
  modifyLimits(Istart+w-old,w,Jstart,Jend);
end;

procedure Tmatrix.setJstart(w: integer);
var
  old:integer;
begin
  old:=Jstart;
  modifyLimits(Istart,Iend,w,Jend+w-old);
end;

procedure Tmatrix.setJend(w: integer);
var
  old:integer;
begin
  old:=Jend;
  modifyLimits(Istart,Iend,Jstart+w-old,w);
end;


procedure Tmatrix.setDx(x:double);
begin
  inherited setDx(x);
  data.ax:=x;
end;

procedure Tmatrix.setx0(x:double);
begin
  inherited setx0(x);
  data.bx:=x;
end;

procedure Tmatrix.setDy(x:double);
begin
  inherited setDy(x);
  data.ay:=x;
end;

procedure Tmatrix.setY0(x:double);
begin
  inherited setY0(x);
  data.by:=x;
end;

procedure Tmatrix.autoscaleX;
begin
  if Dxu>0 then
  begin
    Xmin:= convX(inf.Imin);
    Xmax:= convX(inf.Imax+1);
  end
  else
  begin
    Xmin:= convX(inf.Imax);
    Xmax:= convX(inf.Imin-1);
  end;
end;


procedure Tmatrix.autoscaleY;
begin
  if Dyu>0 then
  begin
    Ymin:= convY(inf.Jmin);
    Ymax:= convY(inf.Jmax+1);
  end
  else
  begin
    Ymin:= convY(inf.Jmax);
    Ymax:= convY(inf.Jmin-1);
  end;
end;

procedure Tmatrix.setDz(x:double);
begin
  inf.Dzu:=x;
  data.az:=x;
end;

procedure Tmatrix.setZ0(x:double);
begin
  inf.Z0u:=x;
  data.bz:=x;
end;



procedure Tmatrix.autoscaleZ;
var
  min,max:float;
begin
  min:=1E300;
  max:=-1E300;

  getMinMax(min,max);

  visu.Zmin:=min;
  visu.Zmax:=max;
end;

procedure Tmatrix.autoscaleC;
var
  Vmin,Vmax:float;
begin
  if data=nil then exit;
  Vmin:=1E300;
  Vmax:=-1E300;

  case visu.cpxMode of
    4: data.modeCpx:=1;
    5: data.modeCpx:=0;
    6: data.modeCpx:=3;
    7: data.modeCpx:=2;
  end;

  data.getMinMaxE(Vmin,Vmax);
  data.modeCpx:=0;

  visu.Cmin:=Vmin;
  visu.Cmax:=Vmax;
end;

procedure Tmatrix.autoscaleZsym;
var
  min,max:float;
begin
  min:=1E300;
  max:=-1E300;

  getMinMax(min,max);

  if abs(min)>abs(max) then
    begin
      visu.Zmin:=-abs(min);
      visu.Zmax:=abs(min);
    end
  else
    begin
      visu.Zmin:=-abs(max);
      visu.Zmax:=abs(max);
    end;
end;

procedure Tmatrix.autoscaleZmax(vmin:float);
var
  min,max:float;
begin
  min:=1E300;
  max:=-1E300;

  getMinMax(min,max);

  visu.Zmin:=Vmin;
  if max>=Vmin
    then visu.Zmax:=max
    else visu.Zmax:=Vmin;
end;


function Tmatrix.initialise(st:AnsiString):boolean;
begin
  inherited initialise(st);

  if initTmatrix.execution('New matrix: '+ident,self,'') then
    begin
      with inf do initTemp(imin,imax,jmin,jmax,tpNum);

      setChildNames;
      initialise:=true;
    end
  else initialise:=false;
end;

procedure Tmatrix.BuildInfo(var conf:TblocConf;lecture,tout:boolean);
begin
  inherited;
  with conf do
  begin
    setvarConf('DegP',degP,sizeof(degP));
    setStringConf('PalName',FPalName);
    setvarConf('WFopt',wf,sizeof(wf));
    setvarConf('Contour',Fcontour,sizeof(Fcontour));

    setvarConf('Inf3D',inf3D,sizeof(inf3D));

    if lecture then
    begin
      freemem(FselPix);
      FselSize:=0;
      freemem(FMarkPix);
      FMarkSize:=0;
    end
    else
    begin
      if assigned(FselPix)then FselSize:=nblig*nbcol;
      if assigned(FmarkPix)then FmarkSize:=nblig*nbcol;
    end;

    if lecture or assigned(FselPix) then setDynConf('SelPix',FSelPix,FselSize);
    if lecture or assigned(FmarkPix) then setDynConf('MarkPix',FmarkPix,FmarkSize);

  end;
end;

procedure Tmatrix.completeLoadInfo;
begin
  inherited completeLoadInfo ;

  InitDataTemp;

  if Fcontour then
    begin
      createCplot;
      setChildNames;
    end;
end;

procedure Tmatrix.Doncontrol(sender:Tobject);
begin
  if not assigned(DXcontrol) then exit;
  onControl:=not onControl;
end;

procedure Tmatrix.CgetZminZmax(var min,max:float);
begin
  min:=1E100;
  max:=-1E100;
  getminMax(min,max);

end;


procedure Tmatrix.BuildContour(sender:Tobject);
var
  delta:float;
  i:integer;
  oldTitle:AnsiString;
  ContpalName:AnsiString;
  dpal:TDpalette;
  Nzero:integer;
begin
  if Fcontour
    then oldTitle:=Cplot.title
    else oldTitle:='@@@';

  createCplot;
  setChildNames;
  if oldTitle<>'@@@' then Cplot.title:=oldTitle;

  buildContourForm.getZminZmax:=CgetZminZmax;

  if buildContourForm.execution(CLevelCount,CZmin,CZmax,CFsel,CFmark,CFvalue,Cvalue,ClineWidth,Cpolygons,CusePos,Czero) then
    begin
      if ClevelCount<=0 then exit;

      if CZmax<CZmin then exit;

      delta:=(CZmax-CZmin);
      if ClevelCount>1 then delta:=delta/(ClevelCount-1);

      Cplot.clear;

      if  buildContourForm.PalName<>'None' then
      begin
        dpal:=TDpalette.create;
        dpal.setType(buildContourForm.PalName);
        dpal.SetPalette(CZmin,CZmax,1);
      end
      else dpal:=nil;

      Cplot.largeurTrait:=ClineWidth;
      if (CZmax>CZmin) and (Czero>=CZmin) and (Czero<=CZmax)
        then Nzero:= round((ClevelCount-1)*(CZero-CZmin)/(CZmax-CZmin))
        else Nzero:=0;

      if Cpolygons then TcontourPlot(Cplot).modeT:=DM_polygon;

      for i:=Nzero to ClevelCount-1 do
        with TcontourPlot(Cplot) do
        begin
          if assigned(dpal)
            then NextColor:=dpal.ColorPal(CZmin+delta*i)
            else Nextcolor:=buildContourForm.Pcolor.color;
          NextColor2:=NextColor;

          setOptions(CFsel,CFmark,CFvalue,Cvalue);
          calcul(self,CZmin+delta*i,CusePos);

        end;

      for i:=Nzero-1 downto 0 do
        with TcontourPlot(Cplot) do
        begin
          if assigned(dpal)
            then NextColor:=dpal.ColorPal(CZmin+delta*i)
            else Nextcolor:=buildContourForm.Pcolor.color;
          NextColor2:=NextColor;

          setOptions(CFsel,CFmark,CFvalue,Cvalue);
          calcul(self,CZmin+delta*i,CusePos);
        end;

      TcontourPlot(Cplot).invalidate;
      dpal.Free;
    end;

end;


function Tmatrix.getPopUp:TpopupMenu;
begin
  with PopUps do
  begin
    PopupItem(pop_Tmatrix,'Tmatrix_Coordinates').onClick:=ChooseCoo;
    PopupItem(pop_Tmatrix,'Tmatrix_ShowMatrix').onClick:=self.Show;
    PopupItem(pop_Tmatrix,'Tmatrix_Show3Dcommands').onClick:=Show3Dcommands;
    PopupItem(pop_Tmatrix,'Tmatrix_ShowSelectWindow').onClick:=ShowSelectWindow;

    PopupItem(pop_Tmatrix,'Tmatrix_Properties').onClick:=Proprietes;
    PopupItem(pop_Tmatrix,'Tmatrix_Edit').onClick:=EditMatrix;

    PopupItem(pop_Tmatrix,'Tmatrix_SelectMode').onClick:=SelectPixel;
    PopupItem(pop_Tmatrix,'Tmatrix_SelectMode').checked:=SelectMode;

    PopupItem(pop_Tmatrix,'Tmatrix_MarkMode').onClick:=MarkPixel;
    PopupItem(pop_Tmatrix,'Tmatrix_MarkMode').checked:=MarkMode;

    PopupItem(pop_Tmatrix,'Tmatrix_BuildContourPlot').onClick:=BuildContour;
    PopupItem(pop_Tmatrix,'Tmatrix_Clone').onClick:=CreateClone;
    PopupItem(pop_Tmatrix,'Tmatrix_SaveObject').onClick:=SaveObjectToFile;

    PopUpItem(pop_Tmatrix,'Tmatrix_FileLoadFromMatrix').onclick:=FileLoadFromMatrix;
    PopUpItem(pop_Tmatrix,'Tmatrix_FileLoadFromObjectFile').onclick:=FileLoadFromObjFile;


    with PopupItem(pop_Tmatrix,'Tmatrix_OnControl') do
    begin
      if not OnControl
        then caption:='On control'
        else caption:='Remove from control';
      onClick:=DonControl;
      visible:=assigned(DXcontrol);
    end;
    result:=pop_Tmatrix;
  end;
end;

procedure Tmatrix.matProp(stOpt:AnsiString);

var
  inf1:TinfoDataObj;
  Fedit:boolean;
begin
  inf1:=inf;
  if initTmatrix.execution(Ident+' properties',self,stOpt) then
    begin
      Fedit:=assigned(editForm) and editForm.visible;
      if Fedit then editForm.hide;

      if (inf1.Imin<>inf.Imin) or (inf1.Imax<>inf.Imax) or
         (inf1.Jmin<>inf.Jmin) or (inf1.Jmax<>inf.Jmax) or
         (inf1.tpNum<>inf.tpNum)
        then initTemp(inf.imin,inf.imax,inf.jmin,inf.jmax,inf.tpNum);

      if (inf1.dxu<>inf.dxu) or (inf1.x0u<>inf.x0u) or
         (inf1.dyu<>inf.dyu) or (inf1.y0u<>inf.y0u) or
         (inf1.dzu<>inf.dzu) or (inf1.z0u<>inf.z0u) then
        begin
          Dxu:=inf.dxu;
          X0u:=inf.x0u;
          Dyu:=inf.dyu;
          Y0u:=inf.y0u;
          Dzu:=inf.dzu;
          Z0u:=inf.z0u;
         end;

      invalidate;
      if assigned(editForm) then createEditForm;

      if Fedit then editForm.show;

    end;
end;

procedure Tmatrix.proprietes(sender:Tobject);
begin
  matProp('');
end;

procedure Tmatrix.createEditForm;
begin
  deciSize:=(Iend-Istart+1)*(1+ord(isComplex));
  setlength(TbDeci,decisize);
  fillchar(tbdeci[0],deciSize,3);

  if not assigned(editform)
    then Editform:=TtableEdit.create(formStm);

  with EditForm do
  begin
    installe(Istart,Jstart,Iend +Icount*ord(isComplex),Jend);
    caption:=ident;

    getColName:=DgetColName;
    getTabValue:=DgetE;
    setTabValue:=DsetE;

    getDeciValue:=self.getDeci;
    setDeciValue:=self.setDeci;


    invalidateCellD:=DinvalidateCell;
    invalidateVectorD:=DinvalidateVector;
    invalidateAllD:=DinvalidateAll;

    setKvalueD:=DsetKvalue;
    clearData:=self.clear;

    adjustFormSize;
    UseKvalue1.visible:=true;
  end;
end;

procedure Tmatrix.EditMatrix(sender:Tobject);
begin
  if not assigned(editForm) then createEditForm;
  EditForm.show;
end;

procedure Tmatrix.EditModal;
begin
  if not assigned(editForm) then createEditForm;
  EditForm.showModal;
end;


procedure Tmatrix.adjustEditForm;
begin
  with editForm do
  begin
    deciSize:=(Iend-Istart+1)*(1+ord(isComplex));
    setLength(tbDeci,deciSize);
    fillchar(tbDeci[0],deciSize,3);

    installe(Istart,Jstart,Iend,Jend);
    adjustFormSize;
  end;
end;

procedure Tmatrix.modify(t:typetypeG;i1,j1,i2,j2:integer);
var
  Fedit:boolean;
begin
  Fedit:=assigned(editForm) and editForm.visible;
  if Fedit then editForm.hide;

  initTemp(i1,i2,j1,j2,t);

  if assigned(editForm) then adjustEditForm;
  if Fedit then editForm.show;
end;

procedure Tmatrix.verifierIndices(i,j:integer);
begin
  if (data=nil) then sortieErreur(E_data)
  else
  if (i<data.imin) or (i>data.imax) or (j<data.jmin) or (j>data.jmax)
    then  sortieErreur(E_index);
end;

procedure Tmatrix.setE(i,j:integer;x:float);
begin
  verifierIndices(i,j);
  data.setE(i,j,x);
end;

function Tmatrix.getE(i,j:integer):float;
begin
  result:=0;
  verifierIndices(i,j);
  result:=data.getE(i,j)
end;

procedure Tmatrix.setI(i,j,k:integer);
begin
  verifierIndices(i,j);
  data.setI(i,j,k)
end;

function Tmatrix.getI(i,j:integer):integer;
begin
  result:=0;
  verifierIndices(i,j);
  result:=data.getI(i,j)
end;

procedure Tmatrix.setR(x,y,z:float);
var
  i,j:integer;
begin
  i:=invconvx(x);
  j:=invconvx(y);
  setE(i,j,z);
end;

function Tmatrix.getR(x,y:float):float;
var
  i,j:integer;
begin
  i:=invconvx(x);
  j:=invconvx(y);
  result:=getE(i,j);
end;

procedure Tmatrix.setCpx(i,j:integer;w:TfloatComp);
begin
  verifierIndices(i,j);
  data.setCpx(i,j,w);
end;

function Tmatrix.getCpx(i,j:integer):TfloatComp;
begin
  result.x:=0;
  result.y:=0;

  verifierIndices(i,j);
  result:=data.getCpx(i,j);
end;

procedure Tmatrix.setIm(i,j:integer;w:float);
begin
  verifierIndices(i,j);
  data.setIm(i,j,w)
end;

function Tmatrix.getIm(i,j:integer):float;
begin
  result:=0;
  verifierIndices(i,j);
  result:=data.getIm(i,j);
end;


procedure TMatrix.AddE(i,j: integer; w: float);
begin
  verifierIndices(i,j);
  data.AddE(i,j,w);
end;

function Tmatrix.Ystart:float;
  begin
    Ystart:=convY(inf.Jmin);
  end;

function Tmatrix.Yend:float;
  begin
    Yend:=convY(inf.Jmax);
  end;

function Tmatrix.getJstart:integer;
begin
  result:=inf.Jmin;
end;

function Tmatrix.getJend:longint;
begin
  result:=inf.Jmax;
end;

function Tmatrix.getScore(i,j:integer;seuil1,seuil2:float):integer;
var
  i1,j1,k:integer;
begin
  result:=0;
  k:=(i-Istart)*(Jend-Jstart+1)+j-Jstart;
  if mark^[k] then exit;

  mark^[k]:=true;

  if (data.getE(i,j)>seuil1) and (data.getE(i,j)<seuil2) then exit;

  result:=1;

  for i1:=i-1 to i+1 do
    for j1:=j-1 to j+1 do
      if not ( (i1=i) and (j1=j) ) and
         (i1>=Istart) and (i1<=Iend) and
         (j1>=Jstart) and (j1<=Jend)
        then result:=result+getScore(i1,j1,seuil1,seuil2);
end;

function Tmatrix.ConnectedPixels(seuil1,seuil2:float):integer;
var
  i,j,k:integer;

begin
  getmem(mark,(Iend-Istart+1)*(Jend-Jstart+1) );
  fillChar(mark^,(Iend-Istart+1)*(Jend-Jstart+1),0 );

  result:=0;
  for i:=Istart to Iend do
    for j:=Jstart to Jend do
      begin
        k:=getScore(i,j,seuil1,seuil2);
        if k>result then result:=k;
      end;

  freemem(mark,(Iend-Istart+1)*(Jend-Jstart+1) );

end;


{ Construction d'une carte de connectivité
  FilterMode=0 : on remplace la valeur de pixel par le nombre de pixels de l'agrégat
                 auquel il appartient.
  FilterMode=1 : On met des zéros dans la matrice si la valeur d'agrégat est inférieure à NbFil

  FilterMode=2 : Comme 1, mais nbFil est fixé automatiquement à la plus grande valeur d'agrégat

  FilterMode=3 : Comme 0 mais on remplace la valeur de pixel par la moyenne de l'agrégat.
}
procedure Tmatrix.BuildCnxMap(seuil:float;FilterMode:integer;NbFil:integer;const AbsMode:boolean=false);
var
  mark: array of array of integer;
  flag: array of array of boolean;
  sumZ: array of array of float;
  i,j,k:integer;
  imax,jmax,kmax:integer;
  w:float;

  function getCnx(i0,j0:integer;var w:float):integer;
  var
    i,j,k:integer;
    w1:float;
  begin
    result:=0;
    w:=0;
    if flag[i0-Istart,j0-Jstart] then exit;

    flag[i0-Istart,j0-Jstart]:=true;
    if not AbsMode and (Zvalue[i0,j0]<seuil) or AbsMode and (abs(Zvalue[i0,j0])<seuil) then exit;

    result:=1;
    w:=Zvalue[i0,j0];

    for i:=i0-1 to i0+1 do
      for j:=j0-1 to j0+1 do
        if not ( (i=i0) and (j=j0) ) and
           (i>=Istart) and (i<=Iend) and
           (j>=Jstart) and (j<=Jend) then
           begin
             result:=result+getCnx(i,j,w1);
             w:=w+w1;
           end;
  end;

  procedure buildCnx(i0,j0,k:integer;w:float);
  var
    i,j:integer;
  begin
    if mark[i0-Istart,j0-Jstart]<>0 then exit;

    if not AbsMode and (Zvalue[i0,j0]<seuil) or AbsMode and (abs(Zvalue[i0,j0])<seuil) then
    begin
      mark[i0-Istart,j0-Jstart]:=-1;
      exit;
    end;

    mark[i0-Istart,j0-Jstart]:=k;
    sumZ[i0-Istart,j0-Jstart]:=w;

    for i:=i0-1 to i0+1 do
      for j:=j0-1 to j0+1 do
        if (i>=Istart) and (i<=Iend) and
           (j>=Jstart) and (j<=Jend)
          then BuildCnx(i,j,k,w);;
  end;


begin
  setLength(mark,Iend-Istart+1,Jend-Jstart+1 );
  setLength(flag,Iend-Istart+1,Jend-Jstart+1 );
  setLength(sumZ,Iend-Istart+1,Jend-Jstart+1 );

  for i:=0 to Iend-Istart do
    for j:=0 to Jend-Jstart do
    begin
      mark[i,j]:=0;
      flag[i,j]:=false;
      sumZ[i,j]:=0;
    end;

  kmax:=0;
  for i:=Istart to Iend do
    for j:=Jstart to Jend do
    begin
      k:=getCnx(i,j,w);
      if k>kmax then
      begin
        kmax:=k;
        imax:=i;
        jmax:=j;
      end;
      BuildCnx(i,j,k,w);
    end;

  case FilterMode of
    0:begin
        for i:=Istart to Iend do
        for j:=Jstart to Jend do
          if mark[i-Istart,j-Jstart]>=0
            then Zvalue[i,j]:=mark[i-Istart,j-Jstart]
            else Zvalue[i,j]:=0;
      end;
    1:begin
        for i:=Istart to Iend do
        for j:=Jstart to Jend do
          if mark[i-Istart,j-Jstart]<nbFil
            then Zvalue[i,j]:=0;
      end;
    2:begin
        for i:=Istart to Iend do
        for j:=Jstart to Jend do
          if mark[i-Istart,j-Jstart]<>kmax
            then Zvalue[i,j]:=0;
      end;

    3:begin
        for i:=Istart to Iend do
        for j:=Jstart to Jend do
          if mark[i-Istart,j-Jstart]>=0
            then Zvalue[i,j]:=sumZ[i-Istart,j-Jstart]
            else Zvalue[i,j]:=0;
      end;
  end;
end;


function Tmatrix.getInsideWindow:Trect;
begin
  result:=visu.getInsideMat(data,@wf,degP);
end;

function Tmatrix.getSmoothVal(i,j:integer):float;
begin
  case visu.modeMat of
    0,3: result:=data.getE(i,j);
    1: result:=data.getSmoothValA3(i,j);
    2: result:=data.getSmoothValA3bis(i,j);
  end;
end;

function Tmatrix.getSmoothSel(i,j:integer):boolean;
begin
  case visu.modeMat of
    0,3: result:=selPix[i,j];
    1,2: result:=selPix[Istart+(i-Istart) div 3,Jstart+(j-Jstart) div 3 ];
  end;
end;

function Tmatrix.getSmoothMark(i,j:integer):boolean;
begin
  case visu.modeMat of
    0,3: result:=MarkPix[i,j];
    1,2: result:=MarkPix[Istart+(i-Istart) div 3,Jstart+(j-Jstart) div 3 ];
  end;
end;


procedure Tmatrix.setSelPix(i,j:integer;w:boolean);
begin
  if data=nil then exit;
  if not assigned(FselPix) then
  begin
    FselSize:=nbcol*nblig;
    FselPix:=allocmem(FselSize);
  end;

  if FsingleSel and w then clearSelPix;
  FselPix^[i-Istart +nbcol*(j-jstart)]:=w;
end;

function Tmatrix.getSelPix(i,j:integer):boolean;
begin
  result:=assigned(FselPix) and FselPix^[i-Istart +nbcol*(j-jstart)];
end;

procedure Tmatrix.setMarkPix(i,j:integer;w:boolean);
begin
  if data=nil then exit;
  if not assigned(FmarkPix) then
  begin
    FmarkSize:= nbcol*nblig;
    FmarkPix:=allocmem(FmarkSize);
  end;

  if FsingleMark and w then clearMarkPix;
  FmarkPix^[i-Istart +nbcol*(j-jstart)]:=w;
end;

function Tmatrix.getMarkPix(i,j:integer):boolean;
begin
  result:=assigned(FmarkPix) and
          (i>=Istart) and (i<=Iend) and (j>=Jstart) and (j<=Jend) and
          FmarkPix^[i-Istart +nbcol*(j-jstart)];
end;

function Tmatrix.SelPixCount:integer;
var
  i,j:integer;
begin
  result:=0;
  if not assigned(FselPix) then exit;

  for i:=Istart to Iend do
    for j:=Jstart to Jend do
      if selPix[i,j] then inc(result);
end;

function Tmatrix.MarkPixCount:integer;
var
  i,j:integer;
begin
  result:=0;
  if not assigned(FmarkPix) then exit;

  for i:=Istart to Iend do
    for j:=Jstart to Jend do
      if MarkPix[i,j] then inc(result);
end;

procedure Tmatrix.OnselectEvent(x,y:integer);
begin
  with onSelect do
    if valid then pg.executerMatSelect(ad,typeUO(self.MyAd),x,y);
end;

procedure Tmatrix.OnMarkEvent(x,y:integer);
begin
  with onMark do
    if valid then pg.executerMatSelect(ad,typeUO(self.MyAd),x,y);
end;

function Tmatrix.ValueHint(z:TfloatComp):AnsiString;
begin
  if tpNum<G_SingleComp
    then result:=Estr(z.x,3)
    else result:='Re:'+Estr(z.x,3) +crlf+'Im:'+ Estr(z.y,3);
end;

procedure Tmatrix.EditValueDlg(x,y,xp,yp:integer);
var
  z:TfloatComp;
  w:extended;
begin
  if tpNum<G_SingleComp then
  begin
    with matValue do
    begin
      left:=x;
      top:=y-height;

      w:=ZValue[xp,yp];
      caption:=Istr(xp)+'/'+Istr(yp);
      editNum1.setVar(w,t_extended);
    end;
    if matValue.showModal=mrok then
    begin
      updateAllVar(matValue);
      ZValue[xp,yp]:=w;
      invalidate;
    end;
  end
  else
  begin
    with matCpxValue do
    begin
      left:=x;
      top:=y-height;

      z:=CpxValue[xp,yp];
      caption:=Istr(xp)+'/'+Istr(yp);
      enRe.setVar(z.x,t_extended);
      enIm.setVar(z.y,t_extended);
    end;
    if matCpxValue.showModal=mrok then
    begin
      updateAllVar(matValue);
      CpxValue[xp,yp]:=z;
      invalidate;
    end;
  end;
end;

function Tmatrix.MouseDownMG(numOrdre:integer;Irect:Trect;
                    Shift: TShiftState; Xc,Yc,X,Y: Integer):boolean;
var
  xp,yp:integer;
  xpr,ypr:float;
  stHint:AnsiString;
  stUserHint:AnsiString;

begin
  result:=false;

  {messageCentral(rectToString(Irect));}

  if ssCtrl in shift then
    begin
      if numOrdre<>0 then exit;
      xp:= x1act+x;
      yp:= y1act+y;

      if visu.getMatPos(data,@wf,degP,xp,yp) then
        if ssAlt in Shift then EditValueDlg(xc+x,yc+y,xp,yp)
        else
        begin
          stHint:='('+Istr(xp)+','+Istr(yp)+')='+valueHint(Cpxvalue[xp,yp]);
          with onHint do
          if valid then
          begin
            xpr:=x1act+x;
            ypr:=y1act+y;
            visu.getMatPos(data,@wf,degP,xpr,ypr);
            pg.executerMatHint(ad,typeUO(self.MyAd),xpr,ypr,stUserHint);
            stHint:=stHint+crlf+stUserHint;
            {stHint:=stHint+crlf+Estr(xpr,3)+'  '+Estr(ypr,3);  Controle }
          end;

          ShowStmHint(xc+x,yc+y,stHint);
        end;
      exit;
    end;

  if selectMode then
    begin
      if numOrdre<>0 then exit;
      x:=x1act+x;
      y:=y1act+y;

      if visu.getMatPos(data,@wf,degP,x,y) then
        begin
          selPix[x,y]:=not selPix[x,y];
          DinvalidateCell(x,y);

          if FsingleSel then DinvalidateCell(LastSelPix.x,LastSelPix.y);
          LastSelPix:=classes.point(x,y);
          OnSelectEvent(x,y);
        end;
    end
  else
  if MarkMode then
    begin
      if numOrdre<>0 then exit;
      x:=x1act+x;
      y:=y1act+y;

      if visu.getMatPos(data,@wf,degP,x,y) then
        begin
          MarkPix[x,y]:=not MarkPix[x,y];
          DinvalidateCell(x,y);

          if FsingleMark then DinvalidateCell(LastMarkPix.x,LastMarkPix.y);
          LastMarkPix:=classes.point(x,y);
          OnMarkEvent(x,y);
        end;
    end
  else
  result:=inherited mouseDownMG(numOrdre,Irect,Shift,Xc,Yc,X,Y);
end;

function TMatrix.MouseMoveMG(x, y: integer): boolean;
begin
end;

procedure TMatrix.MouseUpMG(x, y: integer; mg: typeUO);
begin
end;


procedure Tmatrix.SelectPixel(sender:Tobject);
begin
  SelectMode:=not SelectMode;
  if selectMode then
  begin
    markMode:=false;
  end;
end;

procedure Tmatrix.MarkPixel(sender:Tobject);
begin
  MarkMode:=not MarkMode;
  if MarkMode then
  begin
    selectMode:=false;
  end;
end;

procedure Tmatrix.getMinMaxI(var Vmin,Vmax:integer);
begin
  if assigned(data) then
  begin
    data.modeCpx:=cpxMode mod 4;
    data.getMinMaxI(Vmin,Vmax);
    data.modeCpx:=0;
  end;
end;

procedure Tmatrix.getMinMax(var Vmin,Vmax:float);
begin
  if assigned(data) then
  begin
    data.modeCpx:=cpxMode mod 4;
    data.getMinMaxE(Vmin,Vmax);
    data.modeCpx:=0;
  end;
end;

procedure Tmatrix.getMinMax(var Vmin,Vmax:float;var Imini,Jmini,Imaxi,Jmaxi:integer);
begin
  if assigned(data) then
  begin
    data.modeCpx:=cpxMode mod 4;
    data.getMinMaxE(Vmin,Vmax,Imini,Jmini,Imaxi,Jmaxi);
    data.modeCpx:=0;
  end;
end;


procedure Tmatrix.getMinMaxWithTH(th1,th2:float;var Vmin,Vmax:float);
begin
  if assigned(data) then
  begin
    data.modeCpx:=cpxMode mod 4;
    data.getMinMaxWithTH(th1,th2,Vmin,Vmax);
    data.modeCpx:=0;
  end;
end;

procedure Tmatrix.setTheta(x:single);
begin
  degP.theta:=x;
end;

procedure Tmatrix.setPalColor(n:integer;x:integer);
begin
  case n of
    1:TmatColor(visu.Color).col1:=x;
    2:TmatColor(visu.Color).col2:=x;
  end;
end;

function Tmatrix.getPalColor(n:integer):integer;
begin
  case n of
    1:result:=TmatColor(visu.Color).col1;
    2:result:=TmatColor(visu.Color).col2;
  end;
end;

function Tmatrix.getRvalue(x,y:float):float;
begin
  result:=Zvalue[invconvx(x),invconvy(y)];
end;


procedure Tmatrix.saveToStream(f:Tstream;Fdata:boolean);
var
  i:integer;
begin
  inherited saveToStream(f,Fdata);

  if Fcontour then Cplot.saveToStream(f,Fdata);
end;

function Tmatrix.loadFromStream(f:Tstream;size:LongWord;Fdata:boolean):boolean;
var
  st1:String[255];
  posf:LongWord;
  posIni:LongWord;
  i:integer;
begin
  result:=inherited loadFromStream(f,size,Fdata);

  if not result or not Fcontour then exit;

  {Si Fcontour, Cplot a été créé par CompleteLoadInfo}
  if f.position>=f.size then exit;

  posIni:=f.position;
  st1:=readHeader(f,size);
  if (st1=TcontourPlot.stmClassName) and
      (Cplot.loadFromStream(f,size,Fdata)) and Cplot.Fchild
    then setChildNames
    else f.Position:=posini;

end;

procedure TMatrix.Show3Dcommands(sender:Tobject);
begin
  if not assigned(Command3D) then createCommand3D;
  if assigned(Command3D) then
    begin
      Command3D.show;
    end;
end;

procedure TMatrix.createCommand3D;
begin
  command3D:=Tmat3Dcom.create(formstm);
  with Tmat3Dcom(command3D) do
  begin
    caption:=ident+': 3D commands';
    init(self);
  end;
end;

procedure Tmatrix.saveData(f:Tstream);
var
  size:integer;
begin
  size:=(Iend-Istart+1)*(Jend-Jstart+1)*tailleTypeG[tpNum];
  writeDataHeader(f,size);
  if data=nil then sortieErreur(E_data);
  data.saveToStream(f);
end;

function Tmatrix.loadData(f:Tstream):boolean;
var
  size:integer;
begin
  result:=readDataHeader(f,size);
  if result=false then exit;

  if size=0 then
    size:=(Iend-Istart+1)*(Jend-Jstart+1)*tailleTypeG[tpNum];
  if size<>(Iend-Istart+1)*(Jend-Jstart+1)*tailleTypeG[tpNum] then exit;

  data.loadFromStream(f);
end;

procedure Tmatrix.saveAsSingle(f:Tstream);
begin
  saveAsSingle1(f,false);
end;

function Tmatrix.loadAsSingle(f:Tstream):boolean;
begin
  loadAsSingle1(f,false);
end;

function TMatrix.loadAsSingle1(f: Tstream; Fbyline: boolean): boolean;
var
  i,j,res:integer;
  x:single;
begin
  if (tb=nil) or (data=nil) then sortieErreur(E_data);

  if ((tpNum=G_single) or (tpNum=G_singleComp)) and not FbyLine then f.Read(tb^,totSize)
  else
  if FbyLine then
  begin
    for j:=Jstart to Jend do
    for i:=Istart to Iend do
      begin
        f.Read(x,4);
        Zvalue[i,j]:=x;
      end;
  end
  else
  begin
    for i:=Istart to Iend do
    for j:=Jstart to Jend do
      begin
        f.Read(x,4);
        Zvalue[i,j]:=x;
      end;
  end;
end;




procedure TMatrix.saveAsSingle1(f: Tstream; Fbyline: boolean);
var
  i,j,res:integer;
  x:single;
begin
  if (tb=nil) or (data=nil) then sortieErreur(E_data);

  if ((tpNum=G_single) or (tpNum=G_singleComp)) and (totsize>0) and not Fbyline then
    f.Write(tb^,totSize)
  else
  if Fbyline then
  begin
    for j:=Jstart to Jend do
    for i:=Istart to Iend do
      begin
        x:=Zvalue[i,j];
        f.Write(x,4);
      end;
  end
  else
  begin
    for i:=Istart to Iend do
    for j:=Jstart to Jend do
      begin
        x:=Zvalue[i,j];
        f.Write(x,4);
      end;
  end;
end;





function Tmatrix.getInfo:AnsiString;
begin
  result:=ident+':T'+stmClassName+CRLF+
          stComment+CRLF+
          'Istart='+Istr(Istart)+CRLF+
          'Iend='+Istr(Iend)+CRLF+
          'Jstart='+Istr(Jstart)+CRLF+
          'Jend='+Istr(Jend)+CRLF+

          'NumType='+TypeNameG[tpNum]+CRLF+
          'Dx='+Estr(dxu,6)+CRLF+
          'X0='+Estr(x0u,6)+CRLF+
          'Dy='+Estr(Dyu,6)+CRLF+
          'Y0='+Estr(Y0u,6)+CRLF+
          'Dz='+Estr(Dzu,6)+CRLF+
          'Z0='+Estr(Z0u,6)+CRLF

          ;
end;

function TMatrix.sum(i1, i2, j1, j2: integer): float;
var
  i,j:integer;
begin
  result:=0;
  for i:=i1 to i2 do
  for j:=j1 to j2 do
    result:=result+data.getE(i,j);
end;

function TMatrix.sumSqrs(i1, i2, j1, j2: integer): float;
var
  i,j:integer;
begin
  result:=0;
  for i:=i1 to i2 do
  for j:=j1 to j2 do
    result:=result+sqr(data.getMdl(i,j));
end;

function TMatrix.sumMdls(i1, i2, j1, j2: integer): float;
var
  i,j:integer;
begin
  result:=0;
  for i:=i1 to i2 do
  for j:=j1 to j2 do
    result:=result+data.getMdl(i,j);
end;


function TMatrix.Mean(i1, i2, j1, j2: integer): float;
var
  i,j:integer;
begin
  result:=0;

  if (i2>=i1) and (j2>=j1) then
  begin
    for i:=i1 to i2 do
    for j:=j1 to j2 do
      result:=result+data.getE(i,j);
    result:=result/(i2-i1+1)/(j2-j1+1);
  end;
end;

function TMatrix.CpxMean(i1, i2, j1, j2: integer): TfloatComp;
var
  i,j:integer;
  nb:integer;
begin
  result.x:=0;
  result.y:=0;

  if (i2>=i1) and (j2>=j1) then
  begin
    for i:=i1 to i2 do
    for j:=j1 to j2 do
    begin
      result.x:=result.x+data.getE(i,j);
      result.y:=result.y+data.getIm(i,j);
    end;

    nb:=(i2-i1+1)*(j2-j1+1);
    result.x:=result.x/nb;
    result.y:=result.y/nb;

  end;
end;


function TMatrix.StdDev(i1, i2, j1, j2: integer): float;
var
  i,j,N:integer;
  m1,m2,sig1,sig2:float;
begin
  result:=0;
  N:=(i2-i1+1)*(j2-j1+1);
  if N<=1 then exit;

  if (i2>=i1) and (j2>=j1) then
  begin
    m1:=0;
    for i:=i1 to i2 do
    for j:=j1 to j2 do
     m1:=m1+data.getE(i,j);
    m1:=m1/N;

    sig1:=0;
    for i:=i1 to i2  do
    for j:=j1 to j2 do
      sig1:=sig1+sqr(data.getE(i,j)-m1);

    m2:=0;
    sig2:=0;
    if isComplex then
    begin
      for i:=i1 to i2 do
      for j:=j1 to j2 do
       m2:=m2+data.getIm(i,j);
      m2:=m2/N;

      for i:=i1 to i2  do
      for j:=j1 to j2 do
        sig2:=sig2+sqr(data.getIm(i,j)-m2);
    end;


    result:=sqrt((sig1+sig2)/(N-1));
  end;
end;

procedure TMatrix.ColtoVec(n: integer; vec: Tvector);
var
  i,sz:integer;
begin
  if (n<Istart) or (n>Iend) then sortieErreur(E_index);

  vec.initTemp1(Jstart,Jend,tpNum);
  vec.dxu:=dyu;
  vec.x0u:=y0u;
  vec.dyu:=dzu;
  vec.x0u:=z0u;

  sz:=tailleTypeG[tpNum];

  with vec do
  begin
    for i:=Istart to Iend do move(self.data.getP(n,i)^,data.getP(i)^,sz);
  end;
end;

procedure TMatrix.LinetoVec(n: integer; vec: Tvector);
var
  i,sz:integer;
begin
  if (n<Jstart) or (n>Jend) then sortieErreur(E_index);

  vec.initTemp1(Istart,Iend,tpNum);
  vec.dxu:=dxu;
  vec.x0u:=x0u;
  vec.dyu:=dzu;
  vec.x0u:=z0u;

  sz:=tailleTypeG[tpNum];

  with vec do
  begin
    for i:=Istart to Iend do move(self.data.getP(i,n)^,data.getP(i)^,sz);
  end;
end;


procedure TMatrix.VecToCol(vec: Tvector; n: integer);
var
  i,sz:integer;
begin
  if (n<Istart) or (n>Iend) then sortieErreur(E_index);
  if vec.Icount<>Jcount
    then sortieErreur('TMatrix.VecToCol : vec and matrix column have different sizes');

  if vec.tpNum=tpNum then
  begin
    sz:=tailleTypeG[tpNum];
    for i:=0 to Jcount-1 do move(vec.getP(vec.Istart+i)^,getP(n,Jstart+i)^,sz);
  end
  else
    for i:=0 to Jcount-1 do cpxValue[n,Jstart+i]:=vec.CpxValue[vec.Istart+i];
end;



procedure TMatrix.VecToLine( vec: Tvector;n: integer);
var
  i,sz:integer;
begin
  if (n<Jstart) or (n>Jend) then sortieErreur(E_index);

  if vec.Icount<>Icount
    then sortieErreur('TMatrix.VecToLine : vec and matrix line have different sizes');

  if (vec.tpNum=tpNum) then
  begin
    sz:=tailleTypeG[tpNum];
    for i:=0 to Icount-1 do
      move(vec.getP(vec.Istart+i)^,getP(Istart+i,n)^,sz);
  end
  else
    for i:=0 to vec.Icount-1 do
      CpxValue[Istart+i,n]:=vec.CpxValue[vec.Istart+i];
end;

(*
procedure Tmatrix.createTexture(d3dDevice:IDIRECT3DDEVICE8;var Texture:IDIRECT3DTEXTURE8);
var
  stream:TmemoryStream;
  bm:TbitmapEx;
begin

  bm:=TbitmapEx.create;
  bm.initRgbDib(Icount,Jcount);
  initGraphic(bm);
  ClearWindow(0);
  displayInside(nil,false,false,false);
  doneGraphic;

  stream:=TmemoryStream.create;
  bm.SaveToStream(stream);
  with stream do
   {D3DXCreateTextureFromFileInMemory(D3DDevice,memory,Size,Texture);}

    D3DXCreateTextureFromFileInMemoryEx(D3DDevice,memory,size,
    0,0,1,0, D3DFMT_UNKNOWN,D3DPOOL_DEFAULT ,D3DX_DEFAULT,D3DX_DEFAULT,

    $FF000000,      {colorKey=black avec alpha=255}
    nil,nil,
    texture);

  stream.Free;
  bm.free;

end;
*)
procedure TMatrix.CopyMat( mat: Tmatrix);
var
  i,j:integer;
begin
  if assigned(mat) and (mat.Istart=Istart) and (mat.Iend=Iend)
                   and (mat.Jstart=Jstart) and (mat.Jend=Jend) then
  begin
    if (mat.tpNum=tpNum) then move(mat.tb^,tb^,totSize)
    else
    for i:=Istart to Iend do
    for j:=Jstart to Jend do
      Zvalue[i,j]:=mat.Zvalue[i,j];
  end;
end;

procedure Tmatrix.Threshold(th:float;Fup,Fdw:boolean);
var
  i,j:integer;
  y:float;
begin
  for i:=Istart to Iend do
  for j:=Jstart to Jend do
  begin
    y:=Zvalue[i,j]-th;
    if Fup and (y>0) then Zvalue[i,j]:=y
    else
    if Fdw and (y<0) then Zvalue[i,j]:=-y
    else Zvalue[i,j]:=0;
  end;
end;

procedure Tmatrix.Threshold1(th:float);
var
  i,j:integer;
  y:float;
begin
  for i:=Istart to Iend do
  for j:=Jstart to Jend do
  begin
    if Zvalue[i,j]>=th
      then Zvalue[i,j]:=1
      else Zvalue[i,j]:=0;
  end;
end;

procedure Tmatrix.Threshold2(th1,th2,val1,val2:float);
var
  i,j:integer;
  y:float;
begin
  for i:=Istart to Iend do
  for j:=Jstart to Jend do
  begin
    y:=Zvalue[i,j];
    if y<th1 then Zvalue[i,j]:=val1
    else
    if y>th2 then Zvalue[i,j]:=val2;
  end;
end;

procedure TMatrix.ClearMarkPix;
begin
  if assigned(FMarkpix) then fillchar(FMarkPix^,nbcol*nblig,0);
end;

procedure TMatrix.ClearSelPix;
begin
  if assigned(Fselpix) then fillchar(FselPix^,nbcol*nblig,0);
end;


function TMatrix.withZ: boolean;
begin
  result:=true;
end;

procedure TMatrix.CenterOfGravity(var xG, yG: float);
var
  i,j:integer;
  m0:float;
begin
  m0:=0;
  xG:=0;
  yG:=0;
  for i:=Istart to Iend do
  for j:=Jstart to Jend do
  begin
    m0:=m0+Zvalue[i,j];
    xG:=xG+convx(i)*Zvalue[i,j];
    yG:=yG+convy(j)*Zvalue[i,j];
  end;
  if m0>0 then
  begin
    xG:=xG/m0;
    yG:=yG/m0;
  end
  else
  begin
    xG:=0;
    yG:=0;
  end;

end;

procedure TMatrix.invalidate;
begin
  inherited;
  if assigned(EditForm)
    then editForm.invalidate;

  if assigned(FRegionList)
    then FRegionList.invalidate;

  if assigned(RegEditor)
    then RegEditor.invalidate;
end;

procedure TMatrix.invalidateData;
begin
  inherited;
  if assigned(EditForm)
    then editForm.invalidate;

  if assigned(FRegionList)
    then FRegionList.invalidate;

  DXgrid.free;
  DXgrid:=nil; 
end;

procedure Tmatrix.MatToDib(var matDib:Tdib;Fraw:boolean);
var
  i,j:integer;
  p:PtabOctet;
  x1,y1,x2,y2:integer;
  w:integer;
  w1,w2:float;
  dpal1:TDpalette;

function getV(i,j:integer):float;
begin
  i:=i+Istart;
  j:=j+Jstart;

  case DisplayMode of
    0: result:=data.getE(i,j);
    1: result:=data.getSmoothValA3(i,j);
    2: result:=data.getSmoothValA3bis(i,j);
  end;
end;

procedure getVCpx(i,j:integer;var x,y:float);
var
  z:TFloatComp;
begin
  i:=i+Istart;
  j:=j+Jstart;

  case DisplayMode of
    0: z:=data.getCpxValA(i,j);
    1: z:=data.getCpxSmoothValA3(i,j);
    2: z:=data.getCpxSmoothValA3bis(i,j);
  end;

  case CpxMode of
    4: begin
         x:=z.x;
         y:=z.y;
       end;
    5: begin
         x:=z.y;
         y:=z.x;
       end;
    6: begin
         x:=mdlCpx(z);
         y:=angleCpx(z);
       end;
    7: begin
         y:=mdlCpx(z);
         x:=angleCpx(z);
       end;
  end;
end;


begin
  if not assigned(matDib) then matDib:=Tdib.Create;

  { Si Fraw, on copie la matrice directement dans un dib de profondeur 8 bits
    La matrice doit contenir des valeurs comprises entre 0 et 255
  }

  if Fraw then
  with matDib do
  begin
    setSize(Icount,Jcount,8);
    for j:=0 to Jcount-1 do
    begin
      p:=scanline[j];
      for i:=0 to Icount-1 do
        p^[i]:= round(Zvalue[Istart+i,Jstart+j]);
    end;
  end

  else
  { Sinon, on crée un dib avec une palette correspondant à l'affichage courant de la matrice.
  }
  begin
    dpal1:=TDpalette.create;
    dpal1.setColors(TmatColor(visu.color).col1,TmatColor(visu.color).col2,TwoCol,0);
    dpal1.setType(palName);
    if Zmin=Zmax
      then dpal1.SetPalette(Zmin,Zmin+1,gamma)
      else dpal1.SetPalette(Zmin,Zmax,gamma);

    TRY
    with matDib do
    begin
      if cpxMode>=4 then
      begin
        dpal1.set2DPalette(visu.FullD2);
        dpal1.setChrominance(visu.Cmin,visu.Cmax,visu.gammaC);
      end;
      colorTable:=dPal1.rgbQuads;
      updatePalette;

      setSize(Icount,Jcount,8);
      x1:=0;
      y1:=0;
      x2:=width-1;
      y2:=height-1;

      if cpxMode<4 then
        begin
          for j:=y1 to y2 do
            begin
              if inverseY
                then p:=scanline[j]
                else p:=scanline[height-1-j];
              for i:=x1 to x2 do
              begin
                w:=Dpal1.colorIndex(getV(i,j));

                if inverseX
                  then p^[width-1-i]:=w
                  else p^[i]:=w;
              end;
            end;
          end
        else
          begin
            for j:=y1 to y2 do
              begin
                if inverseY
                  then p:=scanline[j]
                  else p:=scanline[height-1-j];
                for i:=x1 to x2 do
                begin
                  getVCpx(i,j,w1,w2);
                  w:=Dpal1.colorIndex2D(w1,w2);

                  if inverseX
                    then p^[width-1-i]:=w
                    else p^[i]:=w;
                end;
              end;
          end;
    end;


    FINALLY
    dpal1.Free;
    data.modeCpx:=0;
    END;
  end;
end;


function Tmatrix.DibToMat(matDib:Tdib):boolean;
var
  i,j:integer;
  p:PtabOctet;
begin
  result:=false;
  if not assigned(matDib) then exit;

  with matDib do
  begin
    initTemp(0,width-1,0,height-1,tpNum);

    if bitCount=8 then
    for j:=0 to height-1 do
    begin
      p:=scanline[j];
      for i:=0 to width-1 do
        Kvalue[i,j]:=p^[i];
    end
    else
    for i:=0 to width-1 do
    for j:=0 to height-1 do
       Kvalue[i,j]:=pixels[i,j];

  end;

  result:=true;

end;

function Tmatrix.loadFromBMP(stF:AnsiString):boolean;
var
  dib:Tdib;
begin
  result:=true;
  dib:=Tdib.create;
  try
    dib.LoadFromFile(stF);
    result:=dibToMat(dib);

    keepRatio:=true;
    Dxu:=1;
    Dyu:=1;

    InverseX:=false;
    InverseY:=true;
    dib.Free;
  except
    dib.free;
    result:=false;
  end;
end;

function Tmatrix.saveAsBMP(stF:AnsiString):boolean;
var
  dib:Tdib;
begin
  result:=true;
  dib:=Tdib.create;
  try
    MatToDib(dib,true);
    dib.saveToFile(stF);
    dib.free;
  except
    dib.free;
    result:=false;
  end;
end;


function TMatrix.Cell(i, j: integer): pointer;
begin
  if assigned(data)
    then result:=data.getP(i,j)
    else result:=nil;
end;

procedure TMatrix.transposeM2;
var
  i,j:integer;
  w:float;
  wc:tfloatComp;
begin
  if not isSquare then exit;

  if tpNum<G_singleComp then
    for i:=Istart to Iend do
    for j:=i+1 to Jend do
    begin
      w:=Zvalue[i,j];
      Zvalue[i,j]:=Zvalue[j,i];
      Zvalue[j,i]:=w;
    end
  else
    for i:=Istart to Iend do
    for j:=i+1 to Jend do
    begin
      wc:=Cpxvalue[i,j];
      Cpxvalue[i,j]:=Cpxvalue[j,i];
      Cpxvalue[j,i]:=wc;
    end;
end;

function TMatrix.isSquare: boolean;
begin
  result:= (Istart<>Jstart) or (Iend<>Jend);
end;


function TMatrix.sizeIPP: IPPIsize;
begin
  result.width:=Jcount;
  result.height:=Icount;
end;

function TMatrix.stepIPP: integer;
begin
  result:=Jcount*TailleTypeG[tpNum];
end;

function TMatrix.rectIPP(x1, y1, w1, h1: integer): IPPIrect;
begin
  with result do
  begin
    x:=y1;
    y:=x1;
    width:=h1;
    height:=w1;
  end;
end;

function TMatrix.sizeIPP(n1, n2: integer): IPPIsize;
begin
  with result do
  begin
    width:=n2;
    height:=n1;
  end;
end;

{ contrairement à Tvector, copyDataFrom ajuste les indices
                           pas tpNum

  on peut faire un move pour 2 Tmat ou 2 TmatImage de même tpNum
}
procedure Tmatrix.copyDataFrom(p:typeUO);
var
  i,j:integer;
begin
  if not (p is Tmatrix) then exit;

  MadjustIndex(Tmatrix(p),self);
  if (Tmatrix(p).tpNum=tpNum) and (Tmatrix(p).reverseTemp xor reverseTemp)
    then inherited copyDataFrom(p)
  else
  begin
    for i:=Istart to Iend do
    for j:=Jstart to Jend do
      Zvalue[i,j]:=Tmatrix(p).Zvalue[i,j];

    if isComplex and Tmatrix(p).isComplex then
      for i:=Istart to Iend do
      for j:=Jstart to Jend do
        Imvalue[i,j]:=Tmatrix(p).Imvalue[i,j];
  end;

end;

function Tmatrix.getP(i, j: integer): pointer;
begin
  result:=data.getP(i,j);
end;

function Tmatrix.EltSize: integer;
begin
  result:=TailletypeG[tpNum];
end;

procedure Tmatrix.FileLoadFromMatrix(sender:Tobject);
begin
  LoadFromMatDlg.execution(self);
end;

procedure Tmatrix.FileLoadFromObjFile(sender:Tobject);
var
  objF:TobjectFile;
  ob:Tmatrix;
begin
  objF:=TobjectFile.create;

  try
  with objF do
  begin
    initialise('ObjF');
    command.Caption:='Choose a matrix';
    notPublished:=true;
    ChooseObject(Tmatrix,typeUO(ob));
  end;

  if assigned(ob) then proMcopy(ob,self);

  finally
  objF.free;
  end;
end;

procedure TMatrix.add(src1, src2: Tmatrix);
begin
  proMadd(src1,src2,self);
end;

procedure TMatrix.sub(src1, src2: Tmatrix);
begin
  proMsub(src1,src2,self);
end;

procedure TMatrix.addNum(w:float);
begin
  proMaddNum(self,floatComp(w,0));
end;

procedure TMatrix.MulNum(w:float);
begin
  proMmulNum(self,floatComp(w,0));
end;


procedure Tmatrix.fill(w:float);
begin
  if assigned(data) then
  with inf do data.fill(Imin,Imax,Jmin,Jmax,w);
end;

function TMatrix.loadFromSTK(stF: AnsiString; num: integer):boolean;
var
  stk:TstkFile;
  buf:PtabOctet;
  bufW:PtabWord absolute buf;
  bufSize:integer;
  i:integer;
begin
  buf:=nil;
  stk:=TstkFile.create;
  result:=false;

  try
  stk.Init(stF);
  with stk do
  if (num>=0) and (num<stkCount) then
    begin
      initTemp(0,imagewidth-1,0,imageheight-1,g_single);
      buf:=loadBuffer(num,bufsize);
      case BitsPerSample[0] of
        8  :  if bufSize>=imagewidth*imageheight then
                for i:=0 to imagewidth*imageheight-1 do
                  PtabSingle(tb)^[i]:=buf^[i];
        16 :  if bufSize>=imagewidth*imageheight*2 then
                for i:=0 to imagewidth*imageheight-1 do
                  PtabSingle(tb)^[i]:=bufW^[i];
        24 :  if bufSize>=imagewidth*imageheight*4 then
                for i:=0 to imagewidth*imageheight-1 do
                  PtabSingle(tb)^[i]:=Plongint( @buf^[i*3])^ and $FFFFFF;
      end;
      result:=true;
    end;

  finally
  stk.free;
  freemem(buf);
  end;
end;

procedure TMatrix.setMapScale(Xextent, Yextent, Iorg, Jorg: float);
begin
  if (Xextent<>0) and (Yextent<>0) then
  begin
    dxu:=Xextent/Icount;
    dyu:=Yextent/Jcount;
    x0u:=-Iorg*dxu;
    y0u:=-Jorg*dyu;
  end;
end;


function Tmatrix.getMxArray(Const tpdest0:typetypeG = G_none):MxArrayPtr;
var
  OKmove:boolean;
  complexity:mxComplexity;
  classID:mxClassID;
  t:pointer;
  i,j:integer;
  tpDest:typetypeG;
begin
  result:=nil;
  if not testMatlabMat then exit;
  if not testMatlabMatrix then exit;

  if (Icount<=0) or (Jcount<=0) then
  begin
    sortieErreur('Tmatrix.SaveToMatFile : source is empty');
    exit;
  end;

  if tpDest0=G_none
    then tpDest:=tpNum
    else tpDest:=tpDest0;

  if not (tpDest in MatlabTypes) then
  begin
    sortieErreur('Tmatrix.SaveToMatFile : invalid type');
    exit;
  end;

  classId:=TpNumToClassId(tpDest);
  complexity:=tpNumToComplexity(tpDest);

  OKmove:= inf.temp and (tpNum in [G_byte..G_double]) and (complexity=mxReal) and (tpNum=tpDest);

  result:=mxCreateNumericMatrix(Jcount,Icount,classID,complexity);
  if result=nil then
  begin
    sortieErreur('Tmatrix.SaveToMatFile : error 1');
    exit;
  end;
  t:= mxGetPr(result);
  if t=nil then
  begin
    sortieErreur('Tmatrix.SaveToMatFile : error 2');
    exit;
  end;

  if OKmove then  move(tb^,t^,Icount*Jcount*tailleTypeG[tpNum])
  else
  begin
    case tpDest of
      G_byte:         for i:=0 to Icount-1 do
                      for j:=0 to Jcount-1 do
                        PtabOctet(t)^[j+Jcount*i]:=Kvalue[Istart+i,Jstart+j];
      G_short:        for i:=0 to Icount-1 do
                      for j:=0 to Jcount-1 do
                        PtabShort(t)^[j+Jcount*i]:=Kvalue[Istart+i,Jstart+j];
      G_smallint:     for i:=0 to Icount-1 do
                      for j:=0 to Jcount-1 do
                        PtabEntier(t)^[j+Jcount*i]:=Kvalue[Istart+i,Jstart+j];
      G_word:         for i:=0 to Icount-1 do
                      for j:=0 to Jcount-1 do
                        PtabWord(t)^[j+Jcount*i]:=Kvalue[Istart+i,Jstart+j];
      G_longint:      for i:=0 to Icount-1 do
                      for j:=0 to Jcount-1 do
                        PtabLong(t)^[j+Jcount*i]:=Kvalue[Istart+i,Jstart+j];
      G_single,
      G_singleComp:   for i:=0 to Icount-1 do
                      for j:=0 to Jcount-1 do
                        PtabSingle(t)^[j+Jcount*i]:=Zvalue[Istart+i,Jstart+j];
      G_double,
      G_doubleComp,
      G_real,
      G_extended:     for i:=0 to Icount-1 do
                      for j:=0 to Jcount-1 do
                        PtabDouble(t)^[j+Jcount*i]:=Zvalue[Istart+i,Jstart+j];
    end;

    t:= mxGetPi(result);
    if (complexity=mxComplex) and assigned(t) then
      if tpDest=g_singleComp then
        for i:=0 to Icount-1 do
        for j:=0 to Jcount-1 do
          PtabSingle(t)^[j+Jcount*i]:=Zvalue[Istart+i,Jstart+j]
      else
        for i:=0 to Icount-1 do
        for j:=0 to Jcount-1 do
          PtabDouble(t)^[j+Jcount*i]:=Imvalue[Istart+i,Jstart+j];

  end;
end;

procedure Tmatrix.setMxArray(mxArray:MxArrayPtr;Const invertIndices:boolean=false);
var
  classID:mxClassID;
  isComp:boolean;
  t:pointer;
  tp:typetypeG;
  Nb1,Nb2:integer;
  i,j:integer;
begin
  if not assigned(mxArray) then exit;

  classID:=mxGetClassID(mxArray);
  isComp:= mxIsComplex(mxArray);
  tp:=classIDtoTpNum(classID,isComp);

  if not supportType(tp) then
  case tp of
    g_word: tp:=g_longint;
  end;

  Nb1:=mxgetM(mxArray);
  Nb2:=mxgetN(mxArray);

  t:= mxGetPr(mxArray);

  if assigned(t) and (Nb1>0) and (Nb2>0) then
  begin
    initTemp(Istart,Istart+nb2-1,Jstart,Jstart+nb1-1,tp);
    case classID of
      mxInt8_class:   for i:=0 to Icount-1 do
                      for j:=0 to Jcount-1 do
                        Zvalue[Istart+i,Jstart+j]:=PtabShort(t)^[j+Jcount*i];
      mxUInt8_class:  for i:=0 to Icount-1 do
                      for j:=0 to Jcount-1 do
                        Zvalue[Istart+i,Jstart+j]:=PtabOctet(t)^[j+Jcount*i];

      mxInt16_class:  for i:=0 to Icount-1 do
                      for j:=0 to Jcount-1 do
                        Zvalue[Istart+i,Jstart+j]:=PtabEntier(t)^[j+Jcount*i];
      mxUInt16_class: for i:=0 to Icount-1 do
                      for j:=0 to Jcount-1 do
                        Zvalue[Istart+i,Jstart+j]:=PtabWord(t)^[j+Jcount*i];

      mxInt32_class:  for i:=0 to Icount-1 do
                      for j:=0 to Jcount-1 do
                        Zvalue[Istart+i,Jstart+j]:=PtabLong(t)^[j+Jcount*i];
      mxUInt32_class: for i:=0 to Icount-1 do
                      for j:=0 to Jcount-1 do
                        Zvalue[Istart+i,Jstart+j]:=PtabLongWord(t)^[j+Jcount*i];


      mxsingle_class: for i:=0 to Icount-1 do
                      for j:=0 to Jcount-1 do
                        Zvalue[Istart+i,Jstart+j]:=PtabSingle(t)^[j+Jcount*i];
      mxDouble_class: for i:=0 to Icount-1 do
                      for j:=0 to Jcount-1 do
                        Zvalue[Istart+i,Jstart+j]:=PtabDouble(t)^[j+Jcount*i];
    end;

    t:= mxGetPi(mxArray);
    if assigned(t) and mxIsComplex(mxArray) then
    case classID of
      mxInt8_class:   for i:=0 to Icount-1 do
                      for j:=0 to Jcount-1 do
                        Imvalue[Istart+i,Jstart+j]:=PtabShort(t)^[j+Jcount*i];
      mxUInt8_class:  for i:=0 to Icount-1 do
                      for j:=0 to Jcount-1 do
                        Imvalue[Istart+i,Jstart+j]:=PtabOctet(t)^[j+Jcount*i];

      mxInt16_class:  for i:=0 to Icount-1 do
                      for j:=0 to Jcount-1 do
                        Imvalue[Istart+i,Jstart+j]:=PtabEntier(t)^[j+Jcount*i];
      mxUInt16_class: for i:=0 to Icount-1 do
                      for j:=0 to Jcount-1 do
                        Imvalue[Istart+i,Jstart+j]:=PtabWord(t)^[j+Jcount*i];

      mxInt32_class:  for i:=0 to Icount-1 do
                      for j:=0 to Jcount-1 do
                        Imvalue[Istart+i,Jstart+j]:=PtabLong(t)^[j+Jcount*i];
      mxUInt32_class: for i:=0 to Icount-1 do
                      for j:=0 to Jcount-1 do
                        Imvalue[Istart+i,Jstart+j]:=PtabLongWord(t)^[j+Jcount*i];


      mxsingle_class: for i:=0 to Icount-1 do
                      for j:=0 to Jcount-1 do
                        Imvalue[Istart+i,Jstart+j]:=PtabSingle(t)^[j+Jcount*i];
      mxDouble_class: for i:=0 to Icount-1 do
                      for j:=0 to Jcount-1 do
                        Imvalue[Istart+i,Jstart+j]:=PtabDouble(t)^[j+Jcount*i];
    end;

  end;
end;

function TMatrix.getDeci(i: integer): integer;
begin
  i:=i-Istart;
  if (i>=0) and (i<length(tbDeci))
    then result:=tbDeci[i]
    else result:=3;
end;

procedure TMatrix.setDeci(i, w: integer);
begin
  i:=i-Istart;
  if (i>=0) and (i<length(tbDeci)) then TbDeci[i]:=w;
end;

function TMatrix.ManagedMem: boolean;
begin
  result:=FmanagedMem;
end;


procedure TMatrix.ProcessMessage(id: integer; source: typeUO; p: pointer);
begin
  inherited;

  case id of
    uomsg_invalidateData: if (source=regionList) and assigned(regEditor) and (p<>regEditor)
                            then regEditor.Invalidate;

    UOmsg_FreeDXResources: FreeDXresources;
  end;
end;

function Tmatrix.getOnControl: boolean;
begin
  result:=FonControl;
end;

procedure Tmatrix.setFlagOnControl(v: boolean);
begin
  FonControl:=v;
end;

procedure Tmatrix.SetOnControl(v: boolean);
begin
  FonControl:=v;
  if v then bringToFront;
  inherited;
(*
  if v then
    begin
      FonControl:=v;
      bringToFront;
    end
  else
  if FonControl<>v then
    begin
      FonControl:=v;
      HKpaintPaint;
    end;
*)
end;

function TMatrix.getMainWorld(var x1, y1, x2, y2: float): boolean;
var
  poly: typePoly5R;
  xminA,yminA,xmaxA,ymaxA,dxmax,dymax:float;
  i, di, dj:integer;
  R:float;

  ix1,ix2,iy1,iy2:integer;
  degP1: typeDegre;
  dxC,dyC: float;

begin
  result:= degP.Fuse and  (degP.dx>0) and (degP.dy>0);
  if not result then exit;

  ix1:=invConvX(Xmin);
  ix2:=invConvX(Xmax)-1;
  if ix2<ix1 then ix2:=ix1;
  iy1:=invConvY(Ymin);
  iy2:=invConvY(Ymax)-1;
  if iy2<iy1 then iy2:=iy1;

  degP1.dx:= degP.dx*(ix2-ix1+1)/Icount;
  degP1.dy:= degP.dy*(iy2-iy1+1)/Jcount;

  dxC:=((ix1+ix2+1)-(Istart+Iend+1))/2*degP.dx/Icount;
  dyC:=((iy1+iy2+1)-(Jstart+Jend+1))/2*degP.dy/Jcount;

  degP1.x:= dxC*cos(degP.Theta) - dyC*sin(degP.Theta) + degP.x;
  degP1.y:= dxC*sin(degP.Theta) + dyC*cos(degP.Theta) + degP.y;

  degP1.theta:=degP.theta;

  degToPolyR(degP1,poly);
            
  xminA:= 1E100;
  xmaxA:=-1E100;
  yminA:= 1E100;
  ymaxA:=-1E100;

  for i:=1 to 4 do
  begin
    if poly[i].x < xminA then xminA:=poly[i].x;
    if poly[i].x > xmaxA then xmaxA:=poly[i].x;
    if poly[i].y < yminA then yminA:=poly[i].y;
    if poly[i].y > ymaxA then ymaxA:=poly[i].y;
  end;
  dxmax:=xmaxA-xminA;
  dymax:=ymaxA-yminA;
  di:=x2act-x1act;
  dj:=y2act-y1act;
  if dymax/dxmax>dj/di
    then R:=dymax/dj
    else R:=dxmax/di;

  x1:= degP1.x - di/2*R;
  x2:= degP1.x + di/2*R;
  y1:= degP1.y - dj/2*R;
  y2:= degP1.y + dj/2*R;

end;

procedure TMatrix.Distri(vec: Tvector);
var
  i, j, k: integer;
  y1,x0,dx:float;

const
  epsilon=0;
begin
  x0:=vec.x0u-epsilon;
  dx:=vec.dxu;

  for i:=Istart to Iend do
  for j:=Jstart to Jend do
  begin
    y1:= getE(i,j);
    k:=floor((y1-x0)/dx);
    if (k>=vec.Istart) and (k<=vec.Iend) then vec.data.addE(k,1);
  end;
end;

procedure TMatrix.loadFromText(fileName: Ansistring);
var
  i:integer;
  st:AnsiString;
  pc,c: integer;
  stMot:AnsiString;
  tp:typelexBase;
  error:integer;
  x:float;
  stL: TstringList;
  Nlig,Ncol:integer;

const
  charSep=[#9,';',' ',','];

begin
  if fileName='' then exit;

  stL:=TstringList.create;
  stL.loadFromFile(fileName);

  try
  Nlig:= stL.count;
  Ncol:=0;
  for i:=0 to stL.count-1 do
  begin
    st:= stL[i];

    pc:=0;
    c:=0;
    repeat
      lireUlexBase(st,pc,stMot,tp,x,error,charSep);
      if tp=nombreB then inc(c);
    until (error<>0) or (tp= finB);
    if c>Ncol then Ncol:=c;
  end;

  initTemp(1,Ncol,1,Nlig,tpNum);
  for i:=0 to stL.count-1 do
  begin
    st:= stL[i];

    pc:=0;
    c:=0;
    repeat
      lireUlexBase(st,pc,stMot,tp,x,error,charSep);
      if tp=nombreB then
      begin
        inc(c);
        Zvalue[c,i+1]:=x;
      end;
    until (error<>0) or (tp= finB);
  end;

  finally
  stL.Free;
  end;
end;



procedure TMatrix.saveAsText(fileName: AnsiString; decimalPlaces: integer);
var
  st: string;
  i,j:integer;
  f:text;
begin
  try
  assignFile(f,fileName);
  rewrite(f);
  for j:= Jstart to Jend do
  begin
    st:=Estr(Zvalue[Istart,j],decimalPlaces);
    for i:=Istart+1 to Iend do
      st:= st+#9+Estr(Zvalue[i,j],decimalPlaces);
    writeln(f,st);
  end;

  finally
  closeFile(f);
  end;
end;


function TMatrix.is3D: boolean;
begin
  result:= (inf3D.mode=5);
end;



procedure TMatrix.Circle(xC, yC, Rc, value: float;Ffill:boolean);
var
  dib: Tdib;
  colC:integer;
  i,j:integer;
  p: PtabOctet;
begin
  dib:=Tdib.Create;
  dib.SetSize(Icount,Jcount,8);
  dib.fill(0);

  colC:=255;
  with dib,canvas do
  begin
    pen.color:=rgb(colC,colC,colC);
    if Ffill then
    begin
      brush.style:=bsSolid;
      brush.color:=rgb(colC,colC,colC);
    end
    else brush.style:=bsClear;

    ellipse(self.invconvx(xC-Rc)-self.Istart,self.invconvy(yC-Rc)-self.Jstart,
            self.invconvx(xC+Rc)-self.Istart,self.invconvy(yC+Rc)-self.Jstart);

    for j:=0 to Jcount-1 do
    begin
      p:=scanline[j];
      for i:=0 to Icount-1 do
        if p^[i]<>0 then Zvalue[Istart+i, Jstart+j]:= value;
    end
  end;

  dib.Free;
end;

procedure TMatrix.polygons(plot:TXYplot; val1,val2:float;Ffill:boolean);
var
  dib: Tdib;
  col1,col2:integer;
  i,j:integer;
  p: PtabOctet;
  contour: array of array of Tpoint;
begin
  with plot do
  begin
    setlength(contour, PolylineCount);
    for i:=0 to PolylineCount-1 do
    with Polylines[i] do
    begin
      setLength(contour[i], count);
      for j:=0 to Count-1 do
      begin
        contour[i][j].x:= invconvx( Xvalue[j]);
        contour[i][j].y:= invconvy( Yvalue[j]);
      end;
    end;
  end;

  dib:=Tdib.Create;
  dib.SetSize(Icount,Jcount,8);
  dib.fill(0);

  col1:=255;
  col2:=128;
  with dib,canvas do
  begin
    pen.color:=rgb(col1,col1,col1);
    if Ffill then
    begin
      brush.style:=bsSolid;
      brush.color:=rgb(col2,col2,col2);
    end
    else
    begin
      brush.style:=bsClear;
      if val2>1 then pen.Width:= round(val2);
    end;

    for i:=0 to high(contour) do
      if length(contour[i])>0 then
        if Ffill
          then polygon(contour[i])
          else polyline(contour[i]);

    for j:=0 to Jcount-1 do
    begin
      p:=scanline[j];
      for i:=0 to Icount-1 do
        if p^[i]=255 then Zvalue[Istart+i, Jstart+j]:= val1
        else
        if p^[i]=128 then Zvalue[Istart+i, Jstart+j]:= val2;
    end
  end;

  dib.Free;
end;

(*
procedure TMatrix.Circle(xC, yC, Rc, value: float;Ffill:boolean);
var
  dib: Tdib;
  colC:integer;
begin
  colC:=round(value);

  dib:=Tdib.Create;
  MatToDib(dib,true);
  with dib.canvas do
  begin
    pen.color:=rgb(colC,colC,colC);
    if Ffill then
    begin
      brush.style:=bsSolid;
      brush.color:=rgb(colC,colC,colC);
    end
    else brush.style:=bsClear;

    ellipse(self.invconvx(xC-Rc)-self.Istart,self.invconvy(yC-Rc)-self.Jstart,
            self.invconvx(xC+Rc)-self.Istart,self.invconvy(yC+Rc)-self.Jstart);
  end;
  DibToMat(dib);
  dib.Free;

end;
*)

{***************** Méthodes STM pour Tmatrix *******************************}

procedure proTmatrix_create(name:AnsiString;
                   t:smallint;i1,i2,j1,j2:longint;var pu:typeUO);
  begin
    if not Tmatrix.SupportType(typeTypeG(t))
      then sortieErreur(E_create1);

    if (i1>i2) or (j1>j2) then  sortieErreur(E_create2);

    createPgObject(name,pu,Tmatrix);
    with Tmatrix(pu) do
    begin
      initTemp(i1,i2,j1,j2,TypetypeG(t));
      autoscaleX;
      autoscaleY;
      setChildNames;
    end;
  end;

procedure proTmatrix_create_1(t:smallint;i1,i2,j1,j2:longint;var pu:typeUO);
begin
  proTmatrix_create('',t,i1,i2,j1,j2,pu);
end;

procedure proTmatrix_create_2(var pu:typeUO);
begin
  proTmatrix_create('',ord(g_single),0,0,0,0,pu);
end;


procedure proTmatrix_createImage(name:AnsiString;
                   t:smallint;n1,n2:longint;var pu:typeUO);
begin
  proTmatrix_create(name,t,0,n1-1,0,n2-1, pu);
  Tmatrix(pu).setImageOptions;
end;

procedure proTmatrix_createImage_1(t:smallint;n1,n2:longint;var pu:typeUO);
begin
  proTmatrix_create_1(t,0,n1-1,0,n2-1, pu);
  Tmatrix(pu).setImageOptions;
end;


procedure proTMatrix_Jstart(w:integer;var pu:typeUO);
begin
  verifierObjet(pu);
  Tmatrix(pu).Jstart:=w;
end;

function fonctionTMatrix_Jstart(var pu:typeUO):longint;
  begin
    verifierObjet(pu);
    with Tmatrix(pu) do
    begin
      fonctionTMatrix_Jstart:=inf.Jmin;
    end;
  end;

procedure proTMatrix_Jend(w:integer;var pu:typeUO);
begin
  verifierObjet(pu);
  Tmatrix(pu).Jend:=w;
end;


function fonctionTMatrix_Jend(var pu:typeUO):longint;
  begin
    verifierObjet(pu);
    with Tmatrix(pu) do
    begin
      fonctionTMatrix_Jend:=inf.Jmax;
    end;
  end;

function fonctionTMatrix_Jcount(var pu:typeUO):longint;
  begin
    verifierObjet(pu);
    result:= Tmatrix(pu).Jcount;
  end;


function fonctionTMatrix_Ystart(var pu:typeUO):float;
  begin
    verifierObjet(pu);
    with Tmatrix(pu) do
    begin
      fonctionTMatrix_Ystart:=convy(inf.Jmin);
    end;
  end;

function fonctionTMatrix_Yend(var pu:typeUO):float;
  begin
    verifierObjet(pu);
    with Tmatrix(pu) do
    begin
      fonctionTMatrix_Yend:=convy(inf.Jmax);
    end;
  end;



function fonctionTMatrix_Kvalue(i,j:longint;var pu:typeUO):longint;
  begin
    verifierObjet(pu);
    result:=Tmatrix(pu).Kvalue[i,j];
  end;

procedure proTMatrix_Kvalue(i,j:longint;w:longint;var pu:typeUO);
  begin
    verifierObjet(pu);
    with Tmatrix(pu) do Kvalue[i,j]:=w;
  end;


function fonctionTMatrix_Zvalue(i,j:longint;var pu:typeUO):float;
  begin
    verifierObjet(pu);
    fonctionTMatrix_Zvalue:=Tmatrix(pu).Zvalue[i,j];
  end;

procedure proTMatrix_Zvalue(i,j:longint;w:float;var pu:typeUO);
  begin
    verifierObjet(pu);
    with Tmatrix(pu) do Zvalue[i,j]:=w;
  end;

function fonctionTMatrix_Cpxvalue(i,j:longint;var pu:typeUO):TfloatComp;
begin
  verifierObjet(pu);
  result:=Tmatrix(pu).Cpxvalue[i,j];

end;

procedure proTMatrix_CpxValue(i,j:longint;w:TfloatComp;var pu:typeUO);pascal;
begin
  verifierObjet(pu);
  with Tmatrix(pu) do Cpxvalue[i,j]:=w;
end;

function fonctionTMatrix_Mdlvalue(i,j:longint;var pu:typeUO):float;
  begin
    verifierObjet(pu);
    with Tmatrix(pu).CpxValue[i,j] do
    result:=sqrt(sqr(x)+sqr(y));
  end;



function fonctionTMatrix_Rvalue(x,y:float;var pu:typeUO):float;
  begin
    verifierObjet(pu);
    result:=Tmatrix(pu).Rvalue[x,y];
  end;

procedure proTMatrix_Rvalue(x,y,w:float;var pu:typeUO);
  begin
    verifierObjet(pu);
    with Tmatrix(pu) do Rvalue[x,y]:=w;
  end;


procedure proTMatrix_ImValue(i,j:integer;y:float;var pu:typeUO);
  begin
    verifierObjet(pu);
    with Tmatrix(pu) do ImValue[i,j]:=y;
  end;

function fonctionTmatrix_ImValue(i,j:integer;var pu:typeUO):float;
  begin
    verifierObjet(pu);
    result:=Tmatrix(pu).ImValue[i,j];
  end;


procedure proTmatrix_CpxMode(x:integer;var pu:typeUO);
begin
  verifierObjet(pu);

  if (x>=0) and (x<nbComplexMode)
    then  Tmatrix(pu).CpxMode:=x
    else sortieErreur(E_Cmode);
end;

function fonctionTmatrix_CpxMode(var pu:typeUO):integer;
begin
  verifierObjet(pu);
  result:=Tmatrix(pu).visu.CpxMode;
end;



procedure proTmatrix_Dz(x:float;var pu:typeUO);
  begin
    verifierObjet(pu);
    if x=0 then sortieErreur(E_parametre);
    Tmatrix(pu).setDz(x);
  end;

function fonctionTmatrix_Dz(var pu:typeUO):float;
  begin
    verifierObjet(pu);
    fonctionTmatrix_Dz:=Tmatrix(pu).Dzu;
  end;

procedure proTmatrix_Z0(x:float;var pu:typeUO);
  begin
    verifierObjet(pu);
    Tmatrix(pu).setZ0(x);
  end;

function fonctionTmatrix_Z0(var pu:typeUO):float;
  begin
    verifierObjet(pu);
    fonctionTmatrix_z0:=Tmatrix(pu).Z0u;
  end;


function FonctionTmatrix_convZ(i:longint;var pu:typeUO):float;
  begin
    verifierObjet(pu);
    fonctionTmatrix_convZ:=Tmatrix(pu).convZ(i);
  end;

function FonctionTmatrix_invconvZ(x:float;var pu:typeUO):longint;
  begin
    verifierObjet(pu);
    fonctionTmatrix_invconvZ:=Tmatrix(pu).invconvZ(x);
  end;


procedure proTMatrix_getMinMaxI(var Vmin,Vmax:longint;var pu:typeUO);
  begin
    verifierObjet(pu);
    Tmatrix(pu).getMinMaxI(Vmin,Vmax);
  end;

procedure proTMatrix_getMinMax(var Vmin,Vmax:float;var pu:typeUO);
  begin
    verifierObjet(pu);
    Tmatrix(pu).getMinMax(Vmin,Vmax);
  end;

procedure proTMatrix_getMinMax_1(var Vmin,Vmax:float;var Imini,Jmini,Imaxi,Jmaxi:integer;var pu:typeUO);
  begin
    verifierObjet(pu);
    Tmatrix(pu).getMinMax(Vmin,Vmax,Imini,Jmini,Imaxi,Jmaxi);
  end;

procedure proTmatrix_getMinMaxWithTH(th1,th2:float;var Vmin,Vmax:float;var pu:typeUO);
  begin
    verifierObjet(pu);
    Tmatrix(pu).getMinMaxWithTH(th1,th2,Vmin,Vmax);
  end;


function fonctionTmatrix_Zmin(var pu:typeUO):float;
  begin
    verifierObjet(pu);
    fonctionTmatrix_Zmin:=Tmatrix(pu).visu.Zmin;
  end;

procedure proTmatrix_Zmin(x:float;var pu:typeUO);
  begin
    verifierObjet(pu);
    with Tmatrix(pu) do
    begin
      visu.Zmin:=x;
      if (cpz<>0) then
        begin
          messageCpz;
          messageToRef(UOmsg_invalidate,nil);
        end;
    end;
  end;

function fonctionTmatrix_Zmax(var pu:typeUO):float;
  begin
    verifierObjet(pu);
    fonctionTmatrix_Zmax:=Tmatrix(pu).visu.Zmax;
  end;

procedure proTmatrix_Zmax(x:float;var pu:typeUO);
  begin
    verifierObjet(pu);
    with Tmatrix(pu) do
    begin
      visu.Zmax:=x;
      if (cpz<>0) then
        begin
          messageCpz;
          messageToRef(UOmsg_invalidate,nil);
        end;
    end;
  end;




function fonctionTmatrix_theta(var pu:typeUO):float;
  begin
    verifierObjet(pu);
    fonctionTmatrix_theta:=Tmatrix(pu).theta;
  end;

procedure proTmatrix_theta(x:float;var pu:typeUO);
  begin
    verifierObjet(pu);
    Tmatrix(pu).theta:=x;
  end;

function fonctionTmatrix_LogZ(var pu:typeUO): boolean;
begin
  verifierObjet(pu);
  result:=Tmatrix(pu).modeLogZ;
end;

procedure proTmatrix_LogZ(w: boolean;var pu:typeUO);
begin
  verifierObjet(pu);
  Tmatrix(pu).modeLogZ:= w;
end;

function fonctionTmatrix_AspectRatio(var pu:typeUO):float;
  begin
    verifierObjet(pu);
    fonctionTmatrix_AspectRatio:=Tmatrix(pu).AspectRatio;
  end;

procedure proTmatrix_AspectRatio(x:float;var pu:typeUO);
  begin
    verifierObjet(pu);
    if x<=0 then sortieErreur(E_aspectRatio);
    Tmatrix(pu).AspectRatio:=x;
  end;

function fonctionTmatrix_PixelRatio(var pu:typeUO):float;
  begin
    verifierObjet(pu);
    result:=Tmatrix(pu).PixelRatio;
  end;

procedure proTmatrix_PixelRatio(x:float;var pu:typeUO);
  begin
    verifierObjet(pu);
    if x<=0 then sortieErreur(E_aspectRatio);
    Tmatrix(pu).PixelRatio:=x;
  end;


function fonctionTmatrix_gamma(var pu:typeUO):float;
  begin
    verifierObjet(pu);
    fonctionTmatrix_gamma:=Tmatrix(pu).gamma;
  end;

procedure proTmatrix_gamma(x:float;var pu:typeUO);
  begin
    verifierObjet(pu);
    Tmatrix(pu).gamma:=x;
  end;

function fonctionTmatrix_TwoColors(var pu:typeUO):boolean;
  begin
    verifierObjet(pu);
    fonctionTmatrix_TwoColors:=Tmatrix(pu).TwoCol;
  end;

procedure proTmatrix_TwoColors(x:boolean;var pu:typeUO);
  begin
    verifierObjet(pu);
    Tmatrix(pu).TwoCol:=x;
  end;

function fonctionTmatrix_PalColor(n:smallint;var pu:typeUO):smallInt;
  begin
    verifierObjet(pu);
    controleParametre(n,1,2);
    result:=Tmatrix(pu).PalColor[n];
  end;

procedure proTmatrix_PalColor(n:smallint;x:smallInt;var pu:typeUO);
  begin
    verifierObjet(pu);
    controleParametre(n,1,2);
    Tmatrix(pu).PalColor[n]:=x;
  end;

procedure proTmatrix_AutoscaleZ(var pu:typeUO);
begin
  verifierObjet(pu);
  with Tmatrix(pu) do
  begin
    autoScaleZ;
    if (cpz<>0) then  messageCpz;
  end;
end;

procedure proTmatrix_AutoscaleXYZ(var pu:typeUO);
begin
  verifierObjet(pu);
  with Tmatrix(pu) do
  begin
    autoscaleX;
    autoscaleY;
    autoScaleZ;
    if (cpx<>0) then  messageCpx;
    if (cpy<>0) then  messageCpy;
    if (cpz<>0) then  messageCpz;
  end;
end;


procedure proTmatrix_AutoscaleZsym(var pu:typeUO);
begin
  verifierObjet(pu);
  with Tmatrix(pu) do
  begin
    autoScaleZsym;
    if (cpz<>0) then  messageCpz;
  end;
end;

procedure proTmatrix_AutoscaleZmax(Vmin:float;var pu:typeUO);
begin
  verifierObjet(pu);
  with Tmatrix(pu) do
  begin
    autoScaleZmax(Vmin);
    if (cpz<>0) then  messageCpz;
  end;
end;

procedure proTmatrix_modify(t:integer;i1,i2,j1,j2:longint;var pu:typeUO);
  begin
    verifierObjet(pu);
    if not Tmatrix.SupportType(typeTypeG(t))
      then sortieErreur(E_modify1);
    if (i1>i2) or (j1>j2) then  sortieErreur(E_indexOrder);

    with Tmatrix(pu) do modify(typetypeG(t),i1,j1,i2,j2);
  end;

procedure proTmatrix_setPosition(x,y,dx,dy,theta1:float;var pu:typeUO);
  begin
    verifierObjet(pu);
    with Tmatrix(pu) do
    begin
      degP.x:=x;
      degP.y:=y;
      degP.dx:=dx;
      degP.dy:=dy;
      degP.theta:=theta1;
      degP.Fuse:=true;
    end;
  end;

procedure proTmatrix_UsePosition(b:boolean;var pu:typeUO);
begin
  verifierObjet(pu);
  Tmatrix(pu).degP.Fuse:=b;
end;

function fonctionTmatrix_UsePosition(var pu:typeUO):boolean;
begin
  verifierObjet(pu);
  result:= Tmatrix(pu).degP.Fuse;
end;


procedure proTmatrix_onControl(b:boolean;var pu:typeUO);
  begin
    verifierObjet(pu);
    pu.onControl:=b;
  end;

function fonctionTmatrix_onControl(var pu:typeUO):boolean;
  begin
    verifierObjet(pu);
    fonctionTmatrix_onControl:=pu.onControl;
  end;

procedure proTmatrix_fill(x:float;var pu:typeUO);
  begin
    verifierObjet(pu);
    with Tmatrix(pu),inf do data.fill(Imin,Imax,Jmin,Jmax,x);
  end;

procedure proTmatrix_inc(x,y:integer;var pu:typeUO);
  begin
    verifierObjet(pu);
    with Tmatrix(pu) do data.addI(x,y,1);
  end;

procedure proTmatrix_dec(x,y:integer;var pu:typeUO);
  begin
    verifierObjet(pu);
    with Tmatrix(pu) do data.addI(x,y,-1);
  end;



function fonctionTmatrix_ConnectedPixels(seuil1,seuil2:float;var pu:typeUO):integer;
begin
  verifierObjet(pu);
  with Tmatrix(pu) do
    result:=connectedPixels(seuil1,seuil2);
end;

procedure proTmatrix_BuildCnxMap(seuil:float;var pu:typeUO);
begin
  verifierObjet(pu);
  with Tmatrix(pu) do
    BuildCnxMap(seuil,0,0);
end;

procedure proTmatrix_BuildCnxMap_1(seuil:float;mode:integer;var pu:typeUO);
begin
  verifierObjet(pu);
  with Tmatrix(pu) do
    if mode=0
      then BuildCnxMap(seuil,0,0)
      else BuildCnxMap(seuil,3,0);
end;

procedure proTmatrix_AgFilter_1(seuil:float;nbAg:integer;AbsMode:boolean; var pu:typeUO);
begin
  verifierObjet(pu);
  with Tmatrix(pu) do
  if nbAg>0
    then BuildCnxMap(seuil,1,NbAg,AbsMode)
    else BuildCnxMap(seuil,2,0,AbsMode);
end;


procedure proTmatrix_AgFilter(seuil:float;nbAg:integer; var pu:typeUO);
begin
  proTmatrix_AgFilter_1(seuil,nbAg,false, pu);
end;



procedure proTmatrix_DisplayMode(x:smallint;var pu:typeUO);
begin
  verifierObjet(pu);
  controleParam(x,0,2,E_displayMode);
  Tmatrix(pu).DisplayMode:=x;
end;

function fonctionTmatrix_DisplayMode(var pu:typeUO):smallint;
begin
  verifierObjet(pu);
  result:=Tmatrix(pu).DisplayMode;
end;

procedure proTmatrix_PalName(x:AnsiString;var pu:typeUO);
begin
  verifierObjet(pu);
  Tmatrix(pu).PalName:=x;
end;

function fonctionTmatrix_PalName(var pu:typeUO):AnsiString;
begin
  verifierObjet(pu);
  result:=Tmatrix(pu).PalName;
end;


procedure proTmatrix_UseWF(x:boolean;var pu:typeUO);
  begin
    verifierObjet(pu);
    Tmatrix(pu).wf.active:=x;
  end;

function fonctionTmatrix_UseWF(var pu:typeUO):boolean;
  begin
    verifierObjet(pu);
    result:=Tmatrix(pu).wf.active;
  end;

procedure proTmatrix_dxWF(x:float;var pu:typeUO);
  begin
    verifierObjet(pu);
    Tmatrix(pu).wf.dxAff:=x;
  end;

function fonctionTmatrix_dxWF(var pu:typeUO):float;
  begin
    verifierObjet(pu);
    result:=Tmatrix(pu).wf.dxAff;
  end;

procedure proTmatrix_dyWF(x:float;var pu:typeUO);
  begin
    verifierObjet(pu);
    Tmatrix(pu).wf.dyAff:=x;
  end;

function fonctionTmatrix_dyWF(var pu:typeUO):float;
  begin
    verifierObjet(pu);
    result:=Tmatrix(pu).wf.dyAff;
  end;

procedure proTmatrix_Mleft(x:float;var pu:typeUO);
  begin
    verifierObjet(pu);
    Tmatrix(pu).wf.Mleft:=x;
  end;

function fonctionTmatrix_Mleft(var pu:typeUO):float;
  begin
    verifierObjet(pu);
    result:=Tmatrix(pu).wf.Mleft;
  end;

procedure proTmatrix_Mtop(x:float;var pu:typeUO);
  begin
    verifierObjet(pu);
    Tmatrix(pu).wf.Mtop:=x;
  end;

function fonctionTmatrix_Mtop(var pu:typeUO):float;
  begin
    verifierObjet(pu);
    result:=Tmatrix(pu).wf.Mtop;
  end;

procedure proTmatrix_Mright(x:float;var pu:typeUO);
  begin
    verifierObjet(pu);
    Tmatrix(pu).wf.Mright:=x;
  end;

function fonctionTmatrix_Mright(var pu:typeUO):float;
  begin
    verifierObjet(pu);
    result:=Tmatrix(pu).wf.Mright;
  end;

procedure proTmatrix_Mbottom(x:float;var pu:typeUO);
  begin
    verifierObjet(pu);
    Tmatrix(pu).wf.Mbottom:=x;
  end;

function fonctionTmatrix_Mbottom(var pu:typeUO):float;
  begin
    verifierObjet(pu);
    result:=Tmatrix(pu).wf.Mbottom;
  end;


procedure proTmatrix_SelPix(i,j:integer;w:boolean;var pu:typeUO);
begin
  verifierObjet(pu);

  with Tmatrix(pu) do
  begin
    verifierIndices(i,j);
    selPix[i,j]:=w;
    LastSelPix:=classes.point(i,j);
  end;
end;

function fonctionTmatrix_SelPix(i,j:integer;var pu:typeUO):boolean;
begin
  verifierObjet(pu);
  with Tmatrix(pu) do
  begin
    verifierIndices(i,j);
    result:=selPix[i,j];
  end;
end;

procedure proTmatrix_SelColor(w:integer;var pu:typeUO);
begin
  verifierObjet(pu);

  with Tmatrix(pu) do selectColor:=w;
end;

function fonctionTmatrix_SelColor(var pu:typeUO):integer;
begin
  verifierObjet(pu);
  with Tmatrix(pu) do result:=selectColor;
end;

procedure proTmatrix_markPix(i,j:integer;w:boolean;var pu:typeUO);
begin
  verifierObjet(pu);

  with Tmatrix(pu) do
  begin
    verifierIndices(i,j);
    markPix[i,j]:=w;
    LastMarkPix:=classes.point(i,j);
  end;
end;

function fonctionTmatrix_markPix(i,j:integer;var pu:typeUO):boolean;
begin
  verifierObjet(pu);
  with Tmatrix(pu) do
  begin
    verifierIndices(i,j);
    result:=markPix[i,j];
  end;
end;

procedure proTmatrix_markColor(w:integer;var pu:typeUO);
begin
  verifierObjet(pu);

  with Tmatrix(pu) do markColor:=w;
end;

function fonctionTmatrix_markColor(var pu:typeUO):integer;
begin
  verifierObjet(pu);
  with Tmatrix(pu) do result:=markColor;
end;

function fonctionTmatrix_Contour(var pu:typeUO):pointer;
begin
  verifierObjet(pu);
  with Tmatrix(pu) do
  begin
    if not assigned(Cplot) then
      begin
        createCplot;
        setChildNames;
      end;
    result:=@Cplot;
  end;
end;

procedure proTMatrix_CenterOfGravity(var xG, yG: float;var pu:typeUO);
begin
  verifierObjet(pu);
  with Tmatrix(pu) do CenterOfGravity(xG, yG);
end;


{********************** Opérations sur matrices ***************************}

procedure extentDest(source,dest:Tmatrix);
begin
  if not dest.Flags.Findex or dest.inf.readOnly then exit;

  if (source.Inf.Imin<>dest.inf.Imin) or (source.Inf.Imax<>dest.inf.Imax)
     OR
     (source.Inf.Jmin<>dest.inf.Jmin) or (source.Inf.Jmax<>dest.inf.Jmax)
    then dest.initTemp(source.inf.Imin,source.Inf.Imax,
                       source.inf.Jmin,source.Inf.Jmax,
                       dest.inf.tpNum);
end;

procedure controleSourceDest(var source,dest:Tmatrix);
  begin
    verifierObjet(typeUO(source));
    verifierObjet(typeUO(dest));

    extentDest(source,dest);

    dest.dxu:=source.dxu;
    dest.x0u:=source.x0u;
    dest.dyu:=source.dyu;
    dest.y0u:=source.y0u;
    dest.dzu:=source.dzu;
    dest.z0u:=source.z0u;
  end;

procedure IntervalleCommun(m1,m2:Tmatrix;var x1,x2,y1,y2:integer);
begin
  if m1.data.imin>m2.data.imin
    then x1:=m1.data.imin
    else x1:=m2.data.imin;
  if m1.data.imax<m2.data.imax
    then x2:=m1.data.imax
    else x2:=m2.data.imax;

  if m1.data.jmin>m2.data.jmin
    then y1:=m1.data.jmin
    else y1:=m2.data.jmin;
  if m1.data.jmax<m2.data.jmax
    then y2:=m1.data.jmax
    else y2:=m2.data.jmax;
end;


procedure proAddMatrix(var m,m1,m2:Tmatrix);
  var
    i,j,i1,i2,j1,j2:integer;
  begin
    controleSourceDest(m1,m);
    verifierObjet(typeUO(m2));
    intervalleCommun(m1,m2,i1,i2,j1,j2);

    if (m.tpNum<G_singleComp) and (m1.tpNum<G_singleComp) and (m2.tpNum<G_singleComp) then
    with m do
    for i:=i1 to i2 do
      for j:=j1 to j2 do
        data.setE(i,j,m1.data.getE(i,j)+m2.data.getE(i,j) )

    else
    with m do
    for i:=i1 to i2 do
      for j:=j1 to j2 do
        data.setCpx(i,j,sumCpx(m1.data.getCpx(i,j),m2.data.getCpx(i,j)) );

  end;


procedure proSubMatrix(var m,m1,m2:Tmatrix);
  var
    i,j,i1,i2,j1,j2:integer;
  begin
    controleSourceDest(m1,m);
    verifierObjet(typeUO(m2));
    intervalleCommun(m1,m2,i1,i2,j1,j2);

    if (m.tpNum<G_singleComp) and (m1.tpNum<G_singleComp) and (m2.tpNum<G_singleComp) then
    with m do
    for i:=i1 to i2 do
      for j:=j1 to j2 do
        data.setE(i,j,m1.data.getE(i,j)-m2.data.getE(i,j) )

    else
    with m do
    for i:=i1 to i2 do
      for j:=j1 to j2 do
        data.setCpx(i,j,DiffCpx(m1.data.getCpx(i,j),m2.data.getCpx(i,j)) );
  end;

procedure proMultiplyMatrix(var m,m1,m2:Tmatrix);
  var
    i,j,i1,i2,j1,j2:integer;
  begin
    controleSourceDest(m1,m);
    verifierObjet(typeUO(m2));
    intervalleCommun(m1,m2,i1,i2,j1,j2);

    with m do
    for i:=i1 to i2 do
      for j:=j1 to j2 do
        data.setE(i,j,m1.data.getE(i,j)*m2.data.getE(i,j) );

    if (m.tpNum<G_singleComp) and (m1.tpNum<G_singleComp) and (m2.tpNum<G_singleComp) then
    with m do
    for i:=i1 to i2 do
      for j:=j1 to j2 do
        data.setE(i,j,m1.data.getE(i,j)*m2.data.getE(i,j) )

    else
    with m do
    for i:=i1 to i2 do
      for j:=j1 to j2 do
        data.setCpx(i,j,ProdCpx(m1.data.getCpx(i,j),m2.data.getCpx(i,j)) );

  end;

procedure proDivideMatrix(var m,m1,m2:Tmatrix);
  var
    i,j,i1,i2,j1,j2:integer;
    w:float;
  begin
    controleSourceDest(m1,m);
    verifierObjet(typeUO(m2));
    intervalleCommun(m1,m2,i1,i2,j1,j2);

    with m do
    for i:=i1 to i2 do
      for j:=j1 to j2 do
        begin
          w:=m2.data.getE(i,j);
          if w<>0
            then data.setE(i,j,m1.data.getE(i,j)/w )
            else data.setE(i,j,0 );
        end;
  end;

procedure proIncrementMatrix(var m,m1:Tmatrix;x:float);
  var
    i,j:longint;
  begin
    controleSourceDest(m1,m);

    with m do
    begin
      for i:=inf.Imin to inf.Imax do
        for j:=inf.Jmin to inf.Jmax do
          data.setE(i,j,m1.data.getE(i,j)+x );
    end;
  end;

procedure proKmultiplyMatrix(var m,m1:Tmatrix;x:float);
  var
    i,j:longint;
  begin
    controleSourceDest(m1,m);

    if (m.tpNum<G_singleComp) and (m1.tpNum<G_singleComp) then
    with m do
    for i:=inf.Imin to inf.Imax do
      for j:=inf.Jmin to inf.Jmax do
        data.setE(i,j,m1.data.getE(i,j)*x )

    else
    with m do
    for i:=inf.Imin to inf.Imax do
      for j:=inf.Jmin to inf.Jmax do
        data.setCpx(i,j,ProdCpx(m.data.getCpx(i,j),FloatToCpx(x) ));

  end;

procedure proZscoreMap(var src,dest:Tmatrix;Vmoy,Vsig,Zseuil:float;Fabove,Fzero:boolean);
  var
    i,j:integer;
    seuil1,seuil2,z:float;
  begin
    controleSourceDest(src,dest);

    Vsig:=abs(Vsig);
    Zseuil:=abs(Zseuil);
    if Vsig=0 then exit;

    if Fabove
      then seuil1:=-1E100
      else seuil1:=Vmoy-Vsig*Zseuil;

    seuil2:=Vmoy+Vsig*Zseuil;

    with dest do
    begin
      for i:=inf.Imin to inf.Imax do
        for j:=inf.Jmin to inf.Jmax do
          begin
            z:=src.data.getE(i,j);
            if (z<=seuil1) or (z>=seuil2) then
              begin
                z:=(z-Vmoy)/Vsig;
                if Fzero then
                  begin
                    if z>0
                      then z:=z-Zseuil
                      else z:=z+Zseuil;
                  end;
              end
            else z:=0;
            setE(i,j,z);
          end;
    end;
  end;



function fonctionTmatrix_D3_D0(var pu:typeUO):float;
begin
  verifierObjet(pu);
  with Tmatrix(pu) do result:=inf3D.D0;
end;

procedure proTmatrix_D3_D0(x:float;var pu:typeUO);
begin
  verifierObjet(pu);
  with Tmatrix(pu) do inf3D.D0:=x;
end;


function fonctionTmatrix_D3_FOV(var pu:typeUO):float;
begin
  verifierObjet(pu);
  with Tmatrix(pu) do result:=inf3D.FOV;
end;

procedure proTmatrix_D3_FOV(x:float;var pu:typeUO);
begin
  verifierObjet(pu);
  with Tmatrix(pu) do inf3D.FOV:=x;
end;


function fonctionTmatrix_D3_ThetaX(var pu:typeUO):float;pascal;
begin
  verifierObjet(pu);
  with Tmatrix(pu) do result:=inf3D.thetaX;
end;

procedure proTmatrix_D3_ThetaX(x:float;var pu:typeUO);
begin
  verifierObjet(pu);
  with Tmatrix(pu) do inf3D.thetaX:=x;
end;


function fonctionTmatrix_D3_ThetaY(var pu:typeUO):float;
begin
  verifierObjet(pu);
  with Tmatrix(pu) do result:=inf3D.thetaY;
end;

procedure proTmatrix_D3_ThetaY(x:float;var pu:typeUO);
begin
  verifierObjet(pu);
  with Tmatrix(pu) do inf3D.thetaY:=x;
end;


function fonctionTmatrix_D3_ThetaZ(var pu:typeUO):float;
begin
  verifierObjet(pu);
  with Tmatrix(pu) do result:=inf3D.thetaZ;
end;

procedure proTmatrix_D3_ThetaZ(x:float;var pu:typeUO);
begin
  verifierObjet(pu);
  with Tmatrix(pu) do inf3D.thetaZ:=x;
end;


function fonctionTmatrix_D3_mode(var pu:typeUO):integer;
begin
  verifierObjet(pu);
  with Tmatrix(pu) do result:=inf3D.mode;
end;

procedure proTmatrix_D3_mode(x:integer;var pu:typeUO);
begin
  verifierObjet(pu);
  with Tmatrix(pu) do inf3D.mode:=x;
end;

function fonctionTmatrix_sum_1(i1,i2,j1,j2:integer;var pu:typeUO):float;
begin
  verifierObjet(pu);
  with Tmatrix(pu) do
  begin
    if (i1<Istart) or (i1>i2) or (i2>Iend) or
       (j1<Jstart) or (j1>j2) or (j2>Jend)
      then sortieErreur(E_index);
    result:=sum(i1,i2,j1,j2);
  end;
end;

function fonctionTmatrix_Sum(var pu:typeUO):float;
begin
  verifierObjet(pu);
  with Tmatrix(pu) do
    result:= sum(istart,iend,jstart,jend);
end;


function fonctionTmatrix_SqrSum_1(i1,i2,j1,j2:integer;var pu:typeUO):float;
begin
  verifierObjet(pu);
  with Tmatrix(pu) do
  begin
    if (i1<Istart) or (i1>i2) or (i2>Iend) or
       (j1<Jstart) or (j1>j2) or (j2>Jend)
      then sortieErreur(E_index);
    result:=sumSqrs(i1,i2,j1,j2);
  end;
end;

function fonctionTmatrix_SqrSum(var pu:typeUO):float;
begin
  verifierObjet(pu);
  with Tmatrix(pu) do
    result:= SumSqrs(istart,iend,jstart,jend);
end;

function fonctionTmatrix_sumMdls(i1,i2,j1,j2:integer;var pu:typeUO):float;
begin
  verifierObjet(pu);
  with Tmatrix(pu) do
  begin
    if (i1<Istart) or (i1>i2) or (i2>Iend) or
       (j1<Jstart) or (j1>j2) or (j2>Jend)
      then sortieErreur(E_index);
    result:=sumMdls(i1,i2,j1,j2);
  end;
end;

function fonctionTmatrix_mean(var pu:typeUO):float;
begin
  verifierObjet(pu);
  with Tmatrix(pu) do
  begin
    result:=mean(Istart,Iend,Jstart,Jend);
  end;
end;

function fonctionTmatrix_mean_1(i1,i2,j1,j2:integer;var pu:typeUO):float;
begin
  verifierObjet(pu);
  with Tmatrix(pu) do
  begin
    if (i1<Istart) or (i1>i2) or (i2>Iend) or
       (j1<Jstart) or (j1>j2) or (j2>Jend)
      then sortieErreur(E_index);
    result:=mean(i1,i2,j1,j2);
  end;
end;

function fonctionTmatrix_cpxmean(var pu:typeUO):TfloatComp;
begin
  verifierObjet(pu);
  with Tmatrix(pu) do
  begin
    result:=cpxmean(Istart,Iend,Jstart,Jend);
  end;
end;

function fonctionTmatrix_cpxmean_1(i1,i2,j1,j2:integer;var pu:typeUO):Tfloatcomp;
begin
  verifierObjet(pu);
  with Tmatrix(pu) do
  begin
    if (i1<Istart) or (i1>i2) or (i2>Iend) or
       (j1<Jstart) or (j1>j2) or (j2>Jend)
      then sortieErreur(E_index);
    result:=cpxmean(i1,i2,j1,j2);
  end;
end;


function fonctionTmatrix_StdDev(var pu:typeUO):float;
begin
  verifierObjet(pu);
  with Tmatrix(pu) do
  begin
    result:=stdDev(Istart,Iend,Jstart,Jend);
  end;
end;

function fonctionTmatrix_StdDev_1(i1,i2,j1,j2:integer;var pu:typeUO):float;
begin
  verifierObjet(pu);
  with Tmatrix(pu) do
  begin
    if (i1<Istart) or (i1>i2) or (i2>Iend) or
       (j1<Jstart) or (j1>j2) or (j2>Jend)
      then sortieErreur(E_index);
    result:=stdDev(i1,i2,j1,j2);
  end;
end;

function fonctionTmatrix_mean0(var pu:typeUO):float;
begin
  verifierObjet(pu);
  with Tmatrix(pu) do
    result:=mean(istart,iend,jstart,jend);
end;

function fonctionTmatrix_StdDev0(var pu:typeUO):float;
begin
  verifierObjet(pu);
  with Tmatrix(pu) do
    result:=stdDev(istart,iend,jstart,jend);
end;

function fonctionTmatrix_sum0(var pu:typeUO):float;pascal;
begin
  verifierObjet(pu);
  with Tmatrix(pu) do
    result:=sum(istart,iend,jstart,jend);
end;


procedure proTMatrix_VecToLine(var vec: Tvector;n:integer;var pu:typeUO);
begin
  verifierVecteur(vec);
  verifierObjet(pu);
  with Tmatrix(pu) do
  begin
    
    vecToLine(vec,n);
  end;
end;

procedure proTMatrix_VecToCol( var vec: Tvector;n: integer;var pu:typeUO);
begin
  verifierVecteur(vec);
  verifierObjet(pu);
  with Tmatrix(pu) do
  begin
    
    vecToCol(vec,n);
  end;
end;

procedure proTMatrix_LineToVec(n: integer; var vec: Tvector;var pu:typeUO);
begin
  verifierVecteurTemp(vec);
  verifierObjet(pu);
  with Tmatrix(pu) do
  begin
    
    LineToVec(n,vec);
  end;
end;

procedure proTMatrix_ColToVec(n: integer; var vec: Tvector;var pu:typeUO);
begin
  verifierVecteurTemp(vec);
  verifierObjet(pu);
  with Tmatrix(pu) do
  begin

    ColToVec(n,vec);
  end;
end;

procedure proTMatrix_CopyMat(var mat: Tmatrix;var pu:typeUO);
begin
  verifierObjet(pu);
  verifierObjet(typeUO(mat));

  with Tmatrix(pu) do
  begin
    if (mat.Istart<>Istart) or (mat.Iend<>Iend)
       or (mat.Jstart<>Jstart) or (mat.Jend<>Jend)
         then sortieErreur(E_copyMat);
    copyMat(mat);
  end;
end;

procedure proTmatrix_Threshold(th:float;Fup,Fdw:boolean;var pu:typeUO);
begin
  verifierObjet(pu);
  with Tmatrix(pu) do threshold(th,Fup,Fdw);
end;

procedure proTmatrix_Threshold1(th:float;var pu:typeUO);
begin
  verifierObjet(pu);
  with Tmatrix(pu) do threshold1(th);
end;

procedure proTmatrix_Threshold2(th1,th2,val1,val2:float;var pu:typeUO);
begin
  verifierObjet(pu);
  with Tmatrix(pu) do threshold2(th1,th2,val1,val2);
end;


procedure proTmatrix_ClearSelPix(var pu:typeUO);
begin
  verifierObjet(pu);
  with Tmatrix(pu) do ClearSelPix;
end;

procedure proTmatrix_ClearMarkPix(var pu:typeUO);
begin
  verifierObjet(pu);
  with Tmatrix(pu) do ClearMarkPix;
end;

procedure proTmatrix_SingleSel(w:boolean;var pu:typeUO);
begin
  verifierObjet(pu);
  with Tmatrix(pu) do FsingleSel:=w;
end;

function fonctionTmatrix_SingleSel(var pu:typeUO):boolean;
begin
  verifierObjet(pu);
  with Tmatrix(pu) do result:=FsingleSel;
end;

procedure proTmatrix_SingleMark(w:boolean;var pu:typeUO);
begin
  verifierObjet(pu);
  with Tmatrix(pu) do FsingleMark:=w;
end;

function fonctionTmatrix_SingleMark(var pu:typeUO):boolean;
begin
  verifierObjet(pu);
  with Tmatrix(pu) do result:=FsingleMark;
end;

procedure proTmatrix_OnSelect(p:integer;var pu:typeUO);
begin
  verifierObjet(pu);
  with Tmatrix(pu).onSelect do setAd(p);
end;

function fonctionTmatrix_OnSelect(var pu:typeUO):integer;
begin
  verifierObjet(pu);
  result:=Tmatrix(pu).OnSelect.ad;
end;

procedure proTmatrix_OnMark(p:integer;var pu:typeUO);
begin
  verifierObjet(pu);
  with Tmatrix(pu).onMark do setAd(p);
end;

function fonctionTmatrix_OnMark(var pu:typeUO):integer;
begin
  verifierObjet(pu);
  result:=Tmatrix(pu).OnMark.ad;
end;

procedure proTmatrix_OnHint(p:integer;var pu:typeUO);
begin
  verifierObjet(pu);
  with Tmatrix(pu).onHint do setAd(p);
end;

function fonctionTmatrix_OnHint(var pu:typeUO):integer;
begin
  verifierObjet(pu);
  result:=Tmatrix(pu).OnHint.ad;
end;


function fonctionTmatrix_SelectON(var pu:typeUO):boolean;
begin
  verifierObjet(pu);
  result:= Tmatrix(pu).SelectMode;
end;

procedure proTmatrix_SelectON(x:boolean;var pu:typeUO);
begin
  verifierObjet(pu);
  with Tmatrix(pu) do
  begin
    SelectMode:=x;
    if selectMode then markMode:=false;
  end;
end;

function fonctionTmatrix_MarkON(var pu:typeUO):boolean;
begin
  verifierObjet(pu);
  result:= Tmatrix(pu).MarkMode;
end;

procedure proTmatrix_MarkON(x:boolean;var pu:typeUO);
begin
  verifierObjet(pu);
  with Tmatrix(pu) do
  begin
    MarkMode:=x;
    if MarkMode then SelectMode:=false;
  end;
end;


procedure proTmatrix_ShowContour(var pu:typeUO);
begin
  verifierObjet(pu);
  with Tmatrix(pu) do CreateCplot;
end;


var
  E_matrice:integer;
  E_modifyObject:integer;
  E_matriceTemp:integer;

procedure verifierMatrice(var pu:Tmatrix);
begin
  if (@pu=nil) or not assigned(pu) or not assigned(pu.data)
    then sortieErreur(E_Matrice);
end;

procedure MadjustIndexTpNum(src,dest:Tmatrix);
begin
  if dest.readOnly then sortieErreur(E_modifyObject);

  with src do
  if (tpNum<>dest.tpNum) or(istart<>dest.istart) or (iend<>dest.iend) or
     (jstart<>dest.jstart) or (jend<>dest.jend) then
  begin
    if dest.inf.temp
      then dest.modify(tpNum,Istart,Jstart,Iend,Jend)
      else sortieErreur(E_modifyObject);
  end;

  with src do
  begin
    dest.modify(tpNum,Istart,Jstart,Iend,Jend);
    dest.Dxu:=Dxu;
    dest.x0u:=x0u;
    dest.Dyu:=Dyu;
    dest.y0u:=y0u;

    if tpNum<g_longint then
    begin
      dest.Dzu:=Dzu;
      dest.z0u:=z0u;
    end;
  end;
end;

procedure MadjustIndex(src,dest:Tmatrix);
begin
  if dest.readOnly then sortieErreur(E_modifyObject);

  with src do
  if (istart<>dest.istart) or (iend<>dest.iend) or (jstart<>dest.jstart) or (jend<>dest.jend) then
  begin
    if dest.inf.temp
      then dest.modify(dest.tpNum,Istart,Jstart,Iend,Jend)
      else sortieErreur(E_modifyObject);
  end;

  with src do
  begin
    dest.Dxu:=Dxu;
    dest.x0u:=x0u;
    dest.Dyu:=Dyu;
    dest.y0u:=y0u;

    if tpNum<g_longint then
    begin
      dest.Dzu:=Dzu;
      dest.z0u:=z0u;
    end;
  end;
end;

procedure McopyXYscale(source,dest:Tmatrix);
begin
  dest.dxu:=source.dxu;
  dest.x0u:=source.x0u;
  dest.unitX:=source.unitX;

  dest.dyu:=source.dyu;
  dest.y0u:=source.y0u;
  dest.unitY:=source.unitY;

end;


procedure McopyZscale(source,dest:Tmatrix);
begin
  if (source.tpNum <= G_longint) and (dest.tpNum <=G_longint) then
    begin
      dest.dzu:=source.dzu;
      dest.z0u:=source.z0u;
    end;
  {dest.unitY:=source.unitY;}
end;


procedure Mmodify(dest:Tmatrix;tp:typetypeG;i1,i2,j1,j2:integer);
begin
  verifierObjet(typeUO(dest));

  if dest.readOnly then sortieErreur('Tmatrix : cannot modify this object');

  if (tp=dest.tpNum) and (i1=dest.istart) and (i2=dest.iend) and (j1=dest.jstart) and (j2=dest.jend)
    then exit;

  if dest.inf.temp then
  with dest do
  begin
    if (i2<i1-1) or(j2<j1-1) then  sortieErreur(E_indexOrder);
    if not SupportType(tp) then  sortieErreur(E_modify1);

    dest.initTemp(i1,i2,j1,j2,tp);
  end
  else sortieErreur('Tmatrix : cannot modify this object');
end;

procedure verifierMatriceTemp(var pu:Tmatrix);
begin
  if (@pu=nil) or not assigned(pu) or not assigned(pu.data)
    then sortieErreur(E_matrice);
  if not pu.inf.temp or (pu.tb=nil)
    then sortieErreur(E_MatriceTemp);
end;


function fonctionTmatrix_loadFromBMP(stF:AnsiString;var pu:typeUO):boolean;
begin
  verifierMatrice(Tmatrix(pu));

  result:=Tmatrix(pu).loadFromBMP(stF);
end;

function fonctionTmatrix_saveAsBMP(stF:AnsiString;var pu:typeUO):boolean;
begin
  verifierMatrice(Tmatrix(pu));

  result:=Tmatrix(pu).saveAsBMP(stF);
end;

function fonctionTmatrix_loadFromSTK(stF:AnsiString;num:integer;var pu:typeUO):boolean;
begin
  verifierMatrice(Tmatrix(pu));

  result:=Tmatrix(pu).loadFromSTK(stF,num);
end;


procedure proTmatrix_AngularMode(w:integer;var pu:typeUO);
begin
  verifierMatrice(Tmatrix(pu));
  if (w<0) or (w>2) then sortieErreur('Tmatrix: angularMode out of range');
  Tmatrix(pu).visu.AngularMode:=w;
end;

function fonctionTmatrix_AngularMode(var pu:typeUO):integer;
begin
  verifierMatrice(Tmatrix(pu));
  result:=Tmatrix(pu).visu.AngularMode;
end;


procedure proTmatrix_AngLineWidth(w:integer;var pu:typeUO);
begin
  verifierMatrice(Tmatrix(pu));
  if (w<0) then sortieErreur('Tmatrix: AngLineWidth must be positive');
  Tmatrix(pu).visu.AngularLW :=w;
end;

function fonctionTmatrix_AngLineWidth(var pu:typeUO):integer;
begin
  verifierMatrice(Tmatrix(pu));
  result:=Tmatrix(pu).visu.AngularLW;
end;

procedure proTmatrix_Edit(var pu:typeUO);
begin
  verifierMatrice(Tmatrix(pu));
  Tmatrix(pu).editMatrix(nil);
end;

function fonctionTmatrix_Cmin(var pu:typeUO):float;
  begin
    verifierObjet(pu);
    result:=Tmatrix(pu).visu.Cmin;
  end;

procedure proTmatrix_Cmin(x:float;var pu:typeUO);
  begin
    verifierObjet(pu);
    with Tmatrix(pu) do
    begin
      visu.Cmin:=x;
    end;
  end;

function fonctionTmatrix_Cmax(var pu:typeUO):float;
  begin
    verifierObjet(pu);
    result:=Tmatrix(pu).visu.Cmax;
  end;

procedure proTmatrix_Cmax(x:float;var pu:typeUO);
  begin
    verifierObjet(pu);
    with Tmatrix(pu) do
    begin
      visu.Cmax:=x;
    end;
  end;

procedure proTmatrix_AutoscaleC(var pu:typeUO);
begin
  verifierObjet(pu);
  with Tmatrix(pu) do
  begin
    autoScaleC;
  end;
end;

procedure proTmatrix_ShowDesignWindow(var pu:typeUO);
begin
  verifierObjet(pu);
  with Tmatrix(pu) do
  begin
    showDesignForm;
  end;
end;

procedure proTmatrix_setMapScale(Xextent,Yextent,Iorg,Jorg:float;var pu:typeUO);
begin
  verifierObjet(pu);
  Tmatrix(pu).setMapScale(Xextent,Yextent,Iorg,Jorg);
end;



procedure MatToSectors(mat:Tmatrix;vec:Tvector;xa,ya,xb,yb,thresh:float;nb:integer);
var
  i,j,k:integer;
  xbb,ybb:array of float;
  radius,theta0:float;
  x,y:float;
begin
  vec.modify(vec.tpNum,0,nb-1);
  setLength(xbb,nb);
  setLength(ybb,nb);
  radius:=sqrt(sqr(xa-xb)+sqr(ya-yb));
  theta0:=segAngle(xa,ya,xb,yb);
  for i:=0 to nb-1 do
  begin
    xbb[i]:=xa+radius*cos(theta0+2*pi/nb*i);
    ybb[i]:=ya+radius*sin(theta0+2*pi/nb*i);
  end;

  with mat do
  for i:=Istart to Iend do
  for j:=Jstart to Jend do
  if Zvalue[i,j]>=Thresh then
  begin
    x:=convx(i);
    y:=convy(j);
    for k:=0 to nb-1 do
    if pointInSector(xa,ya,xbb[k],ybb[k],2*pi/nb,x,y) then
    begin
      vec[k]:=vec[k]+1;
      break;
    end;
  end;
end;

procedure proMatToSectors(var mat:Tmatrix;var vec:Tvector;xa,ya,xb,yb,thresh:float;nb:integer);
begin
  verifierMatrice(mat);
  verifierVecteurTemp(vec);
  if nb<1 then sortieErreur('MatToSectors : invalid number of sectors');
  if (xa=xb) and (ya=yb) then sortieErreur('MatToSectors : pointA = pointB ');

  MatToSectors(mat,vec,xa,ya,xb,yb,thresh,nb);
end;

function fonctionTmatrix_regionList(var pu:typeUO):pointer;
begin
  verifierObjet(pu);
  result:=@Tmatrix(pu).regionList.MyAd;
end;



procedure proTmatrix_Full2DPalette(w:boolean;var pu:typeUO);
begin
  verifierMatrice(Tmatrix(pu));
  Tmatrix(pu).visu.FullD2:=w;
end;

function fonctionTmatrix_Full2DPalette(var pu:typeUO):boolean;
begin
  verifierMatrice(Tmatrix(pu));
  result:=Tmatrix(pu).visu.FullD2;
end;

procedure proTmatrix_saveSingleData(var binF, pu:typeUO);
begin
  proTmatrix_saveSingleData_1(binF,false,pu);
end;

procedure proTmatrix_saveSingleData_1(var binF:typeUO;FbyLine:boolean;var  pu:typeUO);
begin
  verifierMatrice(Tmatrix(pu));
  verifierObjet(binF);

  Tmatrix(pu).saveAsSingle1(TbinaryFile(binF).f, FbyLine);
end;


procedure proTmatrix_loadSingleData(var binF, pu:typeUO);
begin
  proTmatrix_LoadSingleData_1( binF, false, pu);
end;

procedure proTmatrix_LoadSingleData_1(var binF:typeUO;FbyLine:boolean;var pu:typeUO);
begin
  verifierMatrice(Tmatrix(pu));
  verifierObjet(binF);

  Tmatrix(pu).loadAsSingle1(TbinaryFile(binF).f,FbyLine);
end;


function fonctionTMatrix_Transparent(var pu:typeUO):boolean;
begin
  verifierObjet(pu);
  result:=Tmatrix(pu).FTransparent;
end;

procedure proTMatrix_Transparent(w:boolean;var pu:typeUO);
begin
  verifierObjet(pu);
  with Tmatrix(pu) do Ftransparent:=w;
end;

function fonctionTMatrix_TransparentValue(var pu:typeUO):float;
begin
  verifierObjet(pu);
  result:=Tmatrix(pu).FTransparentValue;
end;

procedure proTMatrix_TransparentValue(w:float;var pu:typeUO);
begin
  verifierObjet(pu);
  with Tmatrix(pu) do FtransparentValue:=w;
end;


procedure proTmatrix_distri(var vec, pu:typeUO);
begin
  verifierObjet(pu);
  verifierObjet(vec);
  Tmatrix(pu).Distri(Tvector(vec));
end;


function TMatrix.getMatPos(var xp, yp: integer): boolean;
begin
  result:= visu.getMatPos(data,@wf,degP,xp,yp);
end;


procedure proTMatrix_loadFromText(fileName: AnsiString; var pu: Tmatrix);
begin
  verifierMatrice(pu);
  Tmatrix(pu).loadFromText(fileName);
end;

procedure proTMatrix_saveAsText(fileName: AnsiString; decimalPlaces: integer; var pu: Tmatrix);
begin
  verifierMatrice(pu);
  Tmatrix(pu).saveAsText(fileName,decimalPlaces);
end;

procedure proTMatrix_Circle(xC, yC, Rc, value: float;Ffill:boolean;var pu: Tmatrix);
begin
  verifierMatrice(pu);
  Tmatrix(pu).Circle(xC, yC, Rc, value, Ffill);
end;

procedure proTMatrix_Polygons(var plot:TXYplot; val1,val2: float;Ffill:boolean;var pu:Tmatrix);
begin
  verifierMatrice(pu);
  verifierObjet(typeUO(plot));
  Tmatrix(pu).polygons(plot,val1,val2,Ffill);
end;

function fonctionGetPalNameList: AnsiString;
var
  sr: TSearchRec;
  st:string;
begin
  result:='';
  if FindFirst( AppData +'*.pl1', faAnyFile, sr) = 0 then
  begin
     repeat
       st:=copy(sr.Name,1,pos('.',sr.Name)-1);
       if result<>'' then result:= result+ '|';
       result:= result + st;
     until FindNext(sr)<>0;
     FindClose(sr);
  end;

end;




Initialization
AffDebug('Initialization StmMat1',0);

installError(E_matrice,'Tmatrix: not assigned or no valid data ');
installError(E_matriceTemp,'Tmatrix: data not in memory');
installError(E_modifyObject,'Tmatrix: cannot modify this object');

installError(E_create1,'Tmatrix.create: Type not supported');
installError(E_create2,'Tmatrix.create: start index must be lower than end index');

installError(E_index, 'Tmatrix: index out of range');
installError(E_modify1,'Tmatrix.modify: type not supported');
installError(E_modify2,'Tmatrix.modify: index out of range');
installError(E_indexOrder,'Tmatrix: start index must be lower than end index');
installError(E_data,'Tmatrix: no valid data or index out of range');

installError(E_displayMode,'Tmatrix: DisplayMode out of range');
installError(E_aspectRatio,'Tmatrix: invalid aspect ratio');

installError(E_copyMat,'Tmatrix.copyMat: matrix parameters must be equals');

installError(E_Cmode,'Tmatrix.CpxMode: parameter out of range');


registerObject(Tmatrix,data);

end.
