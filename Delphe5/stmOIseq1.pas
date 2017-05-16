
unit stmOIseq1;

interface
{$IFDEF FPC} {$mode delphi} {$DEFINE AcqElphy2} {$A1} {$Z1} {$ENDIF}

uses windows,classes,sysUtils,types,graphics,math, menus,forms,
     util1,Dgraphic,heap0, debug0, Dtrace1,
     stmobj,ElphyFormat,varconf1,dtf0, stmPopup,
     NcDef2,stmpg,
     stmdef, Acqdef2,
     ippdefs17,ipps17, ipp17ex, mathKernel0, MKL_dfti,
     visu0,stmDplot,stmDobj1,stmBMplot1,OIblock1,stmMat1,stmvec1,
     MatCood0, OIcood0, regions1, stmRegion1,
     VlistA1,
     tiff0,
     stmMatU1,
     matlab_matrix,matlab_mat,
     PCL0,
     DtbEdit2,
     DBrecord1,
     MotionCloud1,
     BinFile1;


  { OIseq gère une séquence d'imagerie optique qui réside en mémoire ou dans un fichier.
    La séquence contient
      une image de référence (optionnelle)
      Nframe images toutes de même structure (taille Nx * Ny ,type single)

    Les images sont vues à travers un cache contenant maxPoolCnt images (type Tmatrix)
    Les objets du pool sont créés une fois pour toute, il n'y a donc pas de perte de
    temps pour les modifications d'objets.
    Seul le contenu des Tmatrix est modifié pendant l'utilisation.

    Dans la programmation Elphy, on accède aux images via une propriété Frame[n] de TOIseq
    Le programmeur a l'impression de disposer de toutes les images (exemple 1024) alors qu'un
    petit nombre est disponible à la fois.

    les matrices mat[n] sont initialisées (0..Nx-1,0..Ny-1) avec n compris entre 0 et Nframe-1
  }
  {  TOIseqMeta gère une séquence d'images qui résident dans un fichier STK
  }

const
  maxPoolMat=10;

type
  Tsmallpoint=record
              case integer of
              1:(x,y:smallint);
              2:(w:longint);
              end;

  TOIscaleProp= object
                  i1,i2,j1,j2: integer;
                  x1,x2,y1,y2: single;
                  unitX,unitY: string[10];
                  procedure init;
                  procedure initValues(Dxu,x0u,Dyu,y0u: float; i1a,i2a,j1a,j2a: integer);
                  function getDx: single;
                  function getDy: single;
                  function getX0: single;
                  function getY0: single;
                end;

  TOIseq=class(TbitmapPlot)
           PoolCnt:integer;                             {compteur du pool}
           matRef:Tmatrix;                              {image de référence}
           PoolMat:array[0..maxPoolMat-1] of Tmatrix;   {le pool }
           CurFrame:array[0..maxPoolMat-1] of integer;  {indice dans la séquence de l'image stockée }


           Nx,Ny,Nframe:integer;                        { Dimensions et nombre d'images }
           tpNum:typetypeG;                             { type de données dans Elphy}
           tpNumFile:typetypeG;                         { type de données dans le fichier }
                                                        { Dans le fichier, on a oiblock.tpNum=g_smallint
                                                         mais en mémoire, on a g_single ou g_double }

           FrameSize:integer;                           {taille d'une image dans le fichier }

           dataPos:int64;                               {offset de l'image dans le fichier }
           WithRefFrame:boolean;                        {true si l'image de référence existe }

           FrameBuf:pointer;                            {tampon alloué pour charger temporairement une image
                                                         On la convertit en single après chargement
                                                         taille FrameSize }

           FinitOK:boolean;                             {indique que l'initialisation est OK }
           Ffile:boolean;                               {permet de distinguer les séquences autonomes
                                                         de celles associées à un fichier de données }

           f0:TgetStream;                               {le fichier, fourni pendant init }
           Fmemory:boolean;                             {si TRUE, toute la séquence est en mémoire}

           MainBuf:array of PtabSingle;                 {contient la séquence si Fmemory=true}
           MainBuf0: pointer;
           Fcompact:boolean;

           Findex:integer;                              {index de la frame affichée, commence à zéro}

           degP:typeDegre; {theta fait double emploi avec visu.theta}

           FpalName:AnsiString;
           wf:TWFoptions;
           Fselected:array of boolean;                  {sélection d'une frame}

           fvecFile:TgetStream;
           vecPos: int64;

           CpIndex:smallint;

           RSHtext:AnsiString;

           OIscaleProp: TOIscaleProp;
           deltaT: double;                              // intervalle entre deux images
                                                        // utilisé surtout par OIseqPCL


           function getBinX: integer;    virtual;
           function getBinY: integer;    virtual;
           procedure setBinX(w:integer); virtual;
           procedure setBinY(w:integer); virtual;

           property BinX: integer read getBinX write setBinX;
           property BinY: integer read getBinY write setBinY;

           procedure setInMemory(w:boolean);virtual;
           procedure initDataMat;
           function getMat(n:integer):Tmatrix;        {renvoie l'image d'indice séquence n }

           procedure setPalColor(n:integer;x:integer);
           function getPalColor(n:integer):integer;
           function getSelected(num:integer):boolean;
           procedure setSelected(num:integer;w:boolean);

           procedure setIndex(n:integer);
           procedure SetNframe(n: integer);virtual;

           procedure CheckCpIndex;

           procedure transferData(src,dest:pointer);
           procedure loadMat(m:Tmatrix;n:integer);virtual;
           procedure loadvecFromFile(vec:Tvector;x,y:integer);virtual;
           procedure loadvecFromMem(vec:Tvector;x,y:integer);
           procedure SaveVecToMem(vec:Tvector;x,y:integer);

           procedure FreeMainBuf;

           property initOK:boolean read FinitOK;
           property InMemory:boolean read Fmemory write setInMemory;

           property mat[n:integer]:Tmatrix read getmat;

           property index:integer read Findex write setIndex;

           property FrameCount:integer read Nframe write SetNframe;

           property theta:single read degP.theta write degP.theta;

           property TwoCol:boolean read visu.twoCol write visu.twoCol;
           property PalColor[n:integer]:integer read getPalColor write setPalColor;
           property DisplayMode:byte read visu.modeMat write visu.modeMat;
           property PalName:AnsiString read FpalName write FpalName;

           property selected[n:integer]:boolean read getSelected write setSelected;


           constructor create;override;
           class function STMClassName:AnsiString;override;
           destructor destroy;override;


           procedure Display;override;
           procedure displayInside(FirstUO:typeUO;extWorld,logX,logY:boolean;
                                   const order:integer=-1);override;
           function getInsideWindow:Trect;override;



           procedure cadrerZ(sender:Tobject);override;

           procedure autoscaleZ;override;
           procedure autoscaleZ1(allFrames:boolean);
           procedure AutoScaleZsym;

           function ChooseCoo1:boolean;override;
           procedure getMinMax(var Vmin,Vmax:float);


           function getIend:integer;override;
           function getJend:integer;override;

           procedure loadImage(st:AnsiString);override;
           procedure saveImage(st:AnsiString;format,quality:integer);overload;override;
           procedure saveImage(st:AnsiString;format,quality,x1,y1,x2,y2:integer);overload;override;


           procedure initFile(f:TgetStream;oi:ToiBlock);{initialisation fichier
                                                        {f est le fichier de données (toujours ouvert)
                                                         oi contient les info d'initialisation }
           procedure initMem(Nx1,Ny1,Nframe1:integer;withref:boolean; tp:typetypeG; const compact:boolean=false);

           function getRSHinfo(st:Ansistring;var value:float):Ansistring;

           procedure BuildVector(reg:Treg;vec:TVector; const mode: integer=0);
           procedure BuildVectors(regList:TregionList;vecList:TVlist; const mode: integer=0);
           procedure BuildVectorFromRect(i1,i2,j1,j2: integer; vec:Tvector; const mode: integer=0);


           procedure copyOI(oiseq:Toiseq);
           procedure copyFrames(oiseq:Toiseq;f1,f2,fD:integer);
           procedure extract(oiseq:Toiseq;i1,i2,j1,j2,f1,f2:integer);

           procedure Add(oiseq:Toiseq);
           procedure Sub(oiseq:Toiseq);
           procedure AddNum(w:float);
           procedure MulNum(w:float);

           procedure Mul(oiseq:Toiseq);
           procedure Div1(oiseq:Toiseq;th,value:float);


           procedure SaveToVec(vec:Tvector);
           procedure LoadFromVec(vec:Tvector);

           procedure transpose(p:pointer);
           procedure test;

           procedure saveToMem(t:pointer; tpdest:typetypeG; LineFirst:boolean);
           procedure LoadFromMem(t:pointer; tpdest:typetypeG; LineFirst:boolean);

           function getMxArray(Const tpdest0:typetypeG = G_none):MxArrayPtr;override;
           procedure setMxArray(mxArray:MxArrayPtr;Const invertIndices:boolean=false);override;

           procedure BuildInfo(var conf:TblocConf;lecture,tout:boolean);override;
           procedure completeLoadInfo;override;

           procedure saveData(f:Tstream);override;
           function loadData(f:Tstream):boolean;override;

           procedure setV(x,y:integer;vec:Tvector);
           procedure getV(x,y:integer;vec:Tvector);

           procedure BuildVecFile(f:Tstream);
           procedure setVecFile(f:TgetStream;var offset:int64);

           procedure OIVconvolve(Hf:Tvector;src,dest:AnsiString);
           procedure OIVaverage(vecStim:Tvector;src,destMoy,destStd:AnsiString);
           procedure OIVSNR(vecStim:Tvector;srcMoy,srcStd,dest:AnsiString);

           procedure fill(w:float);
           procedure ReadFromGSD(StSrc:AnsiString);


           function CompatibleOIseq(oi: Toiseq):boolean;

           function getPopUp:TpopUpMenu;override;
           procedure Proprietes(sender:Tobject);override;
           procedure DispAsMatrix(sender:Tobject);

           function MemFrame(n:integer):pointer;
           procedure Synthesis1( v,sv,rho,srho,theta,stheta: float);
           procedure SynthesisJV(  ss, rf, tf, rs, ts, eta, alpha: single; seed: longword; Fty:boolean);

           procedure setChildNames;override;
           procedure SaveToBin(f: Tstream; tp:typetypeG; LineFirst:boolean);
           procedure LoadFromBin(f: Tstream; tp:typetypeG; LineFirst:boolean);
         end;


  TOIseqMeta=
         class(TOIseq)
         private
           stripOffsets:array of integer;
           stripByteCounts:array of integer;
           DiskFrameSize:integer;
           SampleSize:integer;

         protected
           procedure setInMemory(w:boolean);override;
           procedure loadMat(m:Tmatrix;n:integer);override;
           procedure loadvecFromFile(vec:Tvector;x,y:integer);override;
         public
           procedure initFile(f:TgetStream;stk:TstkFile);
         end;

  {Version laissant les données sur le disque }
(*
  TOIseqPCL=
         class(TOIseq)
         private
           stFile:AnsiString;
           dtFile:double;
           tmin,tmax:double;
           Vindex:array of integer;
           nbPhoton: integer;
           NxBase,NyBase: integer;
           FBinX,FBinY: integer;

           f:TfileStream;
           procedure setInMemory(w:boolean);override;
           function GetStream:Tstream;

           procedure setBinX(w:integer);
           procedure setBinY(w:integer);

         protected
           procedure loadMat(m:Tmatrix;n:integer);override;
           procedure loadvecFromFile(vec:Tvector;x,y:integer);override;
         public
           property BinX: integer read FBinX write setBinX;
           property BinY: integer read FBinY write setBinY;

           constructor create;override;
           procedure initFile(stF:AnsiString; Nx1,Ny1:integer; dt,torg,tend:float);
           destructor destroy;override;
         end;
 *)
  {Version chargeant tout en mémoire }

{ TPCLrecord1 est la structure d'un photon dans un fichier PCL
  Les nombres sont stockés en Big Endian format
  Convert rétablit l'ordre des octets .
 }

type
  TPCLprop=record
             FbinDt:double;     // Toujours en millisecondes
             tmin,tmax:double;
             NxBase,NyBase: integer;
             FBinX,FBinY: integer;
             NframeU: integer;
             NoOverlap: boolean;
           end;

  TphotonFilter= record
                    Vx,Vy:single;
                    RotX,RotY,RotTheta:single;
                    Dx,Dy:single;
                    active:boolean;
                    Displayed:boolean;
                  end;

  TOIseqPCL=
         class(TOIseq)
         private
           stFile:AnsiString;

           BlockLoaded:boolean;             // Les données ont été chargées à partir d'un fichier Elphy avec LoadBlock
           FileLoaded: boolean;             // Les données ont été chargées à partir d'un fichier PCL avec LoadFile

           PCLprop:TPCLprop;

           TabPhoton0,TabPhoton: array of TPCLrecord;  // Tableau créé par LoadFile ou LoadBlock

           Vindex:array of integer;         // Indices des débuts d'image
                                            // Calculé par InitFrames

           dataPhoton: typeDataPhotonB;     // Permet l'accès aux photons. Les photons sont
                                            //   - soit stockés dans TabPhoton
                                            //   - soit stockés dans un buffer externe
                                            // Les indices utiles vont de 0 à N-1


           Fmul:float;                      // vaut 1000 quand les unités sont des millisecondes
                                            //      1000000                        secondes

           editForm: TtableEdit;

           EditDecimalPlaces: array[1..4] of integer;

           

           procedure EditPhotons(sender:Tobject);

           function getBinX: integer;    override;
           function getBinY: integer;    override;
           procedure setBinX(w:integer); override;
           procedure setBinY(w:integer); override;
           procedure setBinDT(w: double);

           procedure UpdateEditForm;

           function DgetColName(i:integer):AnsiString;
           function DgetE(i,j:integer):float;

           procedure EditSetDeci(n:integer; x:integer);
           function EditGetDeci(n:integer): integer;

         protected

           procedure setInMemory(w:boolean);override;
           procedure loadMat(m:Tmatrix;n:integer);override;
           procedure loadvecFromFile(vec:Tvector;x,y:integer);override;
           procedure InitVectors;
           procedure setChildNames;override;

           procedure SetNframe(n:integer);override;
         public
           Vtimes: Tvector;
           Vx,Vy,Vz:Tvector;

           
           PhotonFilter: TphotonFilter;
           Dxu0, Dyu0: double;

           property binDt:double read PCLprop.FbinDt write setBinDt;
           property tmin:double read PCLprop.tmin write PCLprop.tmin;
           property tmax:double read PCLprop.tmax write PCLprop.tmax;
           property NxBase: integer read PCLprop.NxBase write PCLprop.NxBase;
           property NyBase: integer read PCLprop.NyBase write PCLprop.NyBase;


           property NframeU: integer read PCLprop.NframeU write PCLprop.NframeU;
           property NoOverlap: boolean read PCLprop.NoOverlap write PCLprop.NoOverlap;

           constructor create;override;
           procedure LoadFile(stF:AnsiString);
           procedure LoadBlock(num:integer; f:Tstream;size:integer;tmin1,tmax1:float;ux:AnsiString);
           procedure FilterTabPhoton(i0,nb: integer);

           procedure InitAcq(data: TypeDataPhotonB;tt1,tt2:float;EpMode: boolean; Nx1,Ny1:integer);
           procedure ModifyLimits(imax:integer;ttmax:float);

           procedure FreeData;
           procedure InitFrames0( FinitVec:boolean);
           procedure InitFrames( Nx1, Ny1: integer; dt,torg,tend: float);
           destructor destroy;override;

           procedure BuildInfo(var conf:TblocConf;lecture,tout:boolean);override;
           procedure completeLoadInfo;override;
           procedure saveToStream(f:Tstream;Fdata:boolean);override;
           function loadFromStream(f:Tstream;size:LongWord;Fdata:boolean):boolean;override;

           function indexToReal(id:integer):float;override;

           procedure UpdatePhotons(LastI: integer; lastT:float);
           function PhotonCount:integer;
           function getPopUp: TpopUpMenu;override;

           procedure Invalidate;override;
           procedure Proprietes(sender:Tobject);override;

           procedure FilterPhoton(var i, j: smallint);

           procedure UpdateFilter;

           procedure DBtoPCLfilter(db:TDBrecord);
           procedure PCLfilterToDB(db:TDBrecord);

         end;

procedure proTOIseq_create(name:AnsiString;Nx1,Ny1,Nframe1:integer;withRef:boolean;var pu:typeUO);pascal;
procedure proTOIseq_create_1(Nx1,Ny1,Nframe1:integer;withRef:boolean;var pu:typeUO);pascal;
procedure proTOIseq_createCompact(Nx1,Ny1,Nframe1:integer;Fdouble:boolean;var pu:typeUO);pascal;


function fonctionTOIseq_Nx(var pu:typeUO):integer;pascal;
function fonctionTOIseq_Ny(var pu:typeUO):integer;pascal;
function fonctionTOIseq_NumType(var pu:typeUO):integer;pascal;

function fonctionTOIseq_FrameCount(var pu:typeUO):integer;pascal;
procedure proTOIseq_FrameCount(n:integer;var pu:typeUO);pascal;

function fonctionTOIseq_HasRefFrame(var pu:typeUO):boolean;pascal;
function fonctionTOIseq_RefFrame(var pu:typeUO):pointer;pascal;
function fonctionTOIseq_Frame(n:integer;var pu:typeUO):pointer;pascal;
procedure proTOIseq_initFile(stF:AnsiString;numOc:integer;var pu:typeUO);pascal;

procedure proTOIseq_getV(x,y:integer;var vec:Tvector;var pu:typeUO);pascal;
procedure proTOIseq_setV(x,y:integer;var vec:Tvector;var pu:typeUO);pascal;

procedure proTOIseq_inMemory(w:boolean;var pu:typeUO);pascal;
function fonctionTOIseq_inMemory(var pu:typeUO):boolean;pascal;

procedure proTOIseq_Index(n:integer;var pu:typeUO);pascal;
function fonctionTOIseq_Index(var pu:typeUO):integer;pascal;

procedure proTOIseq_Selected(n:integer;x:boolean;var pu:typeUO);pascal;
function fonctionTOIseq_Selected(n:integer;var pu:typeUO):boolean;pascal;

procedure proTOIseq_CpIndex(p:integer;var pu:typeUO);pascal;
function fonctionTOIseq_CpIndex(var pu:typeUO):integer;pascal;

function fonctionTOIseq_Zmin(var pu:typeUO):float;pascal;
procedure proTOIseq_Zmin(x:float;var pu:typeUO);pascal;

function fonctionTOIseq_Zmax(var pu:typeUO):float;pascal;
procedure proTOIseq_Zmax(x:float;var pu:typeUO);pascal;

function fonctionTOIseq_theta(var pu:typeUO):float;pascal;
procedure proTOIseq_theta(x:float;var pu:typeUO);pascal;

function fonctionTOIseq_AspectRatio(var pu:typeUO):float;pascal;
procedure proTOIseq_AspectRatio(x:float;var pu:typeUO);pascal;

function fonctionTOIseq_TwoColors(var pu:typeUO):boolean;pascal;
procedure proTOIseq_TwoColors(x:boolean;var pu:typeUO);pascal;

function fonctionTOIseq_PalColor(n:integer;var pu:typeUO):integer;pascal;
procedure proTOIseq_PalColor(n:integer;x:integer;var pu:typeUO);pascal;

procedure proTOIseq_DisplayMode(x:integer;var pu:typeUO);pascal;
function fonctionTOIseq_DisplayMode(var pu:typeUO):integer;pascal;

procedure proTOIseq_PalName(x:AnsiString;var pu:typeUO);pascal;
function fonctionTOIseq_PalName(var pu:typeUO):AnsiString;pascal;

procedure proTOIseq_getMinMax(var Vmin,Vmax:float;var pu:typeUO);pascal;

procedure proTOIseq_AutoscaleZ(var pu:typeUO);pascal;
procedure proTOIseq_AutoscaleZ_1(flagAll:boolean;var pu:typeUO);pascal;
procedure proTOIseq_AutoscaleZsym(var pu:typeUO);pascal;

function fonctionToiseq_regionList(var pu:typeUO):pointer;pascal;

procedure proTOIseq_BuildVector(var reg:Treg;var vec:Tvector;var pu:typeUO);pascal;
procedure proTOIseq_BuildVector_1(var reg:Treg;var vec:Tvector;mode:integer;var pu:typeUO);pascal;

procedure proTOIseq_BuildVectors(var reglist:TregionList;var vecList:TVlist;var pu:typeUO);pascal;
procedure proTOIseq_BuildVectors_1(var reglist:TregionList;var vecList:TVlist;mode:integer;var pu:typeUO);pascal;

procedure proTOIseq_BuildVectorFromRect(i1,i2,j1,j2: integer;var vec:Tvector;var pu:typeUO);pascal;
procedure proTOIseq_BuildVectorFromRect_1(i1,i2,j1,j2: integer;var vec:Tvector;mode:integer;var pu:typeUO);pascal;

procedure proTOIseq_Copy(var oiseq:Toiseq;var pu:typeUO);pascal;
procedure proTOIseq_copyFrames(var oiseq:Toiseq;f1,f2,fD:integer;var pu:typeUO);pascal;
procedure proTOIseq_extract(var oiseq:Toiseq;i1,i2,j1,j2,f1,f2:integer;var pu:typeUO);pascal;
procedure proTOIseq_Add(var oiseq:Toiseq;var pu:typeUO);pascal;
procedure proTOIseq_Sub(var oiseq:Toiseq;var pu:typeUO);pascal;
procedure proTOIseq_AddNum(w:float;var pu:typeUO);pascal;
procedure proTOIseq_MulNum(w:float;var pu:typeUO);pascal;

procedure proTOIseq_Mul(var oiseq:Toiseq;var pu:typeUO);pascal;
procedure proTOIseq_Div1(var oiseq:Toiseq;th,value:float;var pu:typeUO);pascal;


procedure proTOIseq_OIVconvolve(var Hf:Tvector;src,dest:AnsiString;var pu:typeUO);pascal;
procedure proTOIseq_OIVaverage(var vecStim:Tvector;src,destMoy,destStd:AnsiString;var pu:typeUO);pascal;
procedure proTOIseq_OIVSNR(var vecStim:Tvector;srcMoy,srcStd,dest:AnsiString;var pu:typeUO);pascal;
procedure proTOIseq_ReadFromGSD(stF:AnsiString;var pu:typeUO);pascal;


procedure proTOIseqPCL_create(var pu:typeUO);pascal;
procedure proTOIseqPCL_LoadFile( stf:AnsiString; var pu:typeUO);pascal;
procedure proTOIseqPCL_InitFrames( Nx1,Ny1:integer; dt: float;var pu:typeUO);pascal;
procedure proTOIseqPCL_InitFrames_1( Nx1,Ny1:integer; dt: float; tOrg,tend:float;var pu:typeUO);pascal;

procedure proTOIseqPCL_BinX(w:integer;var pu:typeUO);pascal;
function fonctionTOIseqPCL_BinX(var pu:typeUO): integer;pascal;

procedure proTOIseqPCL_BinY(w:integer;var pu:typeUO);pascal;
function fonctionTOIseqPCL_BinY(var pu:typeUO): integer;pascal;

procedure proTOIseqPCL_BinDT(w:float;var pu:typeUO);pascal;
function fonctionTOIseqPCL_BinDT(var pu:typeUO): float;pascal;

procedure proTOIseqPCL_NoOverlap(w:boolean;var pu:typeUO);pascal;
function fonctionTOIseqPCL_NoOverlap(var pu:typeUO): boolean;pascal;

procedure proTOIseqPCL_InstallFilter(x1,y1,dx1,dy1,theta1:float;var pu:typeUO);pascal;


function fonctionTOIseqPCL_Vtimes(var pu:typeUO):Tvector;pascal;
function fonctionTOIseqPCL_Vx(var pu:typeUO):Tvector;pascal;
function fonctionTOIseqPCL_Vy(var pu:typeUO):Tvector;pascal;
function fonctionTOIseqPCL_Vz(var pu:typeUO):Tvector;pascal;

procedure proTvector_LoadFromSTFfile(stf:AnsiString;var pu:Tvector);pascal;

procedure proTOIseq_Synthesis1(v, sv, rho, srho, theta, stheta: float;var pu:typeUO);pascal;
procedure proTOIseq_SynthesisJV(  ss, rf, tf, rs, ts, eta, alpha: float; seed: longword; Fty:boolean;var pu:typeUO);pascal;


function fonctionTOIseq_getRSHinfo(st: Ansistring;var value:float; var pu:typeUO): Ansistring;pascal;

procedure proTOIseq_SaveBinaryData(var fbin:TbinaryFile;tp: integer; LineFirst:boolean; var pu:typeUO);pascal;
procedure proTOIseq_LoadBinaryData(var fbin:TbinaryFile;tp: integer; LineFirst:boolean; var pu:typeUO);pascal;

implementation

uses wacq1, OIseqProp1;

procedure swapInt64(var x: int64);
var
  x1: array[0..7] of byte absolute x;
  y: int64;
  y1: array[0..7] of byte absolute y;
  i:integer;
begin
  for i:=0 to 7 do y1[i]:=x1[7-i];
  x:=y;
end;


var
  OIlist:Tlist;


{ TOIseq }

constructor TOIseq.create;
var
  i:integer;
begin
  inherited;

  GDisp:=1;

  inverseY:=true;
  keepRatio:=true;
  palColor[1]:=7;
  palColor[2]:=7;

  echX:=false;
  echY:=false;
  FtickX:=false;
  FtickY:=false;
  CompletX:=false;
  completY:=false;
  TickExtX:=false;
  TickExtY:=false;

  matRef:=Tmatrix.create;
  matRef.NotPublished:=true;
  matref.setImageOptions;

  for i:=0 to maxPoolMat-1 do
  begin
    PoolMat[i]:= Tmatrix.create;
    PoolMat[i].NotPublished:=true;
    Poolmat[i].setImageOptions;
    curFrame[i]:=-1;
  end;

  OIlist.Add(self);

  OIscaleProp.init;
  DeltaT:=1;
end;

destructor TOIseq.destroy;
var
  i:integer;
begin
  matRef.Free;
  for i:=0 to maxPoolMat-1 do
    PoolMat[i].free;

  freememG(FrameBuf);
  for i:=0 to high(mainbuf) do
  freememG(MainBuf[i]);

  freememG(MainBuf0);

  OIlist.Remove(self);

  inherited;
end;

class function TOIseq.STMClassName: AnsiString;
begin
  result:='OIseq';
end;

procedure TOIseq.setChildNames;
begin
  inherited;

  with matref do
  begin
    ident:=self.ident+'.RefFrame';
    notPublished:=true;
    Fchild:=true;
  end;

end;

procedure TOIseq.transferData(src,dest:pointer );
begin
  ippsTest;
  case tpNumFile of
    G_byte:       ippsConvert_8u32f(Pbyte(src),Psingle(dest),Nx*Ny);
    G_smallint:   ippsConvert_16s32f(Psmallint(src),Psingle(dest),Nx*Ny);
    G_word:       ippsConvert_16u32f(Pword(src),Psingle(dest),Nx*Ny);
    G_longint :   ippsConvert_32s32f(Plongint(src),Psingle(dest),Nx*Ny);
    G_single:     move(src^, dest^, Nx*Ny*4);
  end;
  ippsEnd;

end;

procedure TOIseq.loadMat(m: Tmatrix; n:integer);
begin
  if assigned(f0) then
  begin
    f0().position:= dataPos+(ord(WithRefFrame)+n)*FrameSize;
    f0().Read(FrameBuf^,FrameSize);

    transferData(FrameBuf,m.tb);
    transpose(m.tb);
  end;
end;


function TOIseq.getMat(n: integer): Tmatrix; {n de 0 à max-1}
var
  i,k:integer;
  Mdum:Tmatrix;
  dum:integer;
  off0:integer;
begin
  if (n<0) or (n>=Nframe) then
  begin
    result:=nil;
    exit;
  end;

  TRY
  { Si n se trouve dans la première moitié du buffer qui suit poolCnt (mod maxPoolCnt)
    on amène n en PoolCnt en échangeant les contenus de n et poolCnt

  }
  for i:=0 to maxPoolMat div 2-1 do
  begin
    k:=(PoolCnt+i) mod maxPoolMat;
    if curFrame[k]=n then
    begin
      Mdum:=PoolMat[k];
      dum:=curFrame[k];
      PoolMat[k]:=PoolMat[PoolCnt];
      curFrame[k]:=curFrame[poolCnt];
      PoolMat[PoolCnt]:=Mdum;
      curFrame[poolCnt]:=dum;

      result:=PoolMat[poolCnt];
      poolCnt:=(PoolCnt+1) mod maxPoolMat;
      result.ident:='Frame '+Istr(n+1);
      exit;
    end;
  end;

 {
    Si n se trouve dans l'autre moitié du buffer, on considère qu'il restera un temps assez
    long dans le buffer. On le laisse en place.
 }
  for i:=maxPoolMat div 2 to maxPoolMat-1 do
  begin
    k:=(PoolCnt+i) mod maxPoolMat;
    if curFrame[k]=n then
    begin
      result:=PoolMat[k];
      result.ident:='Frame '+Istr(n+1);
      exit;
    end;
  end;

  { Sinon, on charge n en PoolCnt. }

  result:=PoolMat[poolCnt];
  result.MessageToRef(uomsg_destroy,0);  { On force les référenceurs à oublier PoolMat[poolCnt] }
  result.ident:='Frame '+Istr(n+1);

  curFrame[poolCnt]:=n;
  poolCnt:=(PoolCnt+1) mod maxPoolMat;

  if InMemory then
  begin
    result.modifyAd(MemFrame(n));
  end
  else LoadMat(result,n);

  FINALLY
  result.Dxu:= Dxu;
  result.x0u:= x0u;
  result.Dyu:= Dyu;
  result.y0u:= y0u;

  END;
end;

procedure TOIseq.loadvecFromFile(vec:Tvector;x,y:integer);
var
  i:integer;
  w:smallint;
  p: int64;
begin
  if assigned(fvecfile) then
  begin
    p:=vecPos+Nframe*(x+Nx*y)*4;
    fvecFile().position:=p ;
    fvecFile().read(vec.tbS^,Nframe*4);
    {
    ippsTest;
    ippsConvert(Psmallint(FrameBuf),vec.tbS,Nframe);
    ippsEnd;
    }
  end
  else
  begin
    p:=dataPos+ord(WithRefFrame)*FrameSize+(x+Nx*y)*2;
    if assigned(f0) then
    begin
      for i:=0 to Nframe-1 do
      begin
        f0().position:= p+FrameSize*i;
        f0().Read(w,sizeof(w));
        vec.tbSingle[i]:=w;
      end;
    end;
  end;
end;

procedure TOIseq.loadvecFromMem(vec:Tvector;x,y:integer);
var
  i:integer;
  p:integer;
begin
  p:=y+Ny*x;

  if Not Fcompact then
  case tpNum of
    g_single:  for i:=0 to Nframe-1 do
                 vec.Yvalue[vec.Istart+i]:=PtabSingle(memFrame(i))^[p];
    g_double:  for i:=0 to Nframe-1 do
                 vec.Yvalue[vec.Istart+i]:=PtabDouble(memFrame(i))^[p];
  end
  else
  case tpNum of
    g_single:  for i:=0 to Nframe-1 do
                 vec.Yvalue[vec.Istart+i]:=PtabSingle(MainBuf0)^[p*i];
    g_double:  for i:=0 to Nframe-1 do
                 vec.Yvalue[vec.Istart+i]:=PtabDouble(MainBuf0)^[p*i];
  end;
end;

procedure TOIseq.SaveVecToMem(vec: Tvector; x, y: integer);
var
  i:integer;
  p:integer;
begin
  p:=y+Ny*x;

  case tpNum of
    G_single:  for i:=0 to Nframe-1 do
                  PtabSingle(memFrame(i))^[p]:=vec.Yvalue[vec.Istart+i];
    G_double:  for i:=0 to Nframe-1 do
                  PtabSingle(memFrame(i))^[p]:=vec.Yvalue[vec.Istart+i];
  end;

end;




procedure TOIseq.initFile(f:TgetStream;oi: ToiBlock);
var
  i:integer;
begin
  FinitOK:=false;
  Ffile:=true;
  if not assigned(oi) then exit;

  f0:=f;

  Nx:=oi.Nx;
  Ny:=oi.Ny;
  tpNum:= G_single;
  tpNumFile:=oi.tpNum;

  Nframe:=oi.FrameCount;
  FrameSize:=Nx*Ny*tailleTypeG[tpNumFile];
  dataPos:=oi.posData;
  RSHtext:=oi.getExtraInfo;

  reallocmemG(FrameBuf,FrameSize);

  WithRefFrame:=oi.WithRefFrame;
  if WithRefFrame then
  begin
    matRef.initTemp(0,Nx-1,0,Ny-1,G_single);
    if assigned(f0) then
    begin
      f0().position:= dataPos;
      f0().Read(FrameBuf^,FrameSize);
    end;

    transferData(FrameBuf,matref.tb);
  end;

  initDataMat;

  FinitOK:=true;
end;

procedure TOIseq.initMem(Nx1, Ny1, Nframe1: integer;withref:boolean; tp:typetypeG; const compact:boolean=false);
var
  i:integer;
begin
  freeMainBuf;
  initDataMat;

  FinitOK:=false;
  Ffile:=false;

  Nx:=Nx1;
  Ny:=Ny1;
  tpNum:=tp;
  Nframe:=Nframe1;
  withRefFrame:=withref;

  if WithRefFrame then matRef.initTemp(0,Nx-1,0,Ny-1,tpNum);

  Fcompact:=Compact;
  if Fcompact then
  begin
    if getmemG(pointer(MainBuf0),int64(Nx)*Ny*Nframe*tailleTypeG[tpNum])
      then fillchar(MainBuf0^,Nx*Ny*Nframe*tailleTypeG[tpNum],0);
  end
  else
  begin
    setLength(mainbuf,Nframe);
    for i:=0 to Nframe-1 do
    begin
      if getmemG(pointer(MainBuf[i]),int64(Nx)*Ny*tailleTypeG[tpNum])
        then fillchar(MainBuf[i]^,Nx*Ny*tailleTypeG[tpNum],0);
    end;
  end;
  Fmemory:=true;
  initDataMat;

  FinitOK:=true;
end;

procedure TOIseq.FreeMainBuf;
var
  i:integer;
begin
  for i:=0 to high(mainbuf) do
    freememG(MainBuf[i]);
  setLength(MainBuf,0);

  freememG(MainBuf0);
  MainBuf0:=nil;
  Fcompact:=false;

  FMemory:=false;
  InitDataMat;
end;

procedure TOIseq.setInMemory(w: boolean);
var
  temp:pointer;
  i:integer;
begin
  if not Ffile then exit;

  if w and not Fmemory then
  begin
    setLength(mainbuf,Nframe);
    for i:=0 to Nframe-1 do
    begin
      if getmemG(pointer(MainBuf[i]),int64(Nx)*Ny*sizeof(single))
        then fillchar(MainBuf[i]^,Nx*Ny*sizeof(single),0);
    end;

    getmemG(temp,FrameSize);


    try
    f0().position:= dataPos+ord(withRefFrame)*FrameSize;
    for i:=0 to Nframe-1 do
    begin
      f0().Read(temp^,FrameSize);

      transferData(temp,MainBuf[i]);

      transpose(Mainbuf[i]);
    end;

    finally
    freememG(temp);
    end;
  end
  else
  if not w and Fmemory then FreeMainBuf;

  Fmemory:=w;

  initDataMat;
end;

procedure TOIseq.initDataMat;
var
  i,off0,n:integer;
begin
  if inMemory and (assigned(MainBuf) or assigned(MainBuf0)) then
    for i:=0 to maxPoolMat-1 do
    begin
      n:=curFrame[i];
      if (n<0) or (n>=FrameCount) then n:=0;
      off0:=n*Nx*Ny;
      PoolMat[i].initTempEx(MemFrame(n),0,Nx-1,0,Ny-1,tpNum);
    end
  else
  begin
    for i:=0 to maxPoolMat-1 do
      PoolMat[i].initTemp0(nil,0,Nx-1,0,Ny-1,g_single);
  end;

  for i:=0 to maxPoolMat-1 do
    curFrame[i]:=-1;

  invalidate;
end;



procedure TOIseq.copyOI(oiseq: Toiseq);
var
  i:integer;
begin
  if Ffile then sortieErreur('Toiseq : this object cannot be modified');

  initmem(oiseq.Nx,oiseq.Ny,oiseq.Nframe,oiseq.WithRefFrame,oiseq.tpNum, oiseq.Fcompact);

  if withRefFrame
    then move(oiseq.matRef.tb^,matref.tb^,Nx*Ny*TailleTypeG[tpNum]);

  if oiseq.InMemory then
    for i:=0 to Nframe-1 do
      move(oiseq.memFrame(i)^,memFrame(i)^,Nx*Ny*TailleTypeG[tpNum])
  else
  for i:=0 to Nframe-1 do
    move(oiseq.mat[i].tb^,memFrame(i)^,Nx*Ny*TailleTypeG[tpNum]);
end;

procedure TOIseq.copyFrames(oiseq:Toiseq;f1,f2,fD:integer);
var
  i:integer;
begin
  if Ffile then sortieErreur('Toiseq : this object cannot be modified');

  if (Nx<>oiseq.Nx) or (Ny<>oiseq.Ny) or (tpNum<>oiSeq.tpNum)
    then sortieErreur('Toiseq.copyFrames : image formats are not equal');
  if (f1<0) or (f1>f2) or (f2>=oiseq.Nframe) or (fD<0) or (fD>=Nframe)
    then sortieErreur('Toiseq.copyFrames : bad frame index');

  if fD+f2-f1>=Nframe then f2:=Nframe-1-fD+f1;

  if oiseq.InMemory then
    for i:=0 to f2-f1 do
      move(oiseq.memFrame(i)^,memFrame(fD+i)^,Nx*Ny*TailleTypeG[tpNum])
  else
  for i:=0 to f2-f1 do
    move(oiseq.mat[f1+i].tb^,memFrame(fD+i)^,Nx*Ny*TailleTypeG[tpNum]);
end;

procedure TOIseq.extract(oiseq:Toiseq;i1,i2,j1,j2,f1,f2:integer);
var
  i:integer;

procedure extract1(src,dest:Tmatrix);
var
  i,j:integer;
begin
  for i:=i1 to i2 do
  for j:=j1 to j2 do
    dest[i-i1,j-j1]:=src[i,j];
end;

begin
  if Ffile then sortieErreur('Toiseq : this object cannot be modified');

  if (i1<0) or (i1>i2) or (i2>=oiseq.Nx) or
     (j1<0) or (j1>j2) or (j2>=oiseq.Ny)
   then sortieErreur('Toiseq.copyFrames : bad image bounds');

  if (f1<0) or (f1>f2) or (f2>=oiseq.Nframe)
    then sortieErreur('Toiseq.copyFrames : bad frame index');


  initmem(i2-i1+1,j2-j1+1,f2-f1+1, oiseq.WithRefFrame,oiseq.tpNum,oiseq.Fcompact);

  if withRefFrame
    then extract1(oiseq.matref,matref);

  for i:=0 to f2-f1 do
    extract1(oiseq.mat[f1+i],mat[i]);
end;

procedure TOIseq.Add(oiseq:Toiseq);
var
  FlagMem:boolean;
  i:integer;
begin
  if Ffile then sortieErreur('Toiseq : this object cannot be modified');

  flagMem:=oiseq.InMemory;
  if not flagMem then oiseq.InMemory:=true;

  ippsTest;
  case tpnum of
    g_single: for i:=0 to Nframe-1 do
                ippsAdd_32f_I(Psingle(oiseq.memFrame(i)),Psingle(memFrame(i)),Nx*Ny);
    g_double: for i:=0 to Nframe-1 do
                ippsAdd_64f_I(Pdouble(oiseq.memFrame(i)),Pdouble(memFrame(i)),Nx*Ny);
  end;
  ippsEnd;

  if not flagMem then oiseq.InMemory:=false;
end;

procedure TOIseq.Sub(oiseq:Toiseq);
var
  FlagMem:boolean;
  i:integer;
begin
  if Ffile then sortieErreur('Toiseq : this object cannot be modified');

  flagMem:=oiseq.InMemory;
  if not flagMem then oiseq.InMemory:=true;

  ippsTest;
  case tpNum of
    g_single: for i:=0 to Nframe-1 do
                ippsSub_32f_I(Psingle(oiseq.memFrame(i)),Psingle(memFrame(i)),Nx*Ny);
    g_double: for i:=0 to Nframe-1 do
                ippsSub_64f_I(Pdouble(oiseq.memFrame(i)),Pdouble(memFrame(i)),Nx*Ny);
  end;

  ippsEnd;

  if not flagMem then oiseq.InMemory:=false;
end;


procedure TOIseq.AddNum(w:float);
var
  i:integer;
begin
  if Ffile then sortieErreur('Toiseq : this object cannot be modified');

  ippsTest;
  case tpNum of
    g_single: for i:=0 to Nframe-1 do
                ippsAddC_32f_I(w,Psingle(memFrame(i)),Nx*Ny);
    g_double: for i:=0 to Nframe-1 do
                ippsAddC_64f_I(w,Pdouble(memFrame(i)),Nx*Ny);
  end;
  ippsEnd;
end;


procedure TOIseq.MulNum(w:float);
var
  i:integer;
begin
  if Ffile then sortieErreur('Toiseq : this object cannot be modified');

  ippsTest;
  case tpNum of
    g_single: for i:=0 to Nframe-1 do
                ippsmulC_32f_I(w,Psingle(memFrame(i)),Nx*Ny);
    g_double: for i:=0 to Nframe-1 do
                ippsmulC_64f_I(w,Pdouble(memFrame(i)),Nx*Ny);
  end;
  ippsEnd;
end;

procedure TOIseq.Mul(oiseq: Toiseq);
var
  FlagMem:boolean;
  i:integer;
begin
  if Ffile then sortieErreur('Toiseq : this object cannot be modified');

  flagMem:=oiseq.InMemory;
  if not flagMem then oiseq.InMemory:=true;

  ippsTest;
  case tpNum of
    g_single: for i:=0 to Nframe-1 do
                ippsAdd_32f_I(Psingle(oiseq.memFrame(i)),Psingle(memFrame(i)),Nx*Ny);
    g_double: for i:=0 to Nframe-1 do
                ippsAdd_64f_I(Pdouble(oiseq.memFrame(i)),Pdouble(memFrame(i)),Nx*Ny);
  end;
  ippsEnd;

  if not flagMem then oiseq.InMemory:=false;
end;


procedure TOIseq.Div1(oiseq: Toiseq; th, value: float);
var
  FlagMem:boolean;
  i,j,k:integer;
  w:double;
begin
  if Ffile then sortieErreur('Toiseq : this object cannot be modified');

  flagMem:=oiseq.InMemory;
  if not flagMem then oiseq.InMemory:=true;

  for i:=0 to Nx-1 do
  for j:=0 to Ny-1 do
  for k:=0 to Nframe-1 do
  begin
    w:= oiseq.mat[k][i,j];
    if abs(w)<th
      then mat[k][i,j]:=value
      else mat[k][i,j]:= mat[k][i,j]/w;
  end;

  if not flagMem then oiseq.InMemory:=false;
end;




procedure TOIseq.fill(w: float);
var
  i:integer;
begin
  if Ffile then sortieErreur('Toiseq : this object cannot be modified');

  ippsTest;
  for i:=0 to Nframe-1 do
    if w=0
      then ippszero_32f(Psingle(memFrame(i)),Nx*Ny)
      else ippsSet_32f(w,Psingle(memFrame(i)),Nx*Ny);
  ippsEnd;
end;


procedure TOIseq.SaveToVec(vec:Tvector);
begin
end;

procedure TOIseq.LoadFromVec(vec:Tvector);
begin
end;



procedure TOIseq.Display;
var
  m:Tmatrix;

  visu1:TvisuInfo;
  degP1:typeDegre;
  FpalName1:AnsiString;
  wf1:TWFoptions;

  rectI:Trect;
  x1,y1,x2,y2:integer;

begin
  GdispToWorld(Gdisp,xdisp,ydisp);
  // Modifie le world pour tenir compte de l'aspect ratio
  // l'affichage doit donc être en keepratio:=false;

  m:=Mat[index];
  if assigned(m) then
  begin
    visu1.init;
    visu1.assign(m.visu);
    degP1:=m.degP;
    FpalName1:=m.PalName;
    wf1:=m.wf;

    m.visu.assign(visu);
    if not DisplayAsMatrix then m.visu.keepRatio:=false;
    m.degP:=degP;
    m.palname:=palName;

    m.Transparent:=Transparent;
    m.TransparentValue:= TransparentValue;

    if not DisplayAsMatrix then m.display
    else
    begin
      getWindowG(x1,y1,x2,y2);
      with m.visu.getInsideT do setWindow(left,top,right,bottom);
      m.displayInside(nil,false,false,false);
      m.visu.displayScale;
      setWindow(x1,y1,x2,y2);
    end;

    m.visu.assign(visu1);
    m.degP:=degP1;
    m.palName:=FPalName1;
    m.wf:=wf1;
  end;

end;

procedure TOIseq.displayInside(FirstUO:typeUO;extWorld,logX,logY:boolean;
                               const order:integer=-1);
var
  m:Tmatrix;

  visu1:TvisuInfo;
  degP1:typeDegre;
  FpalName1:AnsiString;
  wf1:TWFoptions;

begin
  GdispToWorld(Gdisp,xdisp,ydisp);
  m:=mat[index];
  if assigned(m) then
  begin
    visu1.init;
    visu1.assign(m.visu);
    degP1:=m.degP;
    FpalName1:=m.PalName;
    wf1:=m.wf;

    m.visu.assign(visu);
    if not DisplayAsMatrix then m.visu.keepRatio:=false;
    m.degP:=degP;
    m.palname:=palName;
    m.Transparent:=Transparent;
    m.TransparentValue:= TransparentValue;

    m.DisplayInside(nil,extWorld,logX,logY);

    m.visu.assign(visu1);
    m.degP:=degP1;
    m.palName:=FPalName1;
    m.wf:=wf1;
  end;

end;

function TOIseq.getInsideWindow:Trect;
var
  m:Tmatrix;
  visu1:TvisuInfo;
  degP1:typeDegre;
  FpalName1:AnsiString;
  wf1:TWFoptions;

begin
  m:=mat[index];
  if assigned(m) then
  begin
    visu1.init;                       // sauver m.visu
    visu1.assign(m.visu);
    degP1:=m.degP;
    FpalName1:=m.PalName;
    wf1:=m.wf;

    m.visu.assign(visu);              // visu dans m
    if not DisplayAsMatrix then m.visu.keepRatio:=false;
    m.degP:=degP;
    m.palname:=palName;
    m.Transparent:=Transparent;
    m.TransparentValue:= TransparentValue;

    result:=m.getInsideWindow;

    m.visu.assign(visu1);             // restaurer m.visu
    m.degP:=degP1;
    m.palName:=FPalName1;
    m.wf:=wf1;
  end;

end;

procedure TOIseq.cadrerZ(sender:Tobject);
var
  i:integer;
  z1,z2:float;
begin
  if Nframe<1 then exit;

  z1:=1E200;
  z2:=-1E200;

  for i:=0 to Nframe-1 do
  begin
    Mat[i].getMinMax(z1,z2);
    if testEscape then break;
  end;

  if (z1<>1E200) and (z2<>-1E200) then
  begin
    visu0^.Zmin:=z1;
    visu0^.Zmax:=z2;
  end;

end;

procedure TOIseq.autoscaleZ;
begin
  autoscaleZ1(false);
end;


procedure TOIseq.autoscaleZ1(allFrames:boolean);
var
  i:integer;
  z1,z2:float;
begin
  if Nframe<1 then exit;

  z1:=1E200;
  z2:=-1E200;

  if allFrames then
  for i:=0 to Nframe-1 do
  begin
    Mat[i].getMinMax(z1,z2);
    if testEscape then break;
  end
  else Mat[index].getMinMax(z1,z2);

  if (z1<>1E200) and (z2<>-1E200) then
  begin
    Zmin:=z1;
    Zmax:=z2;
  end;
end;

procedure TOIseq.AutoScaleZsym;
var
  i:integer;
  Vmin,Vmax:float;
begin
  Vmin:=1E20;
  Vmax:=-1E20;
  getMinMax(Vmin,Vmax);

  if abs(Vmin)<abs(Vmax) then
    begin
      Zmin:=-abs(Vmax);
      Zmax:=abs(Vmax);
    end
  else
    begin
      Zmin:=-abs(Vmin);
      Zmax:=abs(Vmin);
    end;
end;


function TOiseq.ChooseCoo1:boolean;

function ChooseCoo2:boolean;
var
  chg:boolean;
  title0:AnsiString;
  palName0:AnsiString;
  wf0:TwfOptions;
  degP0:typeDegre;

begin
  InitVisu0;
  title0:=title;
  palName0:=palName;
  wf0:=wf;
  degP0:=degP;

  if Matcood.choose(title0,visu0^,palName0,@wf,degP0,cadrerX,cadrerY,cadrerZ,cadrerC) then
    begin
      chg:= not visu.compare(visu0^) or (title<>title0)
            or (palName0<>palName) or not compareMem(@wf,@wf0,sizeof(wf))
            or not Comparemem(@degP,@degP0,sizeof(degP));
      visu.assign(visu0^);
      title:=title0;
      palName:=palName0;
      degP:=degP0;
    end
  else chg:=false;

  DoneVisu0;
  result:=chg;
end;

begin
  if DisplayAsMatrix then result:= ChooseCoo2
  else
  result:=OIcood.choose(self,recBMplot.Ftransparent,recBMplot.FtransparentValue);
end;

procedure TOIseq.setPalColor(n:integer;x:integer);
var
  i:integer;
begin
  case n of
    1:TmatColor(visu.Color).col1:=x;
    2:TmatColor(visu.Color).col2:=x;
  end;
end;

function TOIseq.getPalColor(n:integer):integer;
begin
  case n of
    1:result:=TmatColor(visu.Color).col1;
    2:result:=TmatColor(visu.Color).col2;
  end;
end;

function TOIseq.getSelected(num:integer):boolean;
begin
  result:=(num>=0) and (num<length(Fselected)) and Fselected[num];
end;


procedure TOIseq.setSelected(num:integer;w:boolean);
begin
  if num>=length(Fselected) then setLength(Fselected,num+1);
  Fselected[num]:=w;
end;

procedure TOIseq.getMinMax(var Vmin,Vmax:float);
var
  i:integer;
begin
  for i:=0 to Nframe-1 do mat[i].getMinMax(Vmin,Vmax);
end;


function TOIseq.getIend: integer;
begin
  result:=Nx-1;
end;

function TOIseq.getJend: integer;
begin
  result:=Ny-1;
end;

procedure TOIseq.setIndex(n: integer);
var
  old:integer;
begin
  old:=Findex;
  if n<0 then Findex:=0
  else
  if n>=Nframe then Findex:=Nframe-1
  else Findex:=n;
  if Findex<>old then checkCpIndex;
end;


procedure TOIseq.BuildVectorFromRect(i1,i2,j1,j2: integer; vec:Tvector; const mode:integer=0);
var
  i,j:integer;
  m:Tmatrix;
  mreg:Tmatrix;
  p: Tpoint;
  mask: pointer;
  res: integer;
  ws: single;
  wd: double;
  PixCnt:integer;
begin
  vec.modify(vec.tpNum,0,Nframe-1);

  m:=getmat(0);
  mreg:=Tmatrix(m.clone(false));

  if i1<m.Istart then i1:= m.Istart;
  if i2>m.Iend then i2:= m.Iend;
  if j1<m.Jstart then j1:= m.Jstart;
  if j2>m.Jend then j2:= m.Jend;


  PixCnt:= (i2-i1+1)*(j2-j1+1);
  if pixCnt<=0 then
  begin
    mreg.free;
    exit;
  end;

  for i:=i1 to i2 do
  for j:=j1 to j2 do
    mreg[i,j]:=1;

  case tpNum of
    g_single:  mask:=@PtabSingle(mreg.tb)^[i1*Ny];
    g_double:  mask:=@PtabDouble(mreg.tb)^[i1*Ny];
  end;

  if mode=1 then PixCnt:=1;

  for i:=0 to Nframe-1 do
  begin
    m:=getmat(i);
    case tpNum of
      g_single: begin
                  res:= IppsDotProd_32f(Psingle(@PtabSingle(m.tb)^[i1*Ny]),Psingle(mask), (i2-i1+1)*Ny, @ws);
                  if res=0 then vec[i]:=ws/PixCnt else vec[i]:=0;
                end;

      g_double: begin
                  res:= IppsDotProd_64f(Pdouble(@PtabDouble(m.tb)^[i1*Ny]),Pdouble(mask), (i2-i1+1)*Ny, @wd);
                  if res=0 then vec[i]:=wd/PixCnt else vec[i]:=0;
                end;

      else vec[i]:=0;
    end;

  end;

  mreg.free;
end;


procedure TOIseq.BuildVector(reg: Treg; vec: TVector; const mode: integer=0);
// mode= 0 : on range la moyenne des pixels
// mode= 1 : on range la somme
var
  i:integer;
  m:Tmatrix;
  mreg:Tmatrix;
  x1,x2: integer;
  p: Tpoint;
  mask: pointer;
  res: integer;
  ws: single;
  wd: double;
  PixCnt:integer;
  nb:integer;
begin
  vec.modify(vec.tpNum,0,Nframe-1);

  m:=getmat(0);
  mreg:=Tmatrix(m.clone(false));

  reg.BuildPixList(Dxu,x0u,Dyu,y0u);
  x1:=maxEntierLong;
  x2:=minEntierLong;
  {
  for i:= mreg.Istart to mreg.Iend do
  for j:= mreg.Jstart to mreg.Jend do
    if reg.PtInRegion(regConvxR(i),regConvyR(j)) then mreg[i,j]:=1;
  }


  PixCnt:= reg.PixCount;

  nb:=0;
  for i:=0 to PixCnt-1 do
    begin
      p:=reg.getPixel(i);
      if (p.x>=m.Istart) and (p.x<=m.Iend) and (p.y>=m.Jstart) and (p.y<=m.Jend) then
      begin
        mreg[p.X,p.Y]:=1;
        if p.x<x1 then x1:=p.x;
        if p.x>x2 then x2:=p.x;
        inc(nb);
      end;
    end;
  PixCnt:=nb;
  if PixCnt=0 then
  begin
    mreg.free;
    exit;
  end;

  case tpNum of
    g_single:  mask:=@PtabSingle(mreg.tb)^[x1*Ny];
    g_double:  mask:=@PtabDouble(mreg.tb)^[x1*Ny];
  end;


  if mode=1 then PixCnt:=1; // dans ce cas, la somme est rangée dans vec

  for i:=0 to Nframe-1 do
  begin
    m:=getmat(i);
    case tpNum of
      g_single: begin
                  res:= IppsDotProd_32f(Psingle(@PtabSingle(m.tb)^[x1*Ny]),Psingle(mask), (x2-x1+1)*Ny, @ws);
                  if res=0 then vec[i]:=ws/PixCnt else vec[i]:=0;
                end;

      g_double: begin
                  res:= IppsDotProd_64f(Pdouble(@PtabDouble(m.tb)^[x1*Ny]),Pdouble(mask), (x2-x1+1)*Ny, @wd);
                  if res=0 then vec[i]:=wd/PixCnt else vec[i]:=0;
                end;

      else vec[i]:=0;
    end;

  end;

  mreg.free;
end;


procedure TOIseq.BuildVectors(regList: TregionList; vecList: TVlist; const mode: integer=0);
var
  vec:Tvector;
  i,j,rr:integer;
  m:Tmatrix;
  mreg: array of Tmatrix;
  x1,x2: array of integer;
  p: Tpoint;
  mask: array of pointer;
  res: integer;
  ws: single;
  wd: double;
  PixCnt:array of integer;
  Nb: integer;
  Nreg:integer;
  Knorm: double;
begin
  vecList.clear;

  Nreg:= regList.regList.count;
  setLength(mreg, Nreg);
  setLength(x1, Nreg);
  setLength(x2, Nreg);
  setLength(mask, Nreg);
  setLength(PixCnt, Nreg);

  regList.regList.BuildPixLists(dxu,x0u,dyu,y0u);
  m:=getmat(0);

  for rr:=0 to Nreg-1 do
  begin
    vec:=Tvector.create;
    vec.initTemp1(0,Nframe-1,g_single);
    vecList.addClone(vec);

    mreg[rr]:=Tmatrix(m.clone(false));

    x1[rr]:=maxEntierLong;
    x2[rr]:=minEntierLong;

    PixCnt[rr]:= reglist.regList[rr].PixCount;
    //if PixCnt=0 then exit;

    nb:=0;
    for i:=0 to PixCnt[rr]-1 do
      begin
        p:=reglist.regList[rr].getPixel(i);
        if (p.x>=m.Istart) and (p.x<=m.Iend) and (p.y>=m.Jstart) and (p.y<=m.Jend) then
        begin
          mreg[rr][p.X,p.Y]:=1;
          if p.x<x1[rr] then x1[rr]:=p.x;
          if p.x>x2[rr] then x2[rr]:=p.x;
          inc(nb);
        end;
      end;
    PixCnt[rr]:=nb;

    if nb>0 then
    case tpNum of
      g_single:  mask[rr]:=@PtabSingle(mreg[rr].tb)^[x1[rr]*Ny];
      g_double:  mask[rr]:=@Ptabdouble(mreg[rr].tb)^[x1[rr]*Ny];
    end;
  end;

  case mode of
    0:  Knorm:= PixCnt[rr];
    1:  Knorm:= 1;
  end;

  for i:=0 to Nframe-1 do
  begin
    m:=getmat(i);
    case tpNum of
      g_single: begin
                  for rr:=0 to Nreg-1 do
                  if PixCnt[rr]>0 then
                  begin
                    res:= IppsDotProd_32f(Psingle(@PtabSingle(m.tb)^[x1[rr]*Ny]),Psingle(mask[rr]), (x2[rr]-x1[rr]+1)*Ny, @ws);
                    if res=0 then vecList.Vectors[1+rr][i]:=ws/Knorm else vecList.Vectors[1+rr][i]:=0;
                  end;
                end;

      g_double: begin
                  for rr:=0 to Nreg-1 do
                  if PixCnt[rr]>0 then
                  begin
                    res:= IppsDotProd_64f(Pdouble(@PtabDouble(m.tb)^[x1[rr]*Ny]),PDouble(mask[rr]), (x2[rr]-x1[rr]+1)*Ny, @wd);
                    if res=0 then vecList.Vectors[1+rr][i]:=wd/Knorm else vecList.Vectors[1+rr][i]:=0;
                  end;
                end;

      else vecList.Vectors[1+rr][i]:=0;
    end;

  end;

  for i:=0 to Nreg-1 do mreg[i].free;
end;


procedure TOIseq.CheckCpIndex;
var
  i:integer;
begin
  if CpIndex=0 then exit;
  for i:=0 to OIlist.count-1 do
  with TOIseq(OIlist[i]) do
  begin
    if CpIndex=self.CpIndex then
    begin
      index:=self.index;
      invalidate;
    end;
  end;
end;

procedure TOIseq.transpose(p:pointer);
var
  i,j:integer;
  w:single;
  p1,p2:PtabSingle;
begin
  getmem(p1,Nx*Ny*sizeof(single));
  p2:=p;
  move(p2^,p1^,Nx*Ny*sizeof(single));
  for i:=0 to Nx-1 do
  for j:=0 to Ny-1 do
    p2^[j+ny*i]:=p1^[i+nx*j];

  freemem(p1);
end;

procedure TOIseq.test;
var
  i:integer;
begin

end;

procedure TOIseq.loadImage(st: AnsiString);
begin
end;

procedure TOIseq.saveImage(st: AnsiString; format, quality: integer);
begin

end;

procedure TOIseq.saveImage(st: AnsiString; format, quality, x1, y1, x2, y2: integer);
begin

end;

procedure TOIseq.saveToMem(t:pointer; tpdest:typetypeG; LineFirst:boolean);
var
  i,j,k:integer;
begin
  if not LineFirst then
  case tpDest of
    G_byte:         for k:=0 to Nframe-1 do
                    with mat[k] do
                    for i:=0 to Nx-1 do
                    for j:=0 to Ny-1 do
                      PtabOctet(t)^[j+Ny*i +Nx*Ny*k ]:=Kvalue[i,j];

    G_short:        for k:=0 to Nframe-1 do
                    with mat[k] do
                    for i:=0 to Nx-1 do
                    for j:=0 to Ny-1 do
                      PtabShort(t)^[j+Ny*i +Nx*Ny*k ]:=Kvalue[i,j];

    G_smallint:     for k:=0 to Nframe-1 do
                    with mat[k] do
                    for i:=0 to Nx-1 do
                    for j:=0 to Ny-1 do
                      PtabEntier(t)^[j+Ny*i +Nx*Ny*k ]:=Kvalue[i,j];

    G_word:         for k:=0 to Nframe-1 do
                    with mat[k] do
                    for i:=0 to Nx-1 do
                    for j:=0 to Ny-1 do
                      PtabWord(t)^[j+Ny*i +Nx*Ny*k ]:=Kvalue[i,j];

    G_longint:      for k:=0 to Nframe-1 do
                    with mat[k] do
                    for i:=0 to Nx-1 do
                    for j:=0 to Ny-1 do
                      PtabLong(t)^[j+Ny*i +Nx*Ny*k ]:=Kvalue[i,j];

    G_single,
    G_singleComp:   for k:=0 to Nframe-1 do
                    with mat[k] do
                    for i:=0 to Nx-1 do
                    for j:=0 to Ny-1 do
                      PtabSingle(t)^[j+Ny*i +Nx*Ny*k ]:=Zvalue[i,j];
    G_double,
    G_doubleComp,
    G_real,
    G_extended:     for k:=0 to Nframe-1 do
                    with mat[k] do
                    for i:=0 to Nx-1 do
                    for j:=0 to Ny-1 do
                      PtabDouble(t)^[j+Ny*i +Nx*Ny*k ]:=Zvalue[i,j];
  end
  else
    case tpDest of
    G_byte:         for k:=0 to Nframe-1 do
                    with mat[k] do
                    for i:=0 to Nx-1 do
                    for j:=0 to Ny-1 do
                      PtabOctet(t)^[i+Nx*j +Nx*Ny*k ]:=Kvalue[i,j];

    G_short:        for k:=0 to Nframe-1 do
                    with mat[k] do
                    for i:=0 to Nx-1 do
                    for j:=0 to Ny-1 do
                      PtabShort(t)^[i+Nx*j +Nx*Ny*k ]:=Kvalue[i,j];

    G_smallint:     for k:=0 to Nframe-1 do
                    with mat[k] do
                    for i:=0 to Nx-1 do
                    for j:=0 to Ny-1 do
                      PtabEntier(t)^[i+Nx*j +Nx*Ny*k ]:=Kvalue[i,j];

    G_word:         for k:=0 to Nframe-1 do
                    with mat[k] do
                    for i:=0 to Nx-1 do
                    for j:=0 to Ny-1 do
                      PtabWord(t)^[i+Nx*j +Nx*Ny*k ]:=Kvalue[i,j];

    G_longint:      for k:=0 to Nframe-1 do
                    with mat[k] do
                    for i:=0 to Nx-1 do
                    for j:=0 to Ny-1 do
                      PtabLong(t)^[i+Nx*j +Nx*Ny*k ]:=Kvalue[i,j];

    G_single,
    G_singleComp:   for k:=0 to Nframe-1 do
                    with mat[k] do
                    for i:=0 to Nx-1 do
                    for j:=0 to Ny-1 do
                      PtabSingle(t)^[i+Nx*j +Nx*Ny*k ]:=Zvalue[i,j];
    G_double,
    G_doubleComp,
    G_real,
    G_extended:     for k:=0 to Nframe-1 do
                    with mat[k] do
                    for i:=0 to Nx-1 do
                    for j:=0 to Ny-1 do
                      PtabDouble(t)^[i+Nx*j +Nx*Ny*k ]:=Zvalue[i,j];
  end

end;

procedure TOIseq.LoadFromMem(t:pointer; tpdest:typetypeG; LineFirst:boolean);
var
  i,j,k:integer;
begin
    if not LineFirst then
    case tpDest of
      G_byte:    for k:=0 to Nframe-1 do
                      with mat[k] do
                      for i:=0 to Nx-1 do
                      for j:=0 to Ny-1 do
                        Zvalue[i,j]:=PtabOctet(t)^[j+Ny*i +Nx*Ny*k ];
      G_short:   for k:=0 to Nframe-1 do
                      with mat[k] do
                      for i:=0 to Nx-1 do
                      for j:=0 to Ny-1 do
                        Zvalue[i,j]:=PtabShort(t)^[j+Ny*i +Nx*Ny*k ];
      G_word:    for k:=0 to Nframe-1 do
                      with mat[k] do
                      for i:=0 to Nx-1 do
                      for j:=0 to Ny-1 do
                        Zvalue[i,j]:=Ptabword(t)^[j+Ny*i +Nx*Ny*k ];
      G_smallint:for k:=0 to Nframe-1 do
                      with mat[k] do
                      for i:=0 to Nx-1 do
                      for j:=0 to Ny-1 do
                        Zvalue[i,j]:=PtabEntier(t)^[j+Ny*i +Nx*Ny*k ];
      G_longint: for k:=0 to Nframe-1 do
                      with mat[k] do
                      for i:=0 to Nx-1 do
                      for j:=0 to Ny-1 do
                        Zvalue[i,j]:=PtabLong(t)^[j+Ny*i +Nx*Ny*k ];
      G_single:  for k:=0 to Nframe-1 do
                      with mat[k] do
                      for i:=0 to Nx-1 do
                      for j:=0 to Ny-1 do
                        Zvalue[i,j]:=PtabSingle(t)^[j+Ny*i +Nx*Ny*k ];
      G_double:  for k:=0 to Nframe-1 do
                      with mat[k] do
                      for i:=0 to Nx-1 do
                      for j:=0 to Ny-1 do
                        Zvalue[i,j]:=PtabDouble(t)^[j+Ny*i +Nx*Ny*k ];
    end
    else
    case tpDest of
      G_byte:    for k:=0 to Nframe-1 do
                      with mat[k] do
                      for i:=0 to Nx-1 do
                      for j:=0 to Ny-1 do
                        Zvalue[i,j]:=PtabOctet(t)^[i+Nx*j +Nx*Ny*k ];
      G_short:   for k:=0 to Nframe-1 do
                      with mat[k] do
                      for i:=0 to Nx-1 do
                      for j:=0 to Ny-1 do
                        Zvalue[i,j]:=PtabShort(t)^[i+Nx*j +Nx*Ny*k ];
      G_word:    for k:=0 to Nframe-1 do
                      with mat[k] do
                      for i:=0 to Nx-1 do
                      for j:=0 to Ny-1 do
                        Zvalue[i,j]:=Ptabword(t)^[i+Nx*j +Nx*Ny*k ];
      G_smallint:for k:=0 to Nframe-1 do
                      with mat[k] do
                      for i:=0 to Nx-1 do
                      for j:=0 to Ny-1 do
                        Zvalue[i,j]:=PtabEntier(t)^[i+Nx*j +Nx*Ny*k ];
      G_longint: for k:=0 to Nframe-1 do
                      with mat[k] do
                      for i:=0 to Nx-1 do
                      for j:=0 to Ny-1 do
                        Zvalue[i,j]:=PtabLong(t)^[i+Nx*j +Nx*Ny*k ];
      G_single:  for k:=0 to Nframe-1 do
                      with mat[k] do
                      for i:=0 to Nx-1 do
                      for j:=0 to Ny-1 do
                        Zvalue[i,j]:=PtabSingle(t)^[i+Nx*j +Nx*Ny*k ];
      G_double:  for k:=0 to Nframe-1 do
                      with mat[k] do
                      for i:=0 to Nx-1 do
                      for j:=0 to Ny-1 do
                        Zvalue[i,j]:=PtabDouble(t)^[i+Nx*j +Nx*Ny*k ];
    end
end;

function TOIseq.getMxArray(Const tpdest0:typetypeG = G_none):MxArrayPtr;
var
  complexity:mxComplexity;
  classID:mxClassID;
  t:pointer;
  i,j,k:integer;
  tpDest:typetypeG;
  dims:array[1..3] of integer;
begin
  result:=nil;
  if not testMatlabMat then exit;
  if not testMatlabMatrix then exit;

  if (Nx<=0) or (Ny<=0) or (Nframe<=0) then
  begin
    sortieErreur('TOIseq to MxArray: source is empty');
    exit;
  end;

  if tpDest0=G_none
    then tpDest:=g_single
    else tpDest:=tpDest0;

  if not (tpDest in MatlabTypes) then
  begin
    sortieErreur('TOIseq to MxArray: invalid type');
    exit;
  end;

  classId:=TpNumToClassId(tpDest);
  complexity:=tpNumToComplexity(tpDest);

  dims[1]:= Ny;
  dims[2]:= Nx;
  dims[3]:= Nframe;

  result:=mxCreateNumericArray(3,@dims,classID,complexity);
  if result=nil then
  begin
    sortieErreur('TOIseq to MxArray : error 1');
    exit;
  end;
  t:= mxGetPr(result);
  if t=nil then
  begin
    sortieErreur('TOIseq to MxArray : error 2');
    exit;
  end;

  SaveToMem(t,tpDest,false);



end;

procedure TOISeq.setMxArray(mxArray:MxArrayPtr;Const invertIndices:boolean=false);
var
  classID:mxClassID;
  isComp:boolean;
  t:pointer;
  tp:typetypeG;
  Ndim,nb1,nb2,nb3:integer;
  pNb:PtabLong1;

  i,j,k:integer;
begin
  if not assigned(mxArray) then exit;

  classID:=mxGetClassID(mxArray);

  tp:=g_single;

  Ndim:=mxgetNumberOfDimensions(mxArray);
  pNb:=mxgetDimensions(mxArray);

  if Ndim<2 then exit;

  nb1:=pNb^[1];
  nb2:=pNb^[2];
  if Ndim>=3
    then nb3:=pNb^[3]
    else nb3:=1;

  t:= mxGetPr(mxArray);

  if assigned(t) and (Nb1>0) and (Nb2>0) and (nb3>0) then
  begin
    initMem(nb2,nb1,nb3,false,tpNum,Fcompact);
    LoadFromMem(t,ClassIdToTpNum(classId,false),false);
  end;

end;



procedure TOIseq.BuildInfo(var conf: TblocConf; lecture, tout: boolean);
begin
  inherited;

  with conf do
  begin
    setvarConf('Nx',Nx,sizeof(Nx));
    setvarConf('Ny',Ny,sizeof(Ny));
    setvarConf('Nframe',Nframe,sizeof(Nframe));
    setvarConf('WithRef',WithRefFrame,sizeof(WithrefFrame));
    setStringConf('PalName',FpalName);
    setvarConf('tpnum',tpnum,sizeof(tpNum));
    setvarConf('Compact',Fcompact,sizeof(Fcompact));
    setvarConf('OIscale',OIscaleProp,sizeof(OIscaleProp));

  end;


end;

procedure TOIseq.completeLoadInfo;
begin
  inherited;
  if not (self is TOIseqPCL) then  initmem(Nx,Ny,Nframe,withrefFrame,tpNum);
end;


procedure TOIseq.saveData(f: Tstream);
var
  size,i:integer;
begin
  size:=Nx*Ny*Nframe*sizeof(single);
  writeDataHeader(f,size);

  if inMemory then
    for i:=0 to Nframe-1 do
      f.Write(MemFrame(i)^,Nx*Ny*sizeof(single))
  else
  for i:=0 to Nframe-1 do
  with mat[i] do
      f.Write(tb^,Nx*Ny*sizeof(single));
end;

function TOIseq.loadData(f: Tstream): boolean;
var
  size,i:integer;
begin
  result:=readDataHeader(f,size);
  if result=false then exit;

  if size=0 then
    size:=Nx*Ny*Nframe*sizeof(single);
  if size<>Nx*Ny*Nframe*sizeof(single) then exit;

  if inMemory then
    for i:=0 to Nframe-1 do
      f.read(MemFrame(i)^,Nx*Ny*sizeof(single));

end;

procedure TOIseq.getV(x, y: integer; vec: Tvector);
begin
  vec.modify(g_single,0,Nframe-1);
  if inMemory
    then loadVecFromMem(vec,x,y)
    else loadVecFromFile(vec,x,y);
end;

procedure TOIseq.setV(x, y: integer; vec: Tvector);
begin
  if inMemory then saveVecToMem(vec,x,y);
end;

procedure TOIseq.BuildVecFile(f:Tstream);
var
  i:integer;
  src,dest:Ptabentier;
  dest1:PtabSingle;
  destLen,phase:longint;
begin


 ippsTest;

 try
 src:=nil;
 dest:=nil;
 dest1:=nil;
 src:=ippsMalloc(Nx*Ny*Nframe*2);
 dest:=ippsMalloc(Nx*Ny*Nframe*2);
 dest1:=ippsMalloc(Nx*Ny*Nframe*4);

 f0().position:= dataPos+ord(WithRefFrame)*FrameSize;
 f0().Read(src^,Nx*Ny*Nframe*2);


 for i:=0 to Nx*Ny-1 do
 begin
   phase:=i;
   destlen:=Nframe;
   ippsSampleDown_16s(Psmallint(src),Nx*Ny*Nframe,Psmallint(@dest^[Nframe*i]),@destlen,Nx*Ny,@phase);
 end;

 ippsConvert_16s32f(Psmallint(dest),Psingle(dest1),Nx*Ny*Nframe);


 f.WriteBuffer(dest1^,Nx*Ny*Nframe*4);

 finally
 ippsFree(src);
 ippsFree(dest);
 ippsFree(dest1);
 ippsEnd;
 end;


end;

procedure TOIseq.setVecFile(f: TgetStream;var offset:int64);
begin
  fVecFile:=f;
  vecPos:=offset;
  offset:=offset+Nx*Ny*Nframe*4;
end;

procedure TOIseq.OIVconvolve(Hf: Tvector; src, dest: AnsiString);
var
  fs,fd:TfileStream;
  nbvec,tStart:integer;
  i:integer;
  tbSrc,tbDest,tbHfR,tbHFI:array of single;
begin
  fs:=TfileStream.create(src,fmOpenRead);
  fd:=TfileStream.create(dest,fmcreate);

  try

  IPPStest;
  setlength(tbSrc,Nframe);

  setlength(tbHfR,Hf.Icount);
  setlength(tbHfI,Hf.Icount);

  for i:=0 to HF.Icount-1 do
  begin
    tbHfR[i]:=Hf.Yvalue[Hf.Istart+i];
    tbHfI[i]:=Hf.Imvalue[Hf.Istart+i];
  end;

  tStart:=-Hf.Istart;

  setLength(tbDest,Nframe+Hf.Icount);

  Nbvec:=fs.size div (Nframe*4);

  for i:=0 to nbvec-1 do
  begin
    fs.ReadBuffer(tbSrc[0],Nframe*4);

    Conv32f(Psingle(@tbSrc[0]),Nframe,Psingle(@tbHfR[0]),length(tbHfR),Psingle(@tbDest[0]));
    fd.WriteBuffer(tbDest[tStart],Nframe*4);

    Conv32f(Psingle(@tbSrc[0]),Nframe,Psingle(@tbHfI[0]),length(tbHfI),Psingle(@tbDest[0]));
    fd.WriteBuffer(tbDest[tStart],Nframe*4);
  end;

  finally
  fs.free;
  fd.free;
  IPPSend;
  end;
end;

function compare(Item1, Item2: Pointer): Integer;
begin
  if intG(item1)<intG(item2) then result:=1
  else
  if intG(item1)=intG(item2) then result:=0
  else result:=-1;
end;

procedure TOIseq.OIVaverage(vecStim: Tvector; src, destMoy, destStd: AnsiString);
var
  fs,fD:TfileStream;
  Nep,Nstim,Nseq:integer;
  stimList:Tlist;
  i,j,k:integer;
  Sz,Sz2:array of single;
  tbSrc:array of single;
  stim:integer;
begin

  fs:=TfileStream.create(src,fmOpenRead);
  IPPStest;

  try
  Nep:=fs.size div (Nx*Ny*Nframe*4);
  if vecStim.Icount<>Nep then exit;

  {Analyse de VecStim}
  Stimlist:=Tlist.create;
  for i:=vecStim.Istart to vecStim.Iend do
  begin
    k:=vecStim.Jvalue[i];
    if StimList.indexof(pointer(k))<0
      then stimList.add(pointer(k));
  end;
  Nstim:=stimList.Count;
  Nseq:=Nep div Nstim;

  stimList.Sort(compare);
  setlength(tbSrc,Nx*Ny*Nframe);

  setlength(Src,Nx*Ny*Nframe*2);
  setlength(Sz,Nx*Ny*Nframe*2);
  setlength(Sz2,Nx*Ny*Nframe*2);

  {Pour chaque numéro de stim, on fait les calculs }
  for stim:=0 to Nstim-1 do
  begin
    {D'abord on accumule Sz et Sz2}
    fillchar(Sz[0],Nx*Ny*Nframe*2*4,0);
    fillchar(Sz2[0],Nx*Ny*Nframe*2*4,0);

    for i:=vecStim.Istart to vecStim.Iend do
    if vecStim[i]=intG(StimList[stim]) then
    begin
      {Lire la séquence}
      fs.position:= Nx*Ny*Nframe*8*i;
      fs.ReadBuffer(tbSrc[0],Nx*Ny*Nframe*4*2);

      ippsAdd_32f_I(Psingle(@tbSrc[0]),Psingle(@Sz[0]),Nx*Ny*Nframe*2);
      ippsSqr_32f_I(Psingle(@tbSrc[0]),Nx*Ny*Nframe*2);
      ippsAdd_32f_I(Psingle(@tbSrc[0]),Psingle(@Sz2[0]),Nx*Ny*Nframe*2);
    end;

  end;


  finally
  fs.free;
  fd.free;
  IPPSend;
  end;
end;


procedure TOIseq.OIVSNR(vecStim: Tvector; srcMoy, srcStd, dest: AnsiString);
begin

end;


type
  TFormInfo=
           record
             Xsize,Ysize:smallint;
             leftSkip,TopSkip:smallint;
             ImgXsize,ImgYsize:smallint;
             FrameCount:smallint;
             OrgImgXsize,OrgImgYsize:smallint;
             OrgFrmSize:smallint;
             nShift:smallint;
             nDum1:smallint;
             dAverage: single;
             dSampleTime: single;
             OrgSampleTime: single;
             dDum2:single;
             chDum: array[1..32] of char;
          end;

procedure TOIseq.ReadFromGSD(StSrc:AnsiString);
var
  i,j,res:integer;
  size,FrameSize,OffFrame:integer;
  f:TfileStream;

  temp:PtabEntier;
  Info:TFormInfo;

const
  chiffres=['0'..'9'];
begin
  temp:=nil;

  f:=nil;
  TRY
  f:=TfileStream.create(stSrc,fmOpenRead);

  size:=f.size;

  f.Position:=256;             { skip Header 256 bytes }
  f.Read(info,sizeof(info));   { read Form_Info }

  FrameSize:=Info.Xsize*Info.Ysize*sizeof(smallint);
  OffFrame:=972;


  initmem(info.ImgXsize,info.ImgYsize,info.FrameCount,true,g_single);

  getmem(temp,FrameSize);
  f.Position:= OffFrame ;
  f.Read(temp^,FrameSize);

  for j:=0 to info.ImgYsize-1 do
    move(temp^[(info.topSkip+j)*info.Xsize+ info.LeftSkip],temp^[j*info.ImgXsize],info.ImgXsize*2);

  matRef.initTemp(0,Nx-1,0,Ny-1,G_single);

  ippsTest;
  ippsConvert_16s32f(Psmallint(temp),Psingle(MatRef.tb),Nx*Ny);
  ippsEnd;


  for i:=0 to FrameCount-1 do
  begin
    f.Position:= OffFrame+(1+i)*FrameSize ;
    f.Read(temp^,FrameSize);

    for j:=0 to info.ImgYsize-1 do
      move(temp^[(info.topSkip+j)*info.Xsize+ info.LeftSkip],temp^[j*info.ImgXsize],info.ImgXsize*2);

    ippsTest;
    ippsConvert_16s32f(Psmallint(temp),Psingle(MemFrame(i)),Nx*Ny);
    ippsEnd;

    transpose(MemFrame(i));
  end;

  f.free;
  freemem(temp);

  EXCEPT
  f.free;
  freemem(temp);
  END;
end;



function TOIseq.CompatibleOIseq(oi: Toiseq): boolean;
begin
  result:= (oi.Nx=Nx) and (oi.Ny=Ny) and (oi.NFrame=Nframe);
end;

function TOIseq.getPopUp: TpopUpMenu;
begin
  with PopUps do
  begin
    PopupItem(pop_TOIseq,'TOIseq_Coordinates').onClick:=ChooseCoo;
    PopupItem(pop_TOIseq,'TOIseq_Show').onClick:=self.Show;
    PopupItem(pop_TOIseq,'TOIseq_Properties').onClick:=Proprietes;
    PopupItem(pop_TOIseq,'TOIseq_DisplayAsMatrix').onClick:=DispAsMatrix;
    PopupItem(pop_TOIseq,'TOIseq_DisplayAsMatrix').Checked:=DisplayAsMatrix;

    result:=pop_TOIseq;
  end;
end;

procedure TOIseq.Proprietes(sender: Tobject);
begin
  OIscaleProp.initValues(Dxu,x0u,Dyu,y0u,0,Nx,0,Ny);
  if OIseqProp.getParams(OIscaleProp) then
  begin
    Dxu:=OIscaleProp.getDx;
    Dyu:=OIscaleProp.getDy;
    x0u:=OIscaleProp.getX0;
    y0u:=OIscaleProp.getY0;

    invalidate;
  end;
end;

procedure TOIseq.DispAsMatrix(sender:Tobject);
begin
  DisplayAsMatrix:= not DisplayAsMatrix;
end;

procedure TOIseq.SetNframe(n: integer);
begin
end;

function TOIseq.MemFrame(n: integer): pointer;
begin
  if Fcompact
    then result:=@PtabOctet(MainBuf0)^[n*Nx*Ny*tailleTypeG[tpNum]]
    else result:=MainBuf[n];
end;

procedure TOIseq.Synthesis1(v, sv, rho, srho, theta, stheta: float);
var
  i:integer;
  x,y,t,x1,y1,t1:integer;
  v1,v2,  normv2: double;
  seed: longword;
  res:integer;
  Vdum: Pdouble;
  dim: array[1..3] of integer;
  Hdfti: pointer;
  w:double;
  p0: PtabDouble;
  ymin,ymax:double;
  th:double;

function gauss(z,s:double):double;
begin
  result:= exp(-0.5*sqr(z/s));
end;

function speed(x,y,t:integer):double;
begin
  result:= gauss( v1*x+v2*y+t, sv*normv2) ;
end;

function radial(x,y,t:double): double;
begin
  result:=gauss(sqrt(x*x+y*y)-rho,srho);
end;

function circ(u:double): double;
var
  u1,u2:double;
begin
  result:=abs(u);
  u1:=abs(u+2*pi);
  u2:=abs(u-2*pi);

  if u1<result then result:=u1;
  if u2<result then result:=u2;
end;

function angular(x,y,t:double): double;
var
  th: double;
begin
  th:=arcTan2(y,x);
  result:=  gauss(circ(Th-theta),stheta)+ gauss(circ(Th-theta+pi),stheta);
end;

begin
  mkltest;
  ippstest;
  Vdum:=nil;

  try

  p0:=memFrame(0);
  v1:= v*cos(theta);
  v2:= v*sin(theta);
  normv2:=sqrt(v1*v1+v2*v2+1);

  for t:=0 to Nframe-1 do
  for y:=0 to Ny-1 do
  for x:=0 to Nx-1 do
  begin
    if x>=Nx div 2 then x1:=x-Nx else x1:=x;
    if y>=Ny div 2 then y1:=y-Ny else y1:=y;
    if t>=Nframe div 2 then t1:=t-Nframe else t1:=t;

    PtabDouble(MemFrame(t))^[x+Nx*y]:=speed(x1,y1,t1)*radial(x1,y1,t1)*angular(x1,y1,t1)*1000;
  end;

  res:= ippsNorm_L2_64f(Pdouble(p0),Nx*Ny*Nframe,@w);
  ippsMulC_64f_I(1/w,Pdouble(p0),Nx*Ny*Nframe);


  // Vdum = random
  getmem(Vdum,Nx*Ny*Nframe*sizeof(double)*2);
  seed:=0;
  RandGauss64f(Vdum,Nx*Ny*Nframe,0,1, Seed);


  //Vdum = random en complexes
  for i:= Nx*Ny*Nframe- 1 downto 0 do
  begin
    PtabDouble(Vdum)^[i*2+1]:=0;
    PtabDouble(Vdum)^[i*2]:= random-0.5; //PtabDouble(Vdum)^[i];
  end;

  // Calculer la DFT inverse de Vdum
  dim[1]:=Nx;
  dim[2]:=Ny;
  dim[3]:=Nframe;

  res:=DftiCreateDescriptor(Hdfti,dfti_Double, dfti_complex ,3, @Dim);
  if res<>0 then exit;

  res:= DftiSetValueI(Hdfti, DFTI_FORWARD_DOMAIN, DFTI_COMPLEX);
  res:=DftiCommitDescriptor(Hdfti);

  res:=DftiComputeForward1(hdfti,Vdum);
  DftiFreeDescriptor(hdfti);



  // multiplier Vdum par l'oiseq calculée
  for i:=0 to Nx*Ny*Nframe do
  begin
    Ptabdouble(Vdum)^[2*i]:=   Ptabdouble(Vdum)^[2*i]  * p0^[i];
    Ptabdouble(Vdum)^[2*i+1]:= Ptabdouble(Vdum)^[2*i+1] * p0^[i];
  end;

  (*
  getmem(Vdum,Nx*Ny*Nframe*sizeof(double)*2);
  for i:=0 to Nx*Ny*Nframe do
  begin
    th:=random*2*pi;
    Ptabdouble(Vdum)^[2*i]:=   p0^[i] * cos(th);
    Ptabdouble(Vdum)^[2*i+1]:= p0^[i] * sin(th);
  end;
  *)
  res:=DftiCreateDescriptor(Hdfti,dfti_double, dfti_complex ,3, @Dim);
  if res<>0 then exit;

  res:= DftiSetValueI(Hdfti, DFTI_FORWARD_DOMAIN, DFTI_COMPLEX);

  w:=  1/( Nx*Ny*Nframe);
  res:=DftiSetValueS(hdfti,DFTI_BACKWARD_SCALE,w);

  res:=DftiCommitDescriptor(Hdfti);

  res:=DftiComputeBackward1(hdfti,Vdum);
  DftiFreeDescriptor(hdfti);


  ippsReal_64fc(PdoubleComp(Vdum),Pdouble(p0),Nx*Ny*Nframe);

  ippsMax_64f(Pdouble(p0),Nx*Ny*Nframe,@ymax);
  ippsMin_64f(Pdouble(p0),Nx*Ny*Nframe,@ymin);

  for i:=0 to Nx*Ny*Nframe-1 do p0^[i]:=(p0^[i]-ymin)/(ymax-ymin)*255;

  finally
  freemem(Vdum);
  mklend;
  ippsend;
  end;
end;

procedure TOIseq.SynthesisJV(ss, rf, tf, rs, ts, eta, alpha: single; seed: longword; Fty:boolean);
var
  i:integer;
  p:pointer;
begin
  initMCDLL;

  MCinit( ss, rf, tf, rs, ts, eta, alpha, Ny,Nx, seed,ord(Fty));
  for i:=0 to Nframe-1 do
  begin
    p:=MCgetFrame;
    move(p^,MemFrame(i)^,Nx*Ny*4);
  end;

end;


function TOIseq.getRSHinfo(st: Ansistring;var value:float): Ansistring;
var
  stL:TstringList;
  i,k,code:integer;
  st1: Ansistring;
begin
  value:=0;
  if st='' then result:=RSHtext
  else
  begin
    result:='';
    stL:=TstringList.create;
    stL.text:=RSHtext;
    for i:=0 to stL.Count-1 do
    begin
      st1:=FsupespaceDebut(stL[i]);
      if pos(st,st1)=1 then
      begin
        k:=pos('=',st1);
        if k>0
          then result:=copy(st1,k+1,length(st1)-k)
          else result:=st1;
        result:=FsupespaceDebut(result);
        result:=FsupespaceFin(result);

        st1:=result;
        k:=length(st1);
        while (k>0) and not (st1[k] in ['0'..'9','.']) do dec(k);
        st1:=copy(st1,1,k);
        if k>0 then val(st1,value,code);
      end;
    end;
    stl.Free;
  end;
end;

function TOIseq.getBinX: integer;
begin
  result:=1;
end;

function TOIseq.getBinY: integer;
begin
  result:=1;
end;

procedure TOIseq.setBinX(w: integer);
begin
end;

procedure TOIseq.setBinY(w: integer);
begin
end;


procedure TOIseq.SaveToBin(f: Tstream; tp: typetypeG; LineFirst:boolean);
var
  t:pointer;
  sz:integer;
begin
  sz:=TailleTypeG[tp]*Nx*Ny*Nframe;
  getmem(t,sz);
  try
  saveToMem(t,tp, LineFirst);
  f.Write(t^,sz);
  finally
  freemem(t);
  end;
end;

procedure TOIseq.LoadFromBin(f: Tstream; tp:typetypeG; LineFirst:boolean);
var
  t:pointer;
  sz:integer;
begin
  sz:=TailleTypeG[tp]*Nx*Ny*Nframe;
  getmem(t,sz);
  try
  f.Read(t^,sz);
  LoadFromMem(t,tp, LineFirst);

  finally
  freemem(t);
  end;
end;


{ TOIseqMeta }

procedure TOIseqMeta.initFile(f: TgetStream;stk:TstkFile);
var
  i:integer;
begin
  FinitOK:=false;
  Ffile:=true;
  f0:=f;

  if not assigned(stk) then exit;

  Nx:=stk.ImageWidth;
  Ny:=stk.ImageHeight;

  sampleSize:= stk.BitsPerSample[0] div 8;

  Nframe:=stk.stkCount;
  FrameSize:=stk.frameSize;
  DiskFrameSize:=stk.DiskframeSize;

  setLength(stripOffsets,length(stk.StripOffsets));
  for i:=0 to high(stripOffsets) do
    stripOffsets[i]:=stk.stripOffsets[i];

  setLength(stripByteCounts,length(stk.StripByteCounts));
  for i:=0 to high(stripByteCounts) do
    stripByteCounts[i]:=stk.stripByteCounts[i];


  reallocmemG(FrameBuf,FrameSize);

  WithRefFrame:=false;

  initDataMat;

  FinitOK:=true;
end;



procedure TOIseqMeta.loadMat(m: Tmatrix; n:integer);
  var
  i:integer;
  offset:integer;
begin
  if assigned(f0) then
  begin
    offset:=0;
    for i:=0 to high(stripByteCounts) do
    begin
      f0().position:= StripOffsets[i]+n*DiskFrameSize;
      f0().Read(PtabOctet(FrameBuf)^[offset],stripByteCounts[i]);
      offset:=offset+stripByteCounts[i];
    end;

    ippsTest;
    case SampleSize of
      1:  ippsConvert_8u32f(Pbyte(FrameBuf),Psingle(m.tb),Nx*Ny);
      2:  ippsConvert_16s32f(Psmallint(FrameBuf),Psingle(m.tb),Nx*Ny);
    end;
    ippsEnd;

    transpose(m.tb);
  end;
end;

procedure TOIseqMeta.loadvecFromFile(vec: Tvector; x,y:integer);
var
  i:integer;
  b:byte;
  w:word;
  n,p:longword;

begin
  p:=(x+Nx*y)*SampleSize;

  i:=0;
  n:=0;
  while (n<=p) and (i<=high(stripByteCounts)) do
  begin
    n:=n+stripByteCounts[i];
    inc(i);
  end;
  dec(i);
  dec(n,stripByteCounts[i]);

  p:=StripOffsets[i]+p-n;

  if assigned(f0) then
  begin
    case sampleSize of
      1:  for i:=0 to Nframe-1 do
          begin
            f0().position:= p+DiskFrameSize*i;
            f0().Read(b,sizeof(b));
            vec.tbSingle[i]:=b;
          end;
      2:  for i:=0 to Nframe-1 do
          begin
            f0().position:= p+DiskFrameSize*i;
            f0().Read(w,sizeof(w));
            vec.tbSingle[i]:=w;
          end;
    end;
  end;
end;


procedure TOIseqMeta.setInMemory(w: boolean);
begin

end;









{ TOIseqPCL }

constructor TOIseqPCL.create;
begin
  inherited;

  NframeU:=100;

  NxBase:=512;
  NyBase:=512;
  binX:=8;
  binY:=8;
  binDt:=100;
  Fmemory:=false;
  tpNum:=g_single;

  Dxu0:=1;
  Dyu0:=1;

  Vtimes:=Tvector.create;
  AddTochildList(Vtimes);
  with Vtimes do
  begin
    initTemp1(0,0,g_single); {sera modifié par LoadFile}
    Fchild:=true;

    visu.modeT:=DM_evt1;
    visu.Ymin:=-100;
    visu.color:=clGreen;
    visu.tailleT:=15;
  end;

  Vx:=Tvector.create;
  AddTochildList(Vx);
  with Vx do
  begin
    initTemp1(0,0,g_single); {sera modifié par LoadFile}
    Fchild:=true;
  end;

  Vy:=Tvector.create;
  AddTochildList(Vy);
  with Vy do
  begin
    initTemp1(0,0,g_single); {sera modifié par LoadFile}
    Fchild:=true;
  end;

  Vz:=Tvector.create;
  AddTochildList(Vz);
  with Vz do
  begin
    initTemp1(0,0,g_single); {sera modifié par LoadFile}
    Fchild:=true;
  end;


  Transparent:=true;
  TransparentValue:=0;

  CoupledbinXY:=true;
  EditDecimalPlaces[1]:=6;

  with PhotonFilter do
  begin
    dx:=1;
    dy:=1;
  end;
end;

destructor TOIseqPCL.destroy;
begin
  EditForm.free;

  Vtimes.Free;
  Vx.Free;
  Vy.Free;
  Vz.free;
  inherited;
end;

procedure TOIseqPCL.setChildNames;
begin
  Inherited;

  with Vtimes do
  begin
    ident:=self.ident+'.Vtimes';
    notPublished:=true;
    Fchild:=true;
  end;

  with Vx do
  begin
    ident:=self.ident+'.Vx';
    Fchild:=true;
  end;

  with Vy do
  begin
    ident:=self.ident+'.Vy';
    Fchild:=true;
  end;

  with Vz do
  begin
    ident:=self.ident+'.Vz';
    Fchild:=true;
  end;

end;

procedure TOIseqPCL.loadFile(stF: AnsiString);
var
  f:TfileStream;
  i:integer;
  rec:TPCLrecord;
  size:integer;
  nb:integer;

begin
// Dans un fichier PCL, les temps sont en secondes et sont des temps absolus.

  FinitOK:=false;
  Ffile:=true;    // Indique que les données ne sont pas dans un tableau de matrices
  Fmul:=1E6;      // Les temps sont en secondes

  tpNum:=g_single;
  // Charger les photons dans le tableau TabPhoton
  TRY
    f:=TfileStream.create(stF,fmOpenRead);

    size:=f.size;
    nb:= size div 14;
    setLength(TabPhoton,nb);

    for i:=0 to nb-1 do
    begin
      f.Read(rec,sizeof(rec));
      rec.convert;
      TabPhoton[i]:=rec;
    end;

    if nb>0 then
    begin
      tmin:=TabPhoton[0].time;
      tmax:=TabPhoton[nb-1].time;
    end;
  finally
    f.free;
  end;

  FileLoaded:=true;
  BlockLoaded:=false;

  dataPhoton.Free;
  dataPhoton:=nil;

  dataPhoton:=typeDataPhoton.create(@TabPhoton[0],0,nb-1);  // créé même si zéro photon

  Initvectors;
end;

procedure TOIseqPCL.FreeData;
begin
  setLength(TabPhoton,0);

  dataPhoton.Free;
  dataPhoton:=nil;
  InitVectors;
  InitDataMat;
end;


{ Chargement à partir d'un fichier Elphy
  num est le numéro du bloc, si num=0 on met à zéro le tableau de photon
  sinon on accumule les photons.
}
procedure TOIseqPCL.LoadBlock(num:integer;f: Tstream;size:integer;tmin1,tmax1:float;ux: AnsiString);
var
  i, i0: integer;
  nb: integer;

begin
  FinitOK:=true;
  Ffile:=true;    // Indique que les données ne sont pas dans un tableau de matrices

  FileLoaded:= false;
  BlockLoaded:= true;
  tpNum:=g_single;

  unitX:=ux;
  if Fmaj(ux)='MS' then Fmul:=1E3 else Fmul:=1E6;
                  // les temps originaux sont en microsecondes, on les convertit en millisecondes ou secondes
  nb:= size div 14;

  if num=0
    then i0:=0
    else i0:=length(TabPhoton);

  setLength(TabPhoton,i0+nb);
  setLength(TabPhoton0,i0+nb);


  if nb>0 then
  begin
    f.Read(TabPhoton0[i0],sizeof(TPCLrecord)*nb);
    FilterTabPhoton(i0,nb);
  end;
  nb:=length(tabPhoton);

  tmin:=tmin1;
  tmax:=tmax1;

  dataPhoton.Free;
  dataPhoton:=nil;

  dataPhoton:=typeDataPhoton.create(@TabPhoton[0],0,nb-1);

  initFrames0(true);
end;

procedure TOIseqPCL.FilterTabPhoton(i0, nb: integer);
var
  i:integer;
begin
  if nb<0 then
  begin
    i0:=0;
    nb:=length(tabPhoton);
  end;

  move(tabPhoton0[i0],tabPhoton[i0],nb*sizeof(TPCLrecord));
  if PhotonFilter.active then
  begin
    for i:=i0 to i0+nb-1 do
      with tabPhoton[i] do
        FilterPhoton(x,y);
  end;
end;


procedure TOIseqPCL.InitVectors;
var
  data1:TypeDataB;
begin
  // Creer les vecteurs associés Vtimes, Vx, Vy, Vz

  if assigned(dataPhoton)
    then data1:=dataPhoton.getDataVtime
    else data1:=nil;

  Vtimes.initdat1ex(data1,g_double);
  Vtimes.readOnly:=false;

  if assigned(dataPhoton)
    then data1:=dataPhoton.getDataVx
    else data1:=nil;
  Vx.initdat1ex(data1,g_smallint);
  Vx.readOnly:=false;

  if assigned(dataPhoton)
    then data1:=dataPhoton.getDataVy
    else data1:=nil;
  Vy.initdat1ex(data1,g_smallint);
  Vy.readOnly:=false;

  if assigned(dataPhoton)
    then data1:=dataPhoton.getDataVz
    else data1:=nil;
  Vz.initdat1ex(data1,g_smallint);
  Vz.readOnly:=false;
end;


procedure TOIseqPCL.InitFrames0(FinitVec:boolean);
var
  i,j:integer;
  ind0,lastI,index: integer;

  BinDtU: float;
begin
  if PhotonCount=0 then exit;

  Nx:=NxBase div BinX;
  Ny:=NyBase div BinY;

  Dxu:=Dxu0*BinX;
  Dyu:=Dyu0*BinY;

  BinDtU:=BinDt*1000/Fmul;    // BinDt en millisecondes
                              // BinDtU en ms ou secondes (unités réelles)
  if NoOverlap then
  begin
    Nframe:=floor((tmax-tmin)/binDtU);
    if frac((tmax-tmin)/binDtU)>0 then inc(Nframe);
    deltaT:=binDTU;
    if Nframe<=0 then Nframe:=1;
  end
  else
  begin
    Nframe:=NframeU;
    deltaT:=tmax/NframeU;
    if deltaT*Fmul<= 1000 then deltaT:=  1000/Fmul;
  end;

  setlength(Vindex,Nframe+1);
  for i:=0 to Nframe do Vindex[i]:=-1;

  ind0:=-1;
  lastI:=-1;

  with dataPhoton do
  for i:=indicemin to indicemax do
  with dataPhoton.getPhoton(i) do
  begin
    index:=floor((time-tmin)/deltaT);
    if (index>ind0) and (index<Nframe) then
    begin
      for j:=ind0+1 to index do Vindex[j]:=i;
      ind0:=index;
    end;
    if index>=Nframe then
    begin
      lastI:=i;
      break;
    end;
  end;
  if LastI>0
    then Vindex[Nframe]:=lastI
    else Vindex[Nframe]:=PhotonCount;


  WithRefFrame:=false;

  if FinitVec then initVectors;

  initDataMat; // pose un problème car initdatamat appelle invalidate qui invalide aussi les vecteurs
               // initVectors doit donc être appelé avant inidatamat;
  FinitOK:=true;

end;

procedure TOIseqPCL.InitFrames( Nx1, Ny1: integer; dt,torg,tend: float);
begin
  if BlockLoaded or (PhotonCount=0) then exit;

  NxBase:=Nx1;
  NyBase:=Ny1;


  binDt:=dt;

  if torg >=0
    then tmin:= torg
    else tmin:=dataPhoton.photon[0].time;

  if tend >=0
    then tmax:= tend
    else tmax:=dataPhoton.photon[photonCount-1].time;

  initFrames0(false);
end;

procedure TOIseqPCL.loadMat(m: Tmatrix; n: integer);
var
  rec:TPCLrecord;
  i:integer;
  x1,y1:integer;
  tm:float;
begin
  m.fill(0);

  if not assigned(dataPhoton) then exit;
  if high(Vindex)<n then exit;
  if Vindex[n]<0 then exit;

  tm:= tmin+ (n*deltaT+ binDT*1000/Fmul);            // tm en unités réelles
  for i:=Vindex[n] to dataPhoton.indiceMax do
  with dataphoton.Photon[i] do
  begin
    if time<tm then
    begin
      x1:= X div binX;
      y1:= Y div binY;
      if (X1>=0) and (X1<Nx) and (Y1>=0) and (Y1<Ny) then m[X1,Y1]:= m[X1,Y1] +1;
    end
    else break;
  end;

end;

procedure TOIseqPCL.loadvecFromFile(vec: Tvector; x, y: integer);
begin
  inherited;

end;

procedure TOIseqPCL.setInMemory(w: boolean);
begin
  { Nothing to do }
end;

procedure TOIseqPCL.setBinX(w:integer);
begin
  PCLprop.FBinX:=w;
  Nx:=NxBase div binX;
  Dxu:= Dxu0*binX;

  if CoupledBinXY then
  begin
    PCLprop.FBinY:=w;
    Ny:=NyBase div binY;
    Dyu:= Dyu0*binY;
  end;

  initDataMat;
end;

procedure TOIseqPCL.setBinY(w:integer);
begin
  PCLprop.FBinY:=w;
  Ny:=NyBase div binY;
  Dyu:= Dyu0*binY;

  if CoupledBinXY then
  begin
    PCLprop.FBinX:=w;
    Nx:=NxBase div binx;
    Dxu:= Dxu0*binX;
  end;

  initDataMat;
end;

function TOIseqPCL.getBinX: integer;
begin
  result:= PCLprop.FBinX;
end;

function TOIseqPCL.getBinY: integer;
begin
  result:= PCLprop.FBinY;
end;


procedure TOIseqPCL.setBinDT(w:double);
begin
  if w>0 then PCLprop.FBinDT:=w;

end;


procedure TOIseqPCL.BuildInfo(var conf: TblocConf; lecture, tout: boolean);
begin
  inherited;

  with conf do
  begin
    setvarConf('PCLprop',PCLprop,sizeof(PCLprop));
    setvarConf('Dxu0',Dxu0,sizeof(Dxu0));
    setvarConf('Dyu0',Dyu0,sizeof(Dyu0));
  end;

end;

procedure TOIseqPCL.completeLoadInfo;
begin
  inherited;

  if NxBase=0 then NxBase:=512;
  if NyBase=0 then NyBase:=512;

  if binX<1 then binX:=8;
  if binY<1 then binY:=8;

  if binDt=0 then binDt:=1;

  Dxu:= Dxu0*binX;
  Dyu:= Dyu0*binY;

end;

function TOIseqPCL.loadFromStream(f: Tstream; size: LongWord;  Fdata: boolean): boolean;
var
  st1:Ansistring;
  posf: int64;
  ok:boolean;
  posIni: int64;
  i:integer;
begin
  ok:=inherited loadFromStream(f,size,Fdata);
  result:=ok;

  if not ok then
  begin
    setChildNames;
    exit;
  end;

  if f.position>=f.Size  then
    begin
      result:=true;
      exit;
    end;

  posIni:=f.position;
  st1:=readHeader(f,size);
  ok:=(st1=Tvector.stmClassName) and (Vtimes.loadFromStream(f,size,Fdata)) and (Vtimes.Fchild);
  if not ok then
    begin
      f.Position:=Posini;
      result:=ok;
      setChildNames;
      exit;
    end;

  posIni:=f.position;
  st1:=readHeader(f,size);
  ok:=(st1=Tvector.stmClassName) and (Vx.loadFromStream(f,size,Fdata)) and (Vx.Fchild);
  if not ok then
    begin
      f.Position:=Posini;
      result:=ok;
      setChildNames;
      exit;
    end;

  posIni:=f.position;
  st1:=readHeader(f,size);
  ok:=(st1=Tvector.stmClassName) and (Vy.loadFromStream(f,size,Fdata)) and (Vy.Fchild);
  if not ok then
    begin
      f.Position:=Posini;
      result:=ok;
      setChildNames;
      exit;
    end;

  posIni:=f.position;
  st1:=readHeader(f,size);
  ok:=(st1=Tvector.stmClassName) and (Vz.loadFromStream(f,size,Fdata)) and (Vz.Fchild);
  if not ok then
    begin
      f.Position:=Posini;
      result:=ok;
      setChildNames;
      exit;
    end;

  setChildNames;
  result:=ok;
end;


procedure TOIseqPCL.saveToStream(f: Tstream; Fdata: boolean);
begin
  inherited saveToStream(f,Fdata);

  Vtimes.saveToStream(f,Fdata);
  Vx.saveToStream(f,Fdata);
  Vy.saveToStream(f,Fdata);
  Vz.saveToStream(f,Fdata);

end;


function TOIseqPCL.indexToReal(id: integer): float;
begin
  result:=id*DeltaT;
end;


procedure TOIseqPCL.UpdatePhotons(LastI: integer; lastT:float);   { lastT en microsecondes }
var
  i: integer;
  Tstart: float;
  m: Tmatrix;
  x1,y1:integer;
begin
  if not assigned(dataPhoton) then exit;

  index:=Nframe-1;
  m:=mat[index];
  m.fill(0);

  i:=lastI-1;

  Tstart:= lastT-binDT*1000;
  if Tstart<0 then Tstart:=0;
  Tstart:=Tstart/Fmul;
  with dataPhoton do
  begin
    while (i>=0) and (photon[i].time >= Tstart) do
    with photon[i] do
    begin
      x1:= X div binX;
      y1:= Y div binY;
      if (X1<Nx) and (Y1<Ny) then m[X1,Y1]:= m[X1,Y1] +1;
      dec(i);
    end;
  end;

  invalidate;
end;

procedure TOIseqPCL.InitAcq(data: TypeDataPhotonB; tt1,tt2:float;EpMode: boolean; Nx1,Ny1:integer);
begin
  dataPhoton.Free;
  dataPhoton:=data;

  if EpMode then
  begin
    UnitX:='ms';
    Fmul:=1E3;
  end
  else
  begin
    Fmul:=1E6;
    unitX:='sec';
  end;

  tmin:=tt1;
  tmax:=tt2;

  if Nx1<16 then Nx1:=16;
  if Ny1<16 then Ny1:=16;

  NxBase:=Nx1;
  NyBase:=Ny1;

  initFrames0(true);

  //loadmat(mat[0],0);
  if assigned(editForm) then editForm.hide;
  if assigned(Vtimes.editForm) then Vtimes.editForm.hide;
  if assigned(Vx.editForm) then Vx.editForm.hide;
  if assigned(Vy.editForm) then Vy.editForm.hide;
  if assigned(Vz.editForm) then Vz.editForm.hide;
  invalidate;
end;

procedure TOIseqPCL.ModifyLimits(imax:integer;ttmax:float);  // ttmax en microsecondes
begin
  if assigned(dataPhoton) then dataPhoton.indiceMax:=imax;
  Vtimes.modifyLimits(0,imax,false);
  Vx.modifyLimits(0,imax,false);
  Vy.modifyLimits(0,imax,false);
  Vz.modifyLimits(0,imax,false);

  tmax:=ttmax/Fmul;

  Affdebug('modifyLimits '+Istr(imax),98);
end;

function TOIseqPCL.PhotonCount:integer;
begin
  if assigned(dataPhoton)
    then result:=dataPhoton.indiceMax-dataPhoton.indiceMin+1
    else result:=0;
end;

function TOIseqPCL.DgetColName(i:integer):AnsiString;
begin
  case i of
    1: result:='time';
    2: result:='x';
    3: result:='y';
    4: result:='z';
  end
end;

function TOIseqPCL.DgetE(i,j:integer):float;
begin
  if (j>=1) and (j<=PhotonCount) then
  case i of
    1: result:= dataPhoton.photon[j-1].time;
    2: result:= dataPhoton.photon[j-1].x;
    3: result:= dataPhoton.photon[j-1].y;
    4: result:= dataPhoton.photon[j-1].z;

  end
  else result:=0;
end;

function TOIseqPCL.EditGetDeci(n:integer): integer;
begin
  result:= EditDecimalPlaces[n];
end;

procedure TOIseqPCL.EditSetDeci(n:integer; x:integer);
begin
  EditDecimalPlaces[n]:=x;
end;

procedure TOIseqPCL.UpdateEditForm;
begin
  if not assigned(editForm) then exit;

  with editForm do
  begin
    installe(1,1,4,PhotonCount);
    caption:=ident;

    getColName:=DgetColName;
    getTabValue:=DgetE;


    getDeciValue:= EditGetDeci;
    setDeciValue:= EditSetDeci;

    adjustFormSize;

    {
    File1.visible:=true;
    Load1.visible:=false;
    Save1.visible:=true;

    Edit1.visible:=false;
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
    }
  end;

  editForm.invalidate;
end;

procedure TOIseqPCL.EditPhotons(sender:Tobject);
begin
  if not assigned(editForm) then
  begin
    Editform:=TtableEdit.create(formStm);
    updateEditForm;
  end
  else
  if not EditForm.Visible then updateEditForm;
  EditForm.show;
end;

function TOIseqPCL.getPopUp: TpopUpMenu;
begin
  with PopUps do
  begin
    PopupItem(pop_TOIseqPCL,'TOIseqPCL_Coordinates').onClick:=ChooseCoo;
    PopupItem(pop_TOIseqPCL,'TOIseqPCL_Show').onClick:=self.Show;
    PopupItem(pop_TOIseqPCL,'TOIseqPCL_Properties').onClick:=Proprietes;
    PopupItem(pop_TOIseqPCL,'TOIseqPCL_Edit').onClick:=EditPhotons;
    result:=pop_TOIseqPCL;
  end;
end;

procedure TOIseqPCL.Invalidate;
begin
  inherited;
  if not Acquisition.AcqON then
  begin
    if assigned(editform) then UpdateEditform;
    if assigned(Vtimes) then Vtimes.invalidateData;
    if assigned(Vx) then Vx.invalidateData;
    if assigned(Vy) then Vy.invalidateData;
    if assigned(Vz) then Vz.invalidateData;
  end;
end;

procedure TOIseqPCL.SetNframe(n: integer);
begin
  NframeU:=n;
end;

procedure TOIseqPCL.Proprietes(sender: Tobject);
begin
  OIscaleProp.initValues(Dxu0,x0u,Dyu0,y0u, 0, NxBase, 0, NyBase);
  if OIseqProp.getParams(OIscaleProp) then
  begin
    Dxu0:=OIscaleProp.getDx;
    Dyu0:=OIscaleProp.getDy;
    x0u:=OIscaleProp.getX0;
    y0u:=OIscaleProp.getY0;

    Dxu:= Dxu0*BinX;
    Dyu:= Dyu0*BinY;

    invalidate;
  end;
end;



{****************** Méthodes stm *************************************}

procedure proTOIseq_create(name:AnsiString;Nx1,Ny1,Nframe1:integer;withRef:boolean; var pu:typeUO);
begin
  createPgObject(name,pu,TOIseq);
  TOIseq(pu).initMem(Nx1,Ny1,nframe1,withref,g_single);
end;

procedure proTOIseq_create_1(Nx1,Ny1,Nframe1:integer;withRef:boolean;var pu:typeUO);
begin
  proTOIseq_create('',Nx1,Ny1,Nframe1,withRef,pu);
end;

procedure proTOIseq_createCompact(Nx1,Ny1,Nframe1:integer;Fdouble:boolean;var pu:typeUO);
var
  tp:typetypeG;
begin
  createPgObject('',pu,TOIseq);
  if Fdouble then tp:=g_double else tp:=g_single;
  TOIseq(pu).initMem(Nx1,Ny1,nframe1,false,tp,true);
end;

function fonctionTOIseq_Nx(var pu:typeUO):integer;
begin
  verifierObjet(pu);
  with TOIseq(pu) do
  result:=Nx;
end;

function fonctionTOIseq_Ny(var pu:typeUO):integer;
begin
  verifierObjet(pu);
  with TOIseq(pu) do
  result:=Ny;
end;

function fonctionTOIseq_NumType(var pu:typeUO):integer;
begin
  verifierObjet(pu);
  with TOIseq(pu) do
  result:=ord(tpNum);
end;


function fonctionTOIseq_FrameCount(var pu:typeUO):integer;
begin
  verifierObjet(pu);
  with TOIseq(pu) do
  result:=FrameCount;
end;

procedure proTOIseq_FrameCount(n:integer;var pu:typeUO);
begin
  verifierObjet(pu);
  if n>=0 then TOIseq(pu).FrameCount:=n;
end;

function fonctionTOIseq_HasRefFrame(var pu:typeUO):boolean;
begin
  verifierObjet(pu);
  with TOIseq(pu) do
  result:=WithRefFrame;
end;


function fonctionTOIseq_RefFrame(var pu:typeUO):pointer;
begin
  verifierObjet(pu);
  with TOIseq(pu) do
  begin
    if not initOK then sortieErreur('TOIseq : Sequence not initialized');

    result:=@MatRef;
  end;
end;


function fonctionTOIseq_Frame(n:integer;var pu:typeUO):pointer; {n de 0 à Nframe-1 }
begin
  verifierObjet(pu);
  with TOIseq(pu) do
  begin
    if not initOK then sortieErreur('TOIseq : Sequence not initialized');
    if (n<0) or (n>Nframe-1) then sortieErreur('TOIseq : frame number out of range');
    //result:=@getmat(n).MyAd;
    result:=getmat(n).PgAddress;
    { on remarque que si on échange des positions dans PoolMat, l'adresse reste toujours valable
      ce ne serait pas le cas en utilisant @PoolMat[num]
    }
  end;
end;

procedure proTOIseq_getV(x,y:integer;var vec:Tvector;var pu:typeUO); {x,y commencent à zéro }
begin
  verifierObjet(pu);
  verifierVecteur(vec);
  with TOIseq(pu) do
  begin
    if not initOK then sortieErreur('TOIseq : Sequence not initialized');
    if (x<0) or (x>=Nx) or (y<0) or (y>=Ny) then sortieErreur('TOIseq : position out of range');
    getV(x,y,vec);
  end;
end;

procedure proTOIseq_setV(x,y:integer;var vec:Tvector;var pu:typeUO); {x,y commencent à zéro }
begin
  verifierObjet(pu);
  verifierVecteur(vec);
  with TOIseq(pu) do
  begin
    if not initOK then sortieErreur('TOIseq .setV: Sequence not initialized');
    if (x<0) or (x>=Nx) or (y<0) or (y>=Ny) then sortieErreur('TOIseq.setV : position out of range');
    if vec.Icount<Nframe then sortieErreur('TOIseq.setV :  vector length too small');

    if not inMemory then sortieErreur('TOIseq : object is readonly');
    setV(x,y,vec);
  end;
end;


procedure proTOIseq_initFile(stF:AnsiString;numOc:integer;var pu:typeUO);
begin

end;

procedure proTOIseq_inMemory(w:boolean;var pu:typeUO);
begin
  verifierObjet(pu);
  with TOIseq(pu) do
    InMemory:=w;
end;

function fonctionTOIseq_inMemory(var pu:typeUO):boolean;
begin
  verifierObjet(pu);
  result:=TOIseq(pu).InMemory;
end;

procedure proTOIseq_Index(n:integer;var pu:typeUO);
begin
  verifierObjet(pu);

  with TOIseq(pu) do
  begin
    controleParam(n,0,Nframe-1,'TOIseq : index out of range');
    index:=n;
    invalidate;
  end;
end;

function fonctionTOIseq_Index(var pu:typeUO):integer;
begin
  verifierObjet(pu);
  with TOIseq(pu) do result:=index;
end;



procedure proTOIseq_Selected(n:integer;x:boolean;var pu:typeUO);
begin
  verifierObjet(pu);

  with TOIseq(pu) do
  begin
    controleParam(n,0,Nframe-1,'TOIseq.selected : index out of range' );
    selected[n]:=x;
  end;
end;

function fonctionTOIseq_Selected(n:integer;var pu:typeUO):boolean;
begin
  verifierObjet(pu);
  with TOIseq(pu) do
  begin
    controleParam(n,0,Nframe-1,'TOIseq.selected : index out of range' );
    result:=selected[n];
  end;
end;

procedure proTOIseq_CpIndex(p:integer;var pu:typeUO);
begin
  verifierObjet(pu);
  TOIseq(pu).CpIndex:=p;
end;

function fonctionTOIseq_CpIndex(var pu:typeUO):integer;
begin
  verifierObjet(pu);
  result:=TOIseq(pu).CpIndex;
end;


function fonctionTOIseq_Zmin(var pu:typeUO):float;
begin
  verifierObjet(pu);
  result:=TOIseq(pu).Zmin;
end;

procedure proTOIseq_Zmin(x:float;var pu:typeUO);
begin
  verifierObjet(pu);
  TOIseq(pu).Zmin:=x;
end;

function fonctionTOIseq_Zmax(var pu:typeUO):float;
begin
  verifierObjet(pu);
  result:=TOIseq(pu).Zmax;
end;

procedure proTOIseq_Zmax(x:float;var pu:typeUO);
begin
  verifierObjet(pu);
  TOIseq(pu).Zmax:=x;
end;


function fonctionTOIseq_theta(var pu:typeUO):float;
begin
  verifierObjet(pu);
  result:=TOIseq(pu).theta;
end;

procedure proTOIseq_theta(x:float;var pu:typeUO);
begin
  verifierObjet(pu);
  TOIseq(pu).theta:=x;
end;

function fonctionTOIseq_AspectRatio(var pu:typeUO):float;
begin
  verifierObjet(pu);
  result:=TOIseq(pu).AspectRatio;
end;

procedure proTOIseq_AspectRatio(x:float;var pu:typeUO);
begin
  verifierObjet(pu);
  TOIseq(pu).AspectRatio:=x;
end;


function fonctionTOIseq_TwoColors(var pu:typeUO):boolean;
begin
  verifierObjet(pu);
  result:=TOIseq(pu).TwoCol;
end;

procedure proTOIseq_TwoColors(x:boolean;var pu:typeUO);
begin
  verifierObjet(pu);
  TOIseq(pu).TwoCol:=x;
end;

function fonctionTOIseq_PalColor(n:integer;var pu:typeUO):integer;
begin
  verifierObjet(pu);
  controleParametre(n,1,2);
  result:=TOIseq(pu).PalColor[n];
end;

procedure proTOIseq_PalColor(n:integer;x:integer;var pu:typeUO);
begin
  verifierObjet(pu);
  controleParametre(n,1,2);
  TOIseq(pu).PalColor[n]:=  x;
end;

procedure proTOIseq_DisplayMode(x:integer;var pu:typeUO);
begin
  verifierObjet(pu);
  TOIseq(pu).DisplayMode:=x;
end;

function fonctionTOIseq_DisplayMode(var pu:typeUO):integer;
begin
  verifierObjet(pu);
  result:=TOIseq(pu).DisplayMode;
end;

procedure proTOIseq_PalName(x:AnsiString;var pu:typeUO);
begin
  verifierObjet(pu);
  TOIseq(pu).PalName:=x;
end;

function fonctionTOIseq_PalName(var pu:typeUO):AnsiString;
begin
  verifierObjet(pu);
  result:=TOIseq(pu).PalName;
end;


procedure proTOIseq_getMinMax(var Vmin,Vmax:float;var pu:typeUO);
begin
  verifierObjet(pu);
  TOIseq(pu).getMinMax(Vmin,Vmax);
end;

procedure proTOIseq_AutoscaleZ(var pu:typeUO);
begin
  verifierObjet(pu);
  TOIseq(pu).autoscaleZ1(false);
end;

procedure proTOIseq_AutoscaleZ_1(flagAll:boolean;var pu:typeUO);
begin
  verifierObjet(pu);
  TOIseq(pu).autoscaleZ1(flagAll);
end;


procedure proTOIseq_AutoscaleZsym(var pu:typeUO);
begin
  verifierObjet(pu);
  TOIseq(pu).autoscaleZsym;
end;

function fonctionToiseq_regionList(var pu:typeUO):pointer;
begin
  verifierObjet(pu);
  result:=@Toiseq(pu).regionList.MyAd;
end;

procedure proTOIseq_BuildVector(var reg:Treg;var vec:Tvector;var pu:typeUO);
begin
  if not assigned(reg) then exit;
  verifierObjet(pu);
  verifierVecteurTemp(vec);

  TOIseq(pu).BuildVector(reg,vec);
end;

procedure proTOIseq_BuildVector_1(var reg:Treg;var vec:Tvector;mode:integer;var pu:typeUO);
begin
  if not assigned(reg) then exit;
  verifierObjet(pu);
  verifierVecteurTemp(vec);

  TOIseq(pu).BuildVector(reg,vec,mode);
end;


procedure proTOIseq_BuildVectors(var reglist:TregionList;var vecList:TVlist;var pu:typeUO);
begin
  verifierObjet(typeUO(regList));
  verifierObjet(pu);
  verifierObjet(typeUO(vecList));

  TOIseq(pu).BuildVectors(regList,vecList);
end;

procedure proTOIseq_BuildVectors_1(var reglist:TregionList;var vecList:TVlist;mode:integer;var pu:typeUO);
begin
  verifierObjet(typeUO(regList));
  verifierObjet(pu);
  verifierObjet(typeUO(vecList));

  TOIseq(pu).BuildVectors(regList,vecList,mode);
end;

procedure proTOIseq_BuildVectorFromRect(i1,i2,j1,j2: integer;var vec:Tvector;var pu:typeUO);
begin
  verifierObjet(pu);
  verifierVecteurTemp(vec);

  TOIseq(pu).BuildVectorFromRect(i1,i2,j1,j2,vec);
end;

procedure proTOIseq_BuildVectorFromRect_1(i1,i2,j1,j2: integer;var vec:Tvector;mode:integer;var pu:typeUO);
begin
  verifierObjet(pu);
  verifierVecteurTemp(vec);

  TOIseq(pu).BuildVectorFromRect(i1,i2,j1,j2,vec,mode);
end;

procedure proTOIseq_Copy(var oiseq:Toiseq;var pu:typeUO);
begin
  verifierObjet(pu);
  verifierObjet(typeUO(oiseq));

  with Toiseq(pu) do
  begin
    if Ffile then sortieErreur('Toiseq : this object cannot be modified');
    copyOI(oiseq);
  end;
end;

procedure proTOIseq_copyFrames(var oiseq:Toiseq;f1,f2,fD:integer;var pu:typeUO);
begin
  verifierObjet(typeUO(oiseq));
  verifierObjet(pu);
  with TOIseq(pu) do
  begin
    if Ffile then sortieErreur('TOISeq : this object cannot be modified');
    copyFrames(oiseq,f1,f2,fD);
  end;
end;

procedure proTOIseq_extract(var oiseq:Toiseq;i1,i2,j1,j2,f1,f2:integer;var pu:typeUO);
begin
  verifierObjet(typeUO(oiseq));
  verifierObjet(pu);
  with TOIseq(pu) do
  begin
    if Ffile then sortieErreur('TOISeq : this object cannot be modified');
    extract(oiseq,i1,i2,j1,j2,f1,f2);
  end;
end;

procedure proTOIseq_Add(var oiseq:Toiseq;var pu:typeUO);
begin
  verifierObjet(typeUO(oiseq));
  verifierObjet(pu);
  with TOIseq(pu) do
  begin
    if Ffile then sortieErreur('TOISeq : this object cannot be modified');
    if not CompatibleOIseq(oiseq) then sortieErreur('TOIseq.Add : oiseq not compatible');
    add(oiseq);
  end;
end;

procedure proTOIseq_Sub(var oiseq:Toiseq;var pu:typeUO);
begin
  verifierObjet(typeUO(oiseq));
  verifierObjet(pu);
  with TOIseq(pu) do
  begin
    if Ffile then sortieErreur('TOISeq : this object cannot be modified');
    if not CompatibleOIseq(oiseq) then sortieErreur('TOIseq.Sub : oiseq not compatible');
    sub(oiseq);
  end;
end;

procedure proTOIseq_AddNum(w:float;var pu:typeUO);
begin
  verifierObjet(pu);
  with TOIseq(pu) do
  begin
    if Ffile then sortieErreur('TOISeq : this object cannot be modified');
    AddNum(w);
  end;
end;

procedure proTOIseq_MulNum(w:float;var pu:typeUO);
begin
  verifierObjet(pu);
  with TOIseq(pu) do
  begin
    if Ffile then sortieErreur('TOISeq : this object cannot be modified');
    MulNum(w);
  end;
end;

procedure proTOIseq_Mul(var oiseq:Toiseq;var pu:typeUO);
begin
  verifierObjet(typeUO(oiseq));
  verifierObjet(pu);
  with TOIseq(pu) do
  begin
    if Ffile then sortieErreur('TOISeq : this object cannot be modified');
    if not CompatibleOIseq(oiseq) then sortieErreur('TOIseq.Add : oiseq not compatible');
    Mul(oiseq);
  end;
end;

procedure proTOIseq_Div1(var oiseq:Toiseq;th,value:float;var pu:typeUO);
begin
  verifierObjet(typeUO(oiseq));
  verifierObjet(pu);
  with TOIseq(pu) do
  begin
    if Ffile then sortieErreur('TOISeq : this object cannot be modified');
    if not CompatibleOIseq(oiseq) then sortieErreur('TOIseq.Add : oiseq not compatible');
    Div1(oiseq,th,value);
  end;
end;


procedure proTOIseq_OIVconvolve(var Hf:Tvector;src,dest:AnsiString;var pu:typeUO);
begin
  verifierObjet(pu);
  verifierVecteur(Hf);

  with TOIseq(pu) do OIVconvolve(Hf,src,dest);
end;

procedure proTOIseq_OIVaverage(var vecStim:Tvector;src,destMoy,destStd:AnsiString;var pu:typeUO);
begin
  verifierObjet(pu);
  verifierVecteur(vecStim);

  with TOIseq(pu) do OIVaverage(vecStim,src,destMoy,destStd);
end;

procedure proTOIseq_OIVSNR(var vecStim:Tvector;srcMoy,srcStd,dest:AnsiString;var pu:typeUO);
begin
  verifierObjet(pu);
  verifierVecteur(vecStim);

  with TOIseq(pu) do OIVSNR(vecStim,srcMoy,srcStd,dest);
end;

procedure proTOIseq_ReadFromGSD(stF:AnsiString;var pu:typeUO);
begin
  verifierObjet(pu);
  if not fileExists(stF) then sortieErreur('TOIseq.ReadFromGSD : unable to find '+stF);

  TOIseq(pu).ReadFromGSD(stF);
end;


procedure proTOIseqPCL_create(var pu:typeUO);
begin
  createPgObject('',pu,TOIseqPCL);
end;

procedure proTOIseqPCL_LoadFile(stf:AnsiString;var pu:typeUO);
begin
  verifierObjet(pu);
  TOIseqPCL(pu).LoadFile(stF);
end;

procedure proTOIseqPCL_InitFrames(Nx1,Ny1:integer; dt: float;var pu:typeUO);
begin
  proTOIseqPCL_InitFrames_1( Nx1,Ny1, dt, -1,-1, pu);
end;

procedure proTOIseqPCL_InitFrames_1( Nx1,Ny1:integer; dt: float; tOrg,tend:float;var pu:typeUO);
begin
  verifierObjet(pu);
  with TOIseqPCL(pu) do
  begin
    if BlockLoaded then sortieErreur('TOIseqPCL.InitFrames cannot be applied to this object');
    initFrames(Nx1,Ny1,dt,torg,tend);
  end;
end;

procedure proTOIseqPCL_BinX(w:integer;var pu:typeUO);
begin
  verifierObjet(pu);
  if (w<1) then sortieErreur('TOIseqPCL.BinX : value out of range');
  TOIseqPCL(pu).binX:=w;
end;

function fonctionTOIseqPCL_BinX(var pu:typeUO): integer;
begin
  verifierObjet(pu);
  result:=TOIseqPCL(pu).binX;
end;


procedure proTOIseqPCL_BinY(w:integer;var pu:typeUO);
begin
  verifierObjet(pu);
  if (w<1) then sortieErreur('TOIseqPCL.BinX : value out of range');
  TOIseqPCL(pu).binY:=w;
end;

function fonctionTOIseqPCL_BinY(var pu:typeUO): integer;
begin
  verifierObjet(pu);
  result:=TOIseqPCL(pu).binY;
end;

procedure proTOIseqPCL_BinDT(w:float;var pu:typeUO);
begin
  verifierObjet(pu);
  TOIseqPCL(pu).bindT:=w;
  TOIseqPCL(pu).InitFrames0(false);
end;

function fonctionTOIseqPCL_BinDT(var pu:typeUO): float;
begin
  verifierObjet(pu);
  result:=TOIseqPCL(pu).bindT;
end;


procedure proTOIseqPCL_NoOverlap(w:boolean;var pu:typeUO);
begin
  verifierObjet(pu);
  TOIseqPCL(pu).NoOverlap:= w;
  TOIseqPCL(pu).InitFrames0(false);
end;

function fonctionTOIseqPCL_NoOverlap(var pu:typeUO): boolean;
begin
  verifierObjet(pu);
  result:=TOIseqPCL(pu).NoOverlap;
end;



function fonctionTOIseqPCL_Vtimes(var pu:typeUO):Tvector;
begin
  verifierObjet(pu);
  with TOIseqPCL(pu) do result:=@Vtimes.myAd;
end;

function fonctionTOIseqPCL_Vx(var pu:typeUO):Tvector;
begin
  verifierObjet(pu);
  with TOIseqPCL(pu) do result:=@Vx.myAd;
end;

function fonctionTOIseqPCL_Vy(var pu:typeUO):Tvector;
begin
  verifierObjet(pu);
  with TOIseqPCL(pu) do result:=@Vy.myAd;
end;

function fonctionTOIseqPCL_Vz(var pu:typeUO):Tvector;
begin
  verifierObjet(pu);
  with TOIseqPCL(pu) do result:=@Vz.myAd;
end;


procedure proTvector_LoadFromSTFfile(stf:AnsiString;var pu:Tvector);
var
  f:TfileStream;
  Nb:integer;
  ii1, ii2: int64;
  i:integer;
  y:float;
begin
  verifierVecteurTemp(pu);

  if stf='' then exit;

  try
  f:=nil;
  f:= TfileStream.Create(stf,fmOpenRead);

  Nb:=f.Size div 16;
  if (Nb=0) or (f.Size mod 16<>0) then
  begin
    f.free;
    f:=nil;
    sortieErreur('Tvector.LoadFromSTFfile : bad file size');
  end;

  with Tvector(pu) do
  begin
    initTemp1(1,Nb,g_double);

    if not( modeT in [DM_evt1, DM_evt2]) then
    begin
      modeT:=DM_evt1;
      tailleT:=15;
      Ymin:=-100;
      Ymax:=100;
    end;

    for i:= 1 to Nb do
    begin
      f.Read(ii1,sizeof(ii1));
      swapInt64(ii1);

      f.Read(ii2,sizeof(ii2));
      swapInt64(ii2);

      Yvalue[i]:= ii1 + (ii2 shr 1)/ maxLongWord/maxEntierLong;
    end;
  end;

  finally
  f.free;
  end;
end;

procedure proTOIseq_Synthesis1(v, sv, rho, srho, theta, stheta: float;var pu:typeUO);
begin
  verifierObjet(pu);
  TOIseq(pu).Synthesis1( v, sv, rho, srho, theta, stheta );
end;

procedure proTOIseq_SynthesisJV(  ss, rf, tf, rs, ts, eta, alpha: float; seed: longword; Fty:boolean;var pu:typeUO);
begin
  verifierObjet(pu);

  TOIseq(pu).SynthesisJV(ss, rf, tf, rs, ts, eta, alpha, seed, Fty);
end;

function fonctionTOIseq_getRSHinfo(st: Ansistring; var value: float; var pu:typeUO): Ansistring;
begin
  verifierObjet(pu);
  result:= TOISeq(pu).getRSHinfo(st,value);
end;

procedure proTOIseq_SaveBinaryData(var fbin:TbinaryFile;tp: integer; LineFirst:boolean; var pu:typeUO);
begin
  verifierObjet(TypeUO(fBin));
  verifierObjet(pu);
  TOIseq(pu).SaveToBin(fbin.f,typetypeG(tp),LineFirst);
end;

procedure proTOIseq_LoadBinaryData(var fbin:TbinaryFile;tp: integer; LineFirst:boolean; var pu:typeUO);
begin
  verifierObjet(TypeUO(fBin));
  verifierObjet(pu);
  TOIseq(pu).LoadFromBin(fbin.f,typetypeG(tp),LineFirst);
end;


procedure TOIseqPCL.DBtoPCLfilter(db: TDBrecord);
begin
  if not assigned(db) then exit;

  photonFilter.Vx:=   db.value['Vx'].Vfloat;
  photonFilter.Vy:=   db.value['Vy'].Vfloat;
  photonFilter.RotX:= db.value['RotX'].Vfloat;
  photonFilter.RotY:= db.value['RotY'].Vfloat;
  photonFilter.RotTheta:= db.value['RotTheta'].Vfloat;
  photonFilter.Dx:=   db.value['Dx'].Vfloat;
  photonFilter.Dy:=   db.value['Dy'].Vfloat;

  if photonFilter.Dx<=0 then photonFilter.Dx:=1;
  if photonFilter.Dy<=0 then photonFilter.Dy:=1;

end;

procedure TOIseqPCL.PCLfilterToDB(db: TDBrecord);
var
  gv: TGvariant;
begin
  if not assigned(db) then exit;
  gv.init;

  gv.Vfloat:= photonFilter.Vx;
  db.setvalue('Vx',gv);

  gv.Vfloat:= photonFilter.Vy;
  db.setvalue('Vy',gv);

  gv.Vfloat:= photonFilter.RotX;
  db.setvalue('RotX',gv);

  gv.Vfloat:= photonFilter.RotY;
  db.setvalue('RotY',gv);

  gv.Vfloat:= photonFilter.RotTheta;
  db.setvalue('RotTheta',gv);

  gv.Vfloat:= photonFilter.Dx;
  db.setvalue('Dx',gv);

  gv.Vfloat:= photonFilter.Dy;
  db.setvalue('Dy',gv);
end;

{ TOIscaleProp }

function TOIscaleProp.getDx: single;
begin
 if i1<>i2
    then result:=(x2-x1)/(i2-i1)
    else result:=1;
end;

function TOIscaleProp.getDy: single;
begin
 if j1<>j2
    then result:=(y2-y1)/(j2-j1)
    else result:=1;
end;

function TOIscaleProp.getX0: single;
var
  dyB:float;
begin
  if i1<>i2
    then dyB:=(x2-x1)/(i2-i1)
    else dyB:=1;

  result:= x1-i1*DyB;
end;

function TOIscaleProp.getY0: single;
var
  dyB:float;
begin
  if j1<>j2
    then dyB:=(y2-y1)/(j2-j1)
    else dyB:=1;

  result:= y1-j1*DyB;
end;


procedure TOIscaleProp.init;
begin
  i2:=512;
  x2:=512;
  j2:=512;
  y2:=512;

end;

procedure TOIscaleProp.initValues(Dxu, x0u, Dyu, y0u: float; i1a,i2a,j1a,j2a: integer);
begin
  if (i1a<>i2a) and (j1a<>j2a) then
  begin
    i1:=i1a;
    i2:=i2a;
    j1:=j1a;
    j2:=j2a;
  end
  else
  begin
    i1:=0;
    i2:=512;
    j1:=0;
    j2:=512;
  end;

  x1:=x0u + i1*dxu;
  x2:=x0u + i2*Dxu;

  if j1=j2 then
  begin
    j1:=0;
    j2:=1;
  end;
  y1:=y0u + j1*dyu;
  y2:=y0u + j2*dyu;

end;


procedure TOIseqPCL.FilterPhoton(var i, j: smallint);
var
  x,y,x1,y1:single;
  th:single;
begin
  x:=Dxu0*i+x0u;
  y:=Dyu0*j+y0u;

  with PhotonFilter do
  begin
    x:= x+Vx;
    y:= y+Vy;

    degRotation(x,y,x1,y1,RotX,RotY,RotTheta);

    x1:= Dx*x1;
    y1:= Dy*y1;
  end;
  i:=round( (x1-x0u)/Dxu0 );
  j:=round( (y1-y0u)/Dyu0 );
end;

procedure TOIseqPCL.UpdateFilter;
begin
  FilterTabPhoton(0,-1 );
  initFrames0(true);
  invalidate;
end;


procedure proTOIseqPCL_InstallFilter(x1,y1,dx1,dy1,theta1:float;var pu:typeUO);
begin
  verifierObjet(pu);
  with TOIseqPCL(pu) do
  begin

  end;
end;




Initialization
AffDebug('Initialization stmOIseq1',0);

registerObject(TOIseq,sys);

OIlist:=Tlist.create;

finalization

OIlist.free;
end.

