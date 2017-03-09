unit stmdf0;

interface

uses windows, classes, sysutils, forms, comCtrls,Dialogs,Controls,graphics,menus,

     util1,Gdos,dtf0,Spk0, Dgraphic ,Dtrace1,ficDefAc,Dgrad1,Ddosfich,
     visu0,tpVector,cood0,varconf1,
     defForm,getVect0,
     stmdef,stmObj,stmdata0,stmvec1,
     descac1,descABF,descPcl,descBMF,descEPC9,descElphy1,
     tdff0,getEp0,
     debug0,
     stmAve1,
     DmoyAc2,
     stmError,Ncdef2,stmPg,
     {stmFpg,       supprimé le 8 octobre 2010 }
     stmVlist1,
     dac2file,dfSave1,
     acqDef2,AcqInf2,StimInf2,
     AcqBrd1,
     stmMemo1,
     Mtag2,
     stmPlay1,
     saveOpt1,
     stmPopUp,

     dataGeneFile,
     OIblock1,stmOIseq1,
     DBrecord1,
     stmVecSpk1, stmSpkWave1, stmSpkTable1,
     doubleExt,
     ObjFile1,
     BinaryFileForm1,
     DescBinary1;




var
  TestedFiles:array[0..19] of boolean;

  DataFileRecBin: TbinaryRec;
  stBinPrm: AnsiString;

const
  MaxVtag=16;
  MaxAdcCh=256;
  MaxSpkCh=512;

type
  TdataFile=class(Tdata0)
              FileDesc:TfileDescriptor;

              maxChan:integer;
              maxChanR:integer;

              maxSpk: integer;
              maxSpkUnit:integer; // nb total d'unités en incluant la valeur 0
              maxSpkR, maxSpkUnitR:integer;
              HasPCL:boolean;

              data0:array of typeDataB;
              dataTag:array[1..MaxVtag] of typeDataB;
              dataSound:array[1..2] of typeDataB;

              dataSpk:array of typeDataB;   { dates des spikes pour chaque électrode }
              dataAtt:array of typeDataB;   { leurs attributs (numéros d'unité) }
              dataSpkW:array of typeDataB;  { spike waveforms }

              Fchannel:array of Tvector;
              Fmoy:    array of Taverage;
              Vlist:   array of TVlistDF;

              Vtag:    array[1..MaxVtag] of Tvector;
              Vsound:  array[1..2] of Tvector;
              Fspk:    array of TvectorSpk;
              FWspk:   array of TwaveList;

              FPCL: TOIseqPCL;

              SpkTable:TspkTable;

              memoC:TstmMemo;
              Mtag:TMtagVector;

              Vdum:Tvector;

              FmoyValid:boolean;

              IstartMoy,IendMoy:integer;
              TypeMoy:typetypeG;

              FepNum:integer;
              FepCount:integer;

              stGen,stFichier:ShortString;
              stHis:AnsiString;

              averageForm:TaverageBox;

              TagList:Tlist;
              FmoyStd:boolean;

              afficherNomDat:procedure (st:AnsiString) of object;
              afficherNumSeq:procedure (num:integer) of object;

              stSave:AnsiString;
              chToSave:arrayOfBoolean;
              XorgSave,XstartSave,XendSave:float;
              FileBlock,EpBlock:integer;
              FCopyFileInfo,FCopyEpInfo:boolean;
              Fcontinu:boolean;

              StimInfo:PparamStim;
              AcqInfo:PacqRecord;
              AcqOn:boolean;

              player:TvectorPlayer;

              stSaveMoy:AnsiString;

              NsVFlag: array[1..MaxSpkCh] of boolean;
              NsVtagFlag: array[1..16] of boolean;

              SpkTableNum:integer;
              PeriodeMicro: float;

              OnChange:Tpg2Event;
              OnChangeEpisode:Tpg2Event;
              NumPCLfilter: integer;

              visuInfo: TDBrecord;

              function channel(i:integer):Tvector;  // i commence à 1
              function Vspk(i:integer):TvectorSpk;
              function Wspk(i:integer):TwaveList;


              procedure setTag(n:integer;b:boolean);
              function getTag(n:integer):boolean;

              property Moytag[n:integer]:boolean read getTag write setTag;


              constructor create;override;
              procedure setVectors(nb:integer);
              procedure SetData0Length(nb:integer;invaliderAff:boolean);

              procedure setSPKs(nb,nbU:integer);
              procedure SetDataSpkLength(nb:integer;invaliderAff:boolean);

              procedure initPCL(w:boolean);

              procedure addToTree(tree:TtreeView;node:TtreeNode);override;

              destructor destroy;override;
              procedure installFile(st:AnsiString;FinitMoy:boolean;NoError:boolean);
              procedure installFile0(st:AnsiString;FinitMoy:boolean;NoError:boolean);

              procedure installBinaryFile(st:AnsiString;NoError:boolean);
              procedure installBinaryFile0(st:AnsiString;NoError:boolean);
              procedure updateElphyFile;

              procedure InitData(InvaliderAff,forcerFree:boolean);
              procedure initMoy;

              procedure initAcq(stf:AnsiString;numInit,numS:integer;reprise,modifNumSeq:boolean);

              {associe les vecteurs au buffer d'acquisition}
              procedure initDataSeq(numInit,numS:integer);
              procedure initDataCont(Samples:integer);

              {versions MultiMainBuf }
              procedure initDataSeqMulti(numInit,numS:integer);
              procedure initDataContMulti(Samples:integer);


              procedure initDataAcq(numInit,numS:integer);
              procedure doneAcq(Ffile:boolean;numInit,numS:integer);



              class function STMClassName:AnsiString;override;

              procedure createForm;override;

              procedure BuildInfo(var conf:TblocConf;lecture,tout:boolean);override;
              procedure completeLoadInfo;override;


              function IdentifierID(stID:AnsiString;var n,num:integer):boolean;
              procedure saveToStream( f:Tstream;Fdata:boolean);override;
              function  loadFromStream(f:Tstream;size:LongWord;Fdata:boolean):boolean;override;


              procedure DloadFile;
              procedure DloadBinaryFile;
              procedure GetBinaryFileParams;

              procedure DnextFile;
              procedure DpreviousFile;
              procedure DFileInfo;

              procedure ReloadFile;
              procedure CloseLastDataBlock;

              procedure Daveraging;

              function setEpNum(num:integer):boolean;
              procedure DnextSeq;
              procedure DprevSeq;

              function initialise(st:AnsiString):boolean;override;
              procedure setChildNames;override;
              procedure resetTitles;override;

              procedure chooseEpisode;

              procedure Dtag;
              procedure Dtag1(x:float);
              procedure Duntag;
              procedure DclearMoy;
              procedure DtagBloc;
              function DgetStTag:AnsiString;


              property EpCount:integer read FepCount;
              property EpNum:integer read FepNum;


              procedure sauverMoyPg(var f:file;preseq,postSeq,FileInfoSize:integer;
                                 typeData:typetypeG);

              function getFileName:AnsiString;

              procedure installVlist;
              procedure displaySubG(voie,numS:integer);
              procedure displaySubG1(voie,numS:integer);
              procedure saveListG(voie:integer;Modeappend:boolean);
              procedure saveListAsDataFile(voie:integer;modeAppend:boolean);
              procedure saveListAsText;

              (*
              procedure saveListG1(voie:integer;Modeappend:boolean);
              procedure saveListAsDataFile1(voie:integer;modeAppend:boolean);
              *)
              procedure getXlimits(var visu1:TvisuInfo;voie:integer);
              procedure getYlimits(var visu1:TvisuInfo;voie:integer);

              function getSM2info(stName,st:AnsiString;var w;size,tp:word):boolean;
              function getSM2RF(var x,y,dx,dy,theta:float):boolean;

              function getCloneG(voie,numseq:integer):Tvector;

              function getVSposition:integer;

              procedure copyToBuffer(buf:pointer;bufSize:integer);

              procedure MessageCpl;

              procedure TrackPosition(ep:integer;x:float);
              procedure PlayFile;

              function channelCount:integer;
              function SpkCount:integer;

              function ContinuousFile:boolean;
              procedure setMoyStd(w:boolean);
              procedure SaveAverage(ModeAppend:boolean);
              procedure InitAverages(tp:typetypeG;i1,i2:integer);
              procedure setAverageType(tp:typetypeG);

              function SearchAndload(st:AnsiString;numOc:integer;pu:typeUO):boolean;
              function SearchClassAndload(numOc:integer;pu:typeUO):boolean;

              function getPopUp:TpopupMenu;override;
              procedure Proprietes(sender:Tobject);override;

              function isElphyFile:boolean;
              function OIseqCount:integer;
              function getOIseq(n:integer):TOIseq;
              property OIseqs[n:integer]:TOIseq read getOIseq;

              function getOIseq1(n:integer; Finit:boolean):TOIseq;

              procedure AppendOIblocks(stSrc:AnsiString);
              function AppendObject(ob:typeUO): int64;

              procedure FreeFileStream;

              procedure BuildOIvecFile(stF:AnsiString);
              procedure setOIvecFile(stF:AnsiString);

              function SpkTableOK(table: TspkTable):boolean;

              function InitSpkTable(table: TspkTable):boolean;

              procedure ClearSpkTable;
              function SetSpkTable(table: TspkTable):boolean;
              function loadSpkTable(n:integer):boolean;
              procedure UpdateSpkTable;

              procedure processMessage(id:integer;source:typeUO;p:pointer);override;
              function getNsVector(id:integer;var tpNs:integer):Tvector;

              function VtagCount:integer;

              procedure BuildSpkArrays(var spk:TspkArray; var Att:TattArray);

              procedure getNSflags;

              procedure TestDF;


              function fileStream: TStream;
              procedure VerifyVectorLengths(nbAdc, NbSpk, NbUnit: integer);

              function ElphyDataTime(ep:integer): TdateTime;
              function EpPCTime(ep:integer): longword;
              procedure getVisuInfo;


            end;

function datafile0:TdataFile;

{Méthodes Stm de TdataFile}

procedure proTdataFile_create(name:AnsiString;var pu:typeUO);pascal;
procedure proTdataFile_create_1(var pu:typeUO);pascal;

function fonctionTdataFile_V(i:integer;var pu:typeUO):pointer;pascal;

function fonctionTdataFile_v1(var pu:typeUO):pointer;pascal;
function fonctionTdataFile_v2(var pu:typeUO):pointer;pascal;
function fonctionTdataFile_v3(var pu:typeUO):pointer;pascal;
function fonctionTdataFile_v4(var pu:typeUO):pointer;pascal;
function fonctionTdataFile_v5(var pu:typeUO):pointer;pascal;
function fonctionTdataFile_v6(var pu:typeUO):pointer;pascal;

function fonctionTdataFile_m(i:integer;var pu:typeUO):pointer;pascal;

function fonctionTdataFile_m1(var pu:typeUO):pointer;pascal;
function fonctionTdataFile_m2(var pu:typeUO):pointer;pascal;
function fonctionTdataFile_m3(var pu:typeUO):pointer;pascal;
function fonctionTdataFile_m4(var pu:typeUO):pointer;pascal;
function fonctionTdataFile_m5(var pu:typeUO):pointer;pascal;
function fonctionTdataFile_m6(var pu:typeUO):pointer;pascal;

function fonctionTdataFile_Vspk(i:integer;var pu:typeUO):pointer;pascal;
function fonctionTdataFile_Wspk(i:integer;var pu:typeUO):pointer;pascal;
function fonctionTdataFile_VspkCount(var pu:typeUO):integer;pascal;

function fonctionTdataFile_Vtag(i:integer;var pu:typeUO):pointer;pascal;
function fonctionTdataFile_Vtag1(var pu:typeUO):pointer;pascal;
function fonctionTdataFile_Vtag2(var pu:typeUO):pointer;pascal;

function fonctionTdataFile_Vsound(i:integer;var pu:typeUO):pointer;pascal;
function fonctionTdataFile_Vsound1(var pu:typeUO):pointer;pascal;
function fonctionTdataFile_Vsound2(var pu:typeUO):pointer;pascal;

function fonctionTdataFile_PCL(var pu:typeUO):pointer;pascal;

function fonctionTdataFile_Mtag(var pu:typeUO):pointer;pascal;

function fonctionTdataFile_nbSeq(var pu:typeUO):integer;pascal;
function fonctionTdataFile_nbvoie(var pu:typeUO):integer;pascal;

procedure proTdataFile_afficherNumSeq(var pu:typeUO);pascal;
procedure proTdataFile_setNumSeq(n:integer;var pu:typeUO);pascal;

function fonctionTdataFile_NumSeq(var pu:typeUO):integer;pascal;
procedure proTdataFile_NumSeq(n:integer;var pu:typeUO);pascal;

function fonctionTdataFile_NbPtSeq(var pu:typeUO):integer;pascal;
function fonctionTdataFile_NomData(var pu:typeUO):AnsiString;pascal;
function fonctionTdataFile_CheminData(var pu:typeUO):AnsiString;pascal;
function fonctionTdataFile_ExtData(var pu:typeUO):AnsiString;pascal;


procedure proTdataFile_NouveauFichier(st:AnsiString;var pu:typeUO);pascal;
procedure proTdataFile_NouveauFichier_1(st:AnsiString;var errCode:integer;var pu:typeUO);pascal;

procedure proTdataFile_ClearAverage(var pu:typeUO);pascal;
procedure proTdataFile_AddToAverage(var pu:typeUO);pascal;
procedure proTdataFile_AddToAverage1(x:float;var pu:typeUO);pascal;

{procedure proTdataFile_SaveAverage(numF:integer;var pu:typeUO);pascal;}

procedure proTdataFile_StdON(w:boolean;var pu:typeUO);pascal;
function fonctionTdataFile_StdON(var pu:typeUO):boolean;pascal;
procedure proTdataFile_InitAverages(tp,i1,i2:integer;var pu:typeUO);pascal;
procedure proTdataFile_AverageType(n:integer;var pu:typeUO);pascal;
function fonctionTdataFile_AverageType(var pu:typeUO):integer;pascal;


procedure proTdataFile_GetEpInfo(var x;size:integer;tpn:word;dep:integer;var pu:typeUO);pascal;
procedure proTdataFile_SetEpInfo(var x;size:integer;tpn:word;dep:integer;var pu:typeUO);pascal;
procedure proTdataFile_ReadEpInfo(var x;size:integer;tpn:word;var pu:typeUO);pascal;
procedure proTdataFile_ReadEpInfoExt(var x;size:integer;tpn:word;var pu:typeUO);pascal;
procedure proTdataFile_WriteEpInfo(var x;size:integer;tpn:word;var pu:typeUO);pascal;
procedure proTdataFile_WriteEpInfoExt(var x;size:integer;tpn:word;var pu:typeUO);pascal;
procedure proTdataFile_ResetEpInfo(var pu:typeUO);pascal;

procedure proTdataFile_GetFileInfo(var x;size:integer;tpn:word;dep:integer;var pu:typeUO);pascal;
procedure proTdataFile_SetFileInfo(var x;size:integer;tpn:word;dep:integer;var pu:typeUO);pascal;
procedure proTdataFile_ReadFileInfo(var x;size:integer;tpn:word;var pu:typeUO);pascal;
procedure proTdataFile_ReadFileInfoExt(var x;size:integer;tpn:word;var pu:typeUO);pascal;
procedure proTdataFile_WriteFileInfo(var x;size:integer;tpn:word;var pu:typeUO);pascal;
procedure proTdataFile_WriteFileInfoExt(var x;size:integer;tpn:word;var pu:typeUO);pascal;
procedure proTdataFile_ResetFileInfo(var pu:typeUO);pascal;

function fonctionTdataFile_EpInfoSize(var pu:typeUO):integer;pascal;
function fonctionTdataFile_FileInfoSize(var pu:typeUO):integer;pascal;

procedure proTdataFile_ReadDBFileInfo(var db:TDBrecord; var pu:typeUO);pascal;
procedure proTdataFile_ReadDBepInfo(var db:TDBrecord; var pu:typeUO);pascal;



function fonctionTdataFile_Comment(var pu:typeUO):pointer;pascal;

function fonctionTdataFile_getSM2info
  (stName,st:AnsiString;var w;size,tp:word;var pu:typeUO):boolean;pascal;

function fonctionTdataFile_getSM2RF
  (var x,y,dx,dy,theta:float;var pu:typeUO):boolean;pascal;

function fonctionTdataFile_StimInfo(var pu:typeUO):pointer;pascal;
function fonctionTdataFile_AcqInfo(var pu:typeUO):pointer;pascal;

function fonctionTdataFile_SearchAndload(st:AnsiString;numOc:integer;var ob,pu:typeUO):boolean;pascal;
function fonctionTdataFile_SearchTypeAndload(numOc:integer;var ob,pu:typeUO):boolean;pascal;

function fonctionTdataFile_OIseqCount(var pu:typeUO):integer;pascal;
function fonctionTdataFile_OIseq(n:integer;var pu:typeUO):pointer;pascal;

procedure proTdataFile_BuildOIvecFile(stF: AnsiString;var pu:typeUO);pascal;
procedure proTdataFile_setOIvecFile(stF: AnsiString;var pu:typeUO);pascal;

procedure proTdataFile_AppendOI(Src: AnsiString;var pu:typeUO);pascal;
procedure proTdataFile_AppendObject(var ob, pu:typeUO);pascal;

procedure proTdataFile_InitSpkTable(var table:TspkTable;var pu:typeUO);pascal;
procedure proTdataFile_SetSpkTable(var table:TspkTable;var pu:typeUO);pascal;
procedure proTdataFile_LoadSpkTable(n:integer;var pu:typeUO);pascal;

function fonctionTdataFile_MaxChannelCount(var pu:typeUO):integer;pascal;
function fonctionTdataFile_MaxVspkCount(var pu:typeUO):integer;pascal;

function fonctionTdataFile_CyberTime(ep:integer; var pu:typeUO):float;pascal;
function fonctionTdataFile_CorrectedCyberTime(ep:integer; var pu:typeUO):float;pascal;

function fonctionTdataFile_Vcounts(num,ep:integer; var pu:typeUO):integer;pascal;
function fonctionTdataFile_VtagCounts(num,ep:integer; var pu:typeUO):integer;pascal;
function fonctionTdataFile_VspkCounts(num,ep:integer; var pu:typeUO):integer;pascal;


function fonctionTdataFile_DataFileSize(var pu:typeUO):int64;pascal;
function fonctionTdataFile_DataFileAge(var pu:typeUO):TdateTime;pascal;


procedure proTdataFile_OnChange(p:integer;var pu:typeUO);pascal;
function fonctionTdataFile_OnChange(var pu:typeUO):integer;pascal;
procedure proTdataFile_OnChangeEpisode(p:integer;var pu:typeUO);pascal;
function fonctionTdataFile_OnChangeEpisode(var pu:typeUO):integer;pascal;

function fonctionTdataFile_ElphyTime(ep:integer; var pu:typeUO):TdateTime;pascal;
function fonctionTdataFile_EpPCTime(ep:integer; var pu:typeUO): longword;pascal;

procedure proTdataFile_CopyBlockTo(var f: TobjectFile; num: integer;var pu:typeUO);pascal;
function fonctionTdataFile_ClassNames(n:integer;var pu:typeUO):AnsiString;pascal;
function fonctionTdataFile_Objcount(var pu:typeUO):integer;pascal;

function fonctionTdataFile_VisuInfo(var pu: typeUO):pointer;pascal;

procedure proTdataFile_FreeFileStream(var pu:typeUO);pascal;

procedure proElphyFileToAnalogBinaryFile(stSrc,stDest: AnsiString; var Vchan: Tvector; DW: integer;mux:boolean;var VstartPos: Tvector);pascal;

implementation

uses multg1,DFprop1,NSflags1;

var
  E_channel:integer;
  E_affectation:integer;
  E_traceEv:integer;
  E_noData:integer;
  E_numseq:integer;
  E_InstallDataFile:integer;
  E_accumulerCont:integer;
  E_accumulerNotCont:integer;
  E_Acquis1DataFile:integer;

  E_setEpInfo:integer;
  E_getEpInfo:integer;

  E_setFileInfo:integer;
  E_getFileInfo:integer;
  E_Vtag:integer;
  E_Vsound:integer;

  E_MoyStd:integer;
  E_typeMoy:integer;
  E_extentMoy:integer;

const


  stFiltre='*.dat|*.dat|*.moy|*.moy|*.*|*.*';
  Ifiltre:integer=1;


procedure TdataFile.setVectors(nb:integer);
var
  i,oldnb:integer;
begin
  oldNb:=length(Fchannel);
  maxChan:=nb;

  for i:=maxChan to oldNb-1 do    { si nb<oldNb, détruire les objets }
  begin
    Fchannel[i].free;
    Fmoy[i].free;
    Vlist[i].Free;
  end;

  setLength(Fchannel,maxChan);     { ajuster la taille des tableaux }
  setLength(Fmoy,maxChan);
  setLength(Vlist,maxChan);


  for i:=oldNb to maxChan-1 do    {si nb>oldNb, créer les objets }
  begin
    Fchannel[i]:=Tvector.create;
    Fchannel[i].notPublished:=true;
    Fchannel[i].Fchild:=true;
    Fchannel[i].AcqFlag:=true;

    Fmoy[i]:=Taverage.create;
    Fmoy[i].flags.Findex:=false;
    Fmoy[i].flags.Ftype:=false;

    Fmoy[i].notPublished:=true;
    Fmoy[i].Fchild:=true;

    Vlist[i]:=TVlistDF.create;
    Vlist[i].notPublished:=true;
    Vlist[i].Fchild:=true;
  end;

  setLength(ChToSave,maxChan);
  fillchar(chToSave[0],maxChan,0);

end;

procedure TdataFile.SetData0Length(nb:integer;invaliderAff:boolean);
var
  i,nbOld:integer;
begin
  nbOld:=length(data0);
  for i:=nb to nbOld-1 do
    begin
      data0[i].free;
      data0[i]:=nil;
      Fchannel[i].initDat2(nil,G_smallint,invaliderAff);
    end;

  setLength(data0,nb);
  if nb>nbOld then fillchar(data0[nbold],sizeof(data0[0])*(nb-nbold),0);
end;

procedure TdataFile.setSPKs(nb,nbU:integer);
var
  i,oldnb:integer;
begin
  oldNb:=length(Fspk);
  maxSpk:=nb;

  for i:=maxSpk to oldNb-1 do    { si nb<oldNb, détruire les objets }
  begin
    Fspk[i].free;
    FWspk[i].free;
  end;

  setLength(Fspk,maxSpk);        { ajuster la taille des tableaux }
  setLength(FWspk,maxSpk);        { ajuster la taille des tableaux }

  for i:=oldNb to maxSpk-1 do    {si nb>oldNb, créer les objets }
  begin
    Fspk[i]:=TvectorSpk.create;
    Fspk[i].notPublished:=true;
    Fspk[i].Fchild:=true;
    Fspk[i].AcqFlag:=true;

    FWspk[i]:=TwaveList.create;
    FWspk[i].setVectors(6);
    FWspk[i].notPublished:=true;
    FWspk[i].Fchild:=true;
    FWspk[i].AcqFlag:=true;
  end;

  for i:=0 to maxSpk-1 do
  begin
    Fspk[i].setVectors(nbU);
    Fspk[i].setChildNames;

    FWspk[i].setVectors(nbU);
    FWspk[i].setChildNames;
  end;
  maxSpkUnit:=nbU;
end;

procedure TdataFile.initPCL(w: boolean);
begin
  if w then
  begin
    if not assigned(FPCL) then
    begin
      FPCL:=TOIseqPCL.create;
      FPCL.notPublished:=true;
      FPCL.Fchild:=true;
    end;
  end
  else
  begin
    FPCL.free;
    FPCL:=nil;
  end;
end;

procedure TdataFile.SetDataSpkLength(nb:integer;invaliderAff:boolean);
var
  i,nbOld:integer;
begin
  nbOld:=length(dataSpk);
  for i:=nb to nbOld-1 do     // utile si nb<nbold
  begin
    dataSpk[i].free;
    dataSpk[i]:=nil;
    dataAtt[i].free;
    dataAtt[i]:=nil;
    dataSpkW[i].free;
    dataSpkW[i]:=nil;

    Fspk[i].initData(nil,nil,invaliderAff);
    FWspk[i].initRawData(dataSpkW[i],dataAtt[i]);
  end;

  setLength(dataSpk,nb);
  setLength(dataAtt,nb);
  setLength(dataSpkW,nb);
  if nb>nbOld then
  begin
    fillchar(dataSpk[nbold],sizeof(dataSpk[0])*(nb-nbold),0);
    fillchar(dataAtt[nbold],sizeof(dataAtt[0])*(nb-nbold),0);
    fillchar(dataSpkW[nbold],sizeof(dataSpkW[0])*(nb-nbold),0);
  end;
end;



constructor TdataFile.create;
var
  i:integer;
begin
  inherited create;

  setVectors(8);

  maxSpkUnit:=5;
  maxSpkUnitR:=5;

  IstartMoy:=-1000;
  IendMoy:=1000;
  typeMoy:=g_single;

  tagList:=Tlist.create;

  for i:=1 to MaxVtag do
    begin
      Vtag[i]:=Tvector.create;
      Vtag[i].notPublished:=true;
      Vtag[i].Fchild:=true;
      Vtag[i].AcqFlag:=true;

      Vtag[i].Ymin:=-2;
      Vtag[i].Ymax:=+2;
      Vtag[i].modeT:=DM_evt1;
    end;

  for i:=1 to 2 do
    begin
      Vsound[i]:=Tvector.create;
      Vsound[i].notPublished:=true;
      Vsound[i].Fchild:=true;
    end;


  memoC:=TstmMemo.create;
  with memoC do
  begin
    init(nil);
    notPublished:=true;
    Fchild:=true;
  end;

  Mtag:=TMtagVector.create;
  Mtag.notPublished:=true;
  Mtag.Fchild:=true;
  Mtag.dfOwner:=self;

  Vdum:=Tvector.Create;
  Vdum.notPublished:=true;
  Vdum.Fchild:=true;

  move(NSVflagGlb,NSVflag,sizeof(NSVflag));
  move(NSVtagflagGlb,NSVtagflag,sizeof(NSVtagflag));
  SpkTableNum:=SpkTableNumGlb;
end;


procedure TdataFile.addToTree(tree:TtreeView;node:TtreeNode);
var
  i:integer;
  st:AnsiString;
  p,p0,p1:TtreeNode;
begin
  p0:=tree.Items.addChildObject(node,ident,self);

  p1:=tree.Items.addChildObject(p0,'channels',nil);
  for i:=0 to maxChan-1 do Fchannel[i].addToTree(tree,p1);

  if maxSpk>0 then
  begin
    p1:=tree.Items.addChildObject(p0,'Vspk',nil);
    for i:=0 to maxSpk-1 do Fspk[i].addToTree(tree,p1);

    p1:=tree.Items.addChildObject(p0,'Wspk',nil);
    for i:=0 to maxSpk-1 do FWspk[i].addToTree(tree,p1);
  end;

  p1:=tree.Items.addChildObject(p0,'averages',nil);
  for i:=0 to maxChan-1 do Fmoy[i].addToTree(tree,p1);

  p1:=tree.Items.addChildObject(p0,'Vlist',nil);
  for i:=0 to maxChan-1 do Vlist[i].addToTree(tree,p1);

  p1:=tree.Items.addChildObject(p0,'Vtags',nil);
  for i:=1 to MaxVtag do Vtag[i].addToTree(tree,p1);

  p1:=tree.Items.addChildObject(p0,'Vsounds',nil);
  for i:=1 to 2 do Vsound[i].addToTree(tree,p1);

  Mtag.addToTree(tree,p0);
  memoC.addToTree(tree,p0);


  if OIseqCount>0 then
  begin
    p1:=tree.Items.addChildObject(p0,'OIseqs',nil);
    for i:=1 to OIseqCount do OISeqs[i-1].addToTree(tree,p1);
  end;

  if assigned(FPCL) then FPCL.addToTree(tree,p0);
end;

function compare(p1,p2:pointer):integer;
begin
  if intG(p1)<intG(p2) then compare:=-1
  else
  if intG(p1)=intG(p2) then compare:=0
  else compare:=1;
end;

procedure TdataFile.setTag(n:integer;b:boolean);
var
  i:integer;
begin
  with tagList do
  begin
    i:=indexof(pointer(n));
    if b then
      begin
        if i<0 then
          begin
            add(pointer(n));
            sort(compare);
          end;
      end
    else
      begin
        if i>=0 then
          begin
            delete(i);
            pack;
          end;
      end;
  end;
end;

function TdataFile.getTag(n:integer):boolean;
begin
  getTag:=tagList.indexof(pointer(n))>=0;
end;


procedure TdataFile.setChildNames;
var
  i:integer;
begin
  for i:=0 to maxChan-1 do
  begin
    Fchannel[i].ident:=ident+'.v'+Istr(i+1);
    Fchannel[i].Fchild:=true;
    Fchannel[i].NotPublished:=true;

    Fchannel[i].inf.readOnly:=true;

    Fmoy[i].ident:=ident+'.m'+Istr(i+1);
    with Fmoy[i] do
    begin
      Fchild:=true;
      NotPublished:=true;
      inf.readOnly:=false;
      flags.Findex:=false;
      flags.Ftype:=false;

      setChildNames;
    end;

    Vlist[i].ident:=ident+'.Vlist'+Istr(i+1);
    with Vlist[i] do
    begin
      Fchild:=true;
      NotPublished:=true;
    end;
  end;

  for i:=0 to maxSpk-1 do
  with Fspk[i] do
  begin
    ident:=self.ident+'.Vspk'+Istr(i+1);
    Fchild:=true;
    NotPublished:=true;
    modeT:=DM_EVT1;
    readOnly:=true;
    setChildNames;
  end;

  for i:=0 to maxSpk-1 do
  with FWspk[i] do
  begin
    ident:=self.ident+'.Wspk'+Istr(i+1);
    Fchild:=true;
    NotPublished:=true;
    readOnly:=true;
    setChildNames;
  end;



  for i:=1 to MaxVtag do
    if assigned(Vtag[i]) then
    begin
      Vtag[i].ident:=ident+'.Vtag'+Istr(i);
      with Vtag[i] do
      begin
        Fchild:=true;
        NotPublished:=true;
        inf.readOnly:=false;
        if modeT in [DM_evt1,DM_evt2] then modeT:=DM_line;
      end;
    end;

  for i:=1 to 2 do
    if assigned(Vsound[i]) then
    begin
      Vsound[i].ident:=ident+'.Vsound'+Istr(i);
      with Vsound[i],visu do
      begin
        Fchild:=true;
        NotPublished:=true;
        inf.readOnly:=false;
      end;
    end;


  memoC.ident:=ident+'.Comment';
  with memoC do
  begin
    Fchild:=true;
  end;

  Mtag.ident:=ident+'.Mtag';
  with Mtag do
  begin
    Fchild:=true;
  end;

  if assigned(FPCL) then
  with FPCL do
  begin
    ident:=self.ident+'.PCL';
    Fchild:=true;
    NotPublished:=true;
    readOnly:=true;
    setChildNames;
  end;


end;

procedure TdataFile.resetTitles;
var
  i:integer;
begin
  for i:=0 to maxChan-1 do
  begin
    Fchannel[i].title:='';
    Fmoy[i].title:='';

    Vlist[i].title:='';
  end;

  for i:=0 to maxSpk-1 do
    Fspk[i].title:='';

  for i:=0 to maxSpk-1 do
    FWspk[i].title:='';

  for i:=1 to MaxVtag do
    if assigned(Vtag[i]) then
      Vtag[i].title:='';

  for i:=1 to 2 do
    if assigned(Vsound[i]) then Vsound[i].title:='';

  memoC.title:='';

  Mtag.title:='';

  if assigned(FPCL) then
    FPCL.title:='';
end;



destructor TdataFile.destroy;
var
  i:integer;
begin
  averageForm.free;

  setVectors(0);
  setSpks(0,0);

  tagList.free;

  for i:=1 to MaxVtag do
  Vtag[i].free;

  for i:=1 to 2 do
  Vsound[i].free;

  affdebug('stmdf0.destroy 1 Mtag='+Istr(intG(Mtag))+
           ' MtagForm='+Istr(intG(Mtag.form)),6);
  Mtag.free;

  fileDesc.free;
  fileDesc:=nil;

  for i:=0 to high(data0) do data0[i].free;
  for i:=0 to high(dataSpk) do dataSpk[i].free;
  for i:=0 to high(dataAtt) do dataAtt[i].free;

  for i:=1 to MaxVtag do dataTag[i].free;


  memoC.free;

  Vdum.free;

  Player.free;

  clearSpkTable;

  FPCL.Free;
  
  inherited destroy;
end;

class function TdataFile.STMClassName:AnsiString;
begin
  STMClassName:='DataFile';
end;

procedure TdataFile.initData(InvaliderAff,forcerFree:boolean);
var
  i:integer;
  nbOld:integer;
  evtMode:boolean;
  x0uTag,dxuTag:float;
  Tags:TTagRecArray;
  WFlen,WFpretrig:integer;
  scaling: TspkWaveScaling;
  db:TDBrecord;
  nF:integer;

begin
  if (fileDesc=nil) or forcerFree then
    begin
      setData0Length(0,invaliderAff);

      for i:=1 to MaxVtag do
        begin
          dataTag[i].free;
          dataTag[i]:=nil;
          Vtag[i].initDat2(nil,G_smallint,invaliderAff);
        end;

      for i:=1 to 2 do
        begin
          dataSound[i].free;
          dataSound[i]:=nil;
          Vsound[i].initDat2(nil,G_smallint,invaliderAff);
        end;


      Mtag.initdata(nil,0,1);
    end
  else
  with filedesc do
  begin
    initEpisod(FepNum);

    if (nbvoie>maxChan) or (nbSpk>maxSpk) then
    begin
      if (nbvoie>maxChan) then setVectors(nbvoie);
      if (nbSpk>maxSpk) then setSpks(nbSpk,maxSpkUnit);
      setChildNames;
    end;

    setData0Length(nbvoie,invaliderAff);
    setDataSpkLength(nbSpk,invaliderAff);

    for i:=0 to nbvoie-1 do
      begin
        data0[i].free;
        data0[i]:=getdata(i+1,FepNum,evtMode);

        with Fchannel[i] do
        begin
          initDat1(data0[i],getTpNum(i+1,FepNum));
          unitX:=fileDesc.unitX;
          unitY:=fileDesc.unitY(i+1);

          if evtMode then
            begin
              modeT:=DM_evt1;
              Vlist[i].modeT:=DM_evt1;
              Fchannel[i].EpDuration:=fileDesc.EpDuration;
            end
          else
            begin
              if modeT=DM_evt1 then modeT:=DM_line;
              if Vlist[i].modeT=DM_evt1 then Vlist[i].modeT:=DM_line;
            end;
        end;
      end;

    for i:=0 to NbSpk-1 do
      begin
        dataSpk[i].free;
        dataSpk[i]:=getdataSpk(i+1,FepNum);
        dataAtt[i].free;

        if assigned(SpkTable)
          then dataAtt[i]:=spkTable.getdataAtt(i+1,FepNum)
          else dataAtt[i]:=getdataAtt(i+1,FepNum);

        Fspk[i].initData(dataSpk[i],dataAtt[i], invaliderAff);

        Fspk[i].unitX:=unitX;
        Fspk[i].unitY:='';
        Fspk[i].EpDuration:=fileDesc.EpDuration;

        dataSpkW[i].free;
        dataSpkW[i]:=getdataSpkWave(i+1,FepNum,WFlen,WFpretrig, scaling);

        FWspk[i].initTemp1(-WFpretrig,WFlen-WFpretrig-1,g_smallint);

        FWspk[i].Dxu:=scaling.Dxu;
        FWspk[i].x0u:=scaling.x0u;
        FWspk[i].unitX:=scaling.unitX;

        FWspk[i].Dyu:=scaling.Dyu;
        FWspk[i].y0u:=scaling.y0u;
        FWspk[i].unitY:=scaling.unitY;

        FWspk[i].DxuSrc:=scaling.dxuSource;
        FWspk[i].UnitXsrc:=scaling.unitXSource;


        FWspk[i].initRawData(dataSpkW[i],dataAtt[i]);


      end;


    for i:=1 to MaxVtag do
      begin
        dataTag[i].free;
        dataTag[i]:=getdataTag(i,FepNum);
        {if not assigned(dataTag[i])
          then messageCentral('dataTag '+Istr(i)+'=nil');}
        Vtag[i].initDat1(dataTag[i],G_smallint);
        Vtag[i].unitX:=unitX;
        Vtag[i].unitY:='';
      end;

    {Vsound}
    for i:=1 to 2 do
      begin
        dataSound[i].free;
        dataSound[i]:=getSound(i);
        Vsound[i].initDat1(dataSound[i],G_smallint);
        Vsound[i].unitX:=unitX;
        Vsound[i].unitY:='';
      end;

    getElphyTag(FepNum,tags,x0uTag,dxuTag);

    Mtag.initData(tags,x0uTag,dxuTag);


    if fileDesc.HasPCL then
    begin
      initPCL(true);
      getPCLdata(FPCL,FepNum);

      db:=filedesc.ReadPCLfilter(NumPCLfilter);
      if assigned(db) then FPCL.DBtoPCLfilter(db);
      db.Free;

      FPCL.invalidate;
    end
    else
    if assigned(FPCL) then FPCL.FreeData;

    if OnChangeEpisode.valid
      then OnChangeEpisode.pg.executerProcedure1(OnChangeEpisode.ad,tagUO);

  end;

  if assigned(afficherNumSeq) then afficherNumSeq(FepNum);
end;

procedure TdataFile.initAcq(stf:AnsiString;numInit,numS:integer;reprise,modifNumSeq:boolean);
begin
  if stf='' then           {7 mai 2004 : on ne détruit pas fileDesc}
  begin
    fileDesc.free;
    fileDesc:=nil;
  end
  else FreeFileStream;

  ClearSpkTable;

  if modifNumSeq then FepNum:=0;
  initData(not reprise,true);

  installVlist;

  initDataAcq(numInit,numS);

  afficherNomDat(stf);

  AcqON:=true;
  if not reprise then initMoy;
end;

{ initDataCont est appelé avec Samples=0 avant l'acquisition. Dans ce cas, les
objets data sont initialisés de façon tournante sur MainBuf.
  Ensuite, initDataCont est appelé toutes les 50 ms avec le nouveau nombre
d'échantillons par voie. On modifie alors le Iend des vecteurs.

  Seule la partie de v1,v2... située dans MainBuf est visible pendant l'acquisition.
On pourrait améliorer les dataIT et dataIdigiT pour "voir" le reste des données
situées dans le fichier.
}

procedure TdataFile.initDataCont(Samples:integer);
var
  i,ii1:integer;
  Ftags:TtagMode;
  nbtag:integer;
  OffsetT,nbStepT:integer;
begin
  Ftags:=board.TagMode;
  nbtag:=board.TagCount;

  if Samples=0 then
    begin
      with acqInf do
      begin
        setData0Length(Qnbvoie,false);

        for i:=0 to Qnbvoie-1 do
          begin
            data0[i].free;

            OffsetT:=acqInf.SampleOffset[i+1];

            nbStepT:=mainBufSize div acqInf.AgTotSize;

            case ChannelType[i+1] of
            TI_analog:
              begin
                if Ftags=tmDigiData then
                  data0[i]:=typedataIdigiT.createStep(@mainBuf^[OffsetT div 2],AcqInf.AgTotSize,nbStepT ,0,0,-1, board.tagShift)
                else data0[i]:=typedataIT.createStep(@mainBuf^[OffsetT div 2],AcqInf.AgTotSize,nbStepT ,0,0,-1);

                data0[i].setConversionX(Dxu,X0u);
                data0[i].setConversionY(Dyu(i+1),Y0u(i+1));

                Fchannel[i].initDat0(data0[i],G_smallint);
                Fchannel[i].unitX:=unitX;
                Fchannel[i].unitY:=unitY[i+1];
              end;
            TI_anaEvent:
              begin
                with EvtBuf[i+1] do
                  data0[i]:=typedataLT.createStep(Buf,4,BufSize, 0,1,indexT);

                data0[i].setConversionX(Dxu,0);
                data0[i].setConversionY(Dxu,0);
                Fchannel[i].initDat0(data0[i],g_longint);
              end;
            TI_digiEvent:
              begin
                with DigEvtBuf do
                  data0[i]:=typedataLT.createStep(Buf,4,BufSize, 0,1,indexT);

                data0[i].setConversionX(0.000001,0);
                data0[i].setConversionY(0.000001,0);
                Fchannel[i].initDat0(data0[i],g_longint);
              end;

            TI_Neuron:
              begin
                data0[i]:=typedataST.createStep(@MainBuf^[OffsetT div 2],AcqInf.AgTotSize,nbStepT,0,0,-1);
                data0[i].setConversionX(Dxu,X0u);
                data0[i].setConversionY(Dyu(i+1),Y0u(i+1));

                Fchannel[i].initDat0(data0[i],G_single);
                Fchannel[i].unitX:=unitX;
                Fchannel[i].unitY:=unitY[i+1];

              end;
            end;
          end;


        for i:=1 to MaxVtag do
        begin
          dataTag[i].free;
          Vtag[i].initDat0(nil,G_smallint);
          dataTag[i]:=nil;
        end;

        if Ftags<>tmNone then
        begin

          OffsetT:=acqInf.SampleOffset[nbVoieAcq];
          
          nbStepT:=mainBufSize div acqInf.AgTotSize;

          for i:=1 to nbtag do
            begin
              {
              if Ftags=tmDigidata
               then dataTag[i]:= typedataDigiTagT.create(@mainBuf^[0],nbvoieAcq,mainBufSize div 2,0,0,-1,i)
               else dataTag[i]:= typedataDigiTagT.create(@mainBuf^[nbvoieAcq-1],nbvoieAcq,mainBufSize div 2,0,0,-1,i);
             }
             if Ftags=tmDigidata
               then dataTag[i]:= typeDataDigiTagT.createStep(@mainBuf^[0], AcqInf.AgTotSize ,NbstepT ,0,0,-1, i)
               else dataTag[i]:= typeDataDigiTagT.createStep(@mainBuf^[offsetT div 2], AcqInf.AgTotSize ,NbstepT ,0,0,-1, i);

              dataTag[i].setConversionX(Dxu,X0u);

              Vtag[i].initDat0(dataTag[i],G_smallint);
              Vtag[i].unitX:=unitX;
              Vtag[i].unitY:='';
            end;
        end;
        Mtag.initdata(nil,0,1);

        If assigned(PCLbuf) then
          with PCLbuf do FPCL.InitAcq(PCLbuf.getDataPhoton(1,indexT),0,0, false,PCLnx,PCLny);
      end;
    end
  else
    begin
      with acqInf do
      begin
        for i:=0 to Qnbvoie-1 do
          case channelType[i+1] of
            TI_AnaEvent:
              with EvtBuf[i+1] do
              begin
                ii1:=index-BufSize;
                if ii1<1 then ii1:=1;
                Fchannel[i].modifyLimits(ii1,Index-1,false );
              end;
            TI_DigiEvent:
              with DigEvtBuf do
              begin
                ii1:=index-BufSize;
                if ii1<1 then ii1:=1;
                Fchannel[i].modifyLimits(ii1,Index-1,false );
              end;

            else Fchannel[i].modifyLimits(0,samples-1 );
          end;

        for i:=1 to nbTag do Vtag[i].modifyLimits(0,samples-1 );
      end;


      If assigned(PCLbuf) then FPCL.modifyLimits(PCLbuf.Index-2, samples*PeriodeMicro);

    end;
end;

{ initDataSeq est appelé avec numS=0 avant l'acquisition
              puis avec numS=le numéro de la séquence qui vient d'être terminée
}
procedure TdataFile.initDataSeq(numInit,numS:integer);
var
  i:integer;
  Ftags:TtagMode;
  nbtag:integer;
  numS1,numT:integer;
  nbOld, OffsetT:integer;
begin
  FepNum:=numInit+numS;
  FepCount:=FepNum;

  Ftags:=board.TagMode;
  nbtag:=board.TagCount;

  numS1:=numS;
  if numS1<>0 then numS1:=(numS1-1) mod nbseq0;

  with acqInf do
  begin
    setData0Length(Qnbvoie,false);

    for i:=0 to Qnbvoie-1 do
      begin
        data0[i].free;
        data0[i]:=nil;

        OffsetT:=AcqInf.SampleOffset[i+1];

        case ChannelType[i+1] of
          TI_analog:
            begin
              if Ftags=tmDigidata then
                data0[i]:=typedataIdigi.createStep(@mainBuf^[(Qnbpt*AgTotSize*numS1+OffsetT) div 2],
                    AgTotSize,0,0,Qnbpt-1,board.tagShift)
              else data0[i]:=typedataI.createStep(@mainBuf^[(Qnbpt*AgTotSize*numS1+OffsetT) div 2],
                    AgTotSize,0,0,Qnbpt-1);

              data0[i].setConversionX(Dxu,X0u);
              data0[i].setConversionY(Dyu(i+1),Y0u(i+1));
              Fchannel[i].initDat0(data0[i],G_smallint);
            end;

          TI_anaEvent:
            begin
              data0[i].free;
              data0[i]:=nil;

              with EvtBuf[i+1] do
                data0[i]:=typedataLT.createStep(Buf,4,BufSize ,oldIndexT,1,indexT-oldIndexT);

              data0[i].setConversionX(Dxu,0);
              data0[i].setConversionY(Dxu,0);
              Fchannel[i].initDat0(data0[i],g_longint);
              Fchannel[i].unitX:=unitX;
              Fchannel[i].unitY:='';
            end;
          TI_digiEvent:
            begin
              data0[i].free;
              data0[i]:=nil;

              with DigEvtBuf do
                data0[i]:=typedataLT.createStep(Buf,4,BufSize ,oldIndexT,1,indexT-oldIndexT);

              data0[i].setConversionX(0.001,0);
              data0[i].setConversionY(0.001,0);
              Fchannel[i].initDat0(data0[i],g_longint);
              Fchannel[i].unitX:=unitX;
              Fchannel[i].unitY:='';
            end;

          TI_neuron:
            begin
              data0[i]:=typedataS.createStep(@mainBuf^[(Qnbpt*AgTotSize*numS1+OffsetT) div 2],
                    AgTotSize,0,0,Qnbpt-1);

              data0[i].setConversionX(Dxu,X0u);
              data0[i].setConversionY(Dyu(i+1),Y0u(i+1));
              Fchannel[i].initDat0(data0[i],G_single);
            end;
        end;

        Fchannel[i].unitX:=unitX;
        Fchannel[i].unitY:=unitY[i+1];
      end;

    for i:=1 to MaxVtag do
      begin
        dataTag[i].free;
        Vtag[i].initDat0(nil,G_smallint);
        dataTag[i]:=nil;
      end;

    {Init Voies tag }
    if Ftags<>tmNone then
    begin
      for i:=1 to nbtag do
        begin
          {Pour la digidata, on choisit la voie 0 pour les tags
           Pour ITC, on choisit la voie nbvoie-1, ie la voie numérique rangée après les voies adc
          }
          if Ftags=tmDigidata
            then dataTag[i]:=typedataDigiTag.create
                  (@mainBuf^[Qnbpt*nbvoieAcq*numS1],nbvoieAcq,0,0,Qnbpt-1,i)
            else
            begin
              dataTag[i]:=typedataDigiTag.createStep(@mainBuf^[(Qnbpt*AgTotSize*numS1+AgTotSize-2) div 2],AgTotSize,0,0,Qnbpt-1,i);
            end;
          dataTag[i].setConversionX(Dxu,X0u);

          Vtag[i].initDat0(dataTag[i],G_smallint);
          Vtag[i].unitX:=unitX;
          Vtag[i].unitY:='';
        end;

      for i:=1 to nbtag do Vtag[i].invalidateExceptMG0;
    end;
    Mtag.initdata(nil,0,1);

    If assigned(PCLbuf) then
      with PCLbuf do FPCL.InitAcq(PCLbuf.getDataPhoton(oldIndexT+1,indexT),0,DureeSeq, not continu, PCLnx, PCLny);
  end;


  if acqInf.Qmoy and not continuousFile and (FepNum>0)
    then Dtag;

end;

{Version MultiMainBuf de initDataCont}
procedure TdataFile.initDataContMulti(Samples:integer);
var
  i:integer;
  Ftags:TtagMode;
  nbtag:integer;
  ii1:integer;
begin
  Ftags:=board.TagMode;
  nbtag:=board.TagCount;

  if Samples=0 then
    begin
      with acqInf do
      begin
        setData0Length(Qnbvoie,false);

        for i:=0 to Qnbvoie-1 do
          begin
            data0[i].free;

            case ChannelType[i+1] of
            TI_analog:
              begin
                with MultimainBuf[i] do
                data0[i]:=typedataIT.createStep(Buf,2,BufSize ,0,0,-1); {on oublie les tags digidata}

                data0[i].setConversionX(Dxu*QKS[i+1],X0u);
                data0[i].setConversionY(Dyu(i+1),Y0u(i+1));

                Fchannel[i].initDat0(data0[i],G_smallint);
                Fchannel[i].unitX:=unitX;
                Fchannel[i].unitY:=unitY[i+1];
              end;

            TI_Neuron:
              begin
                with MultimainBuf[i] do
                data0[i]:=typedataST.createStep(Buf,4,BufSize,0,0,-1);
                data0[i].setConversionX(Dxu*QKS[i],X0u);
                data0[i].setConversionY(Dyu(i+1),Y0u(i+1));

                Fchannel[i].initDat0(data0[i],G_single);
                Fchannel[i].unitX:=unitX;
                Fchannel[i].unitY:=unitY[i+1];

              end;
            end;
          end;

        setDataSpkLength(nbvoieSpk,false);
        for i:=0 to nbvoieSpk-1 do
          begin
            dataSpk[i].free;
            dataAtt[i].free;

            with MultiEvtBuf[i] do
            begin
              dataSpk[i]:=typedataLT.createStep(Buf,4,BufSize, 0,1,1);
              dataAtt[i]:=typedataByteT.createStep(BufAtt,1,BufSize, 0,1,1);
            end;

            dataSpk[i].setConversionX(Dxu,0);
            dataSpk[i].setConversionY(Dxu,0);
            dataAtt[i].setConversionX(Dxu,0);
            dataAtt[i].setConversionY(Dxu,0);

            Fspk[i].initData(dataSpk[i],dataAtt[i],false);
            Fspk[i].unitX:=unitX;

            dataSpkW[i].free;
            dataSpkW[i]:=nil;                  { NIL provisoire. A complèter }
            FWspk[i].initRawData(dataSpkW[i],dataAtt[i]);
          end;


        for i:=1 to MaxVtag do
        begin
          dataTag[i].free;
          Vtag[i].initDat0(nil,G_smallint);
          dataTag[i]:=nil;
        end;

        if Ftags<>tmNone then
        begin
          for i:=1 to nbtag do
            begin
              { les tags sont seulement du type tmCyberK }
              with MultiCyberTagBuf do
              dataTag[i]:=typedataDigiTagT.create(Buf,1,BufSize,0,0,-1,i);

              dataTag[i].setConversionX(Dxu,X0u);

              Vtag[i].initDat0(dataTag[i],G_smallint);
              Vtag[i].unitX:=unitX;
              Vtag[i].unitY:='';
            end;
        end;
        Mtag.initdata(nil,0,1);
      end;
    end
  else
    begin
      with acqInf do
      begin
        for i:=0 to Qnbvoie-1 do
          Fchannel[i].modifyLimits(0,samples div QKS[i+1]-1 );

        for i:=0 to nbvoieSpk-1 do
        with MultiEvtBuf[i] do
        begin
          ii1:=index-BufSize;
          if ii1<1 then ii1:=1;
          Fspk[i].modifyLimits(ii1,Index-1,false );
        end;

        for i:=1 to nbTag do Vtag[i].modifyLimits(0,samples-1 );
      end;
    end;
end;


{Version MultiMainBuf de initDataSeq}
procedure TdataFile.initDataSeqMulti(numInit,numS:integer);
var
  i:integer;
  Ftags:TtagMode;
  nbtag:integer;
  numS1,numT:integer;
  nbOld, OffsetT:integer;
begin
  FepNum:=numInit+numS;
  FepCount:=FepNum;

  Ftags:=board.TagMode;
  nbtag:=board.TagCount;

  numS1:=numS;
  if numS1<>0 then numS1:=(numS1-1) mod nbseq0;

  with acqInf do
  begin
    setData0Length(Qnbvoie,false);

    for i:=0 to Qnbvoie-1 do
      begin
        data0[i].free;
        data0[i]:=nil;

        OffsetT:=AcqInf.SampleOffset[i+1];

        case ChannelType[i+1] of
          TI_analog:
            begin
              with MultimainBuf[i] do
              data0[i]:=typedataI.createStep( @BufSmall^[(Qnbpt div QKS[i+1])*numS1],2,0,0,Qnbpt div QKS[i+1]-1);

              data0[i].setConversionX(Dxu*QKS[i+1],X0u);
              data0[i].setConversionY(Dyu(i+1),Y0u(i+1));
              Fchannel[i].initDat0(data0[i],G_smallint);
            end;

          TI_anaEvent:
            begin
              with EvtBuf[i+1] do
                data0[i]:=typedataLT.createStep(Buf,4,BufSize ,oldIndexT,1,indexT-oldIndexT);

              data0[i].setConversionX(Dxu,0);
              data0[i].setConversionY(Dxu,0);
              Fchannel[i].initDat0(data0[i],g_longint);
              affdebug('voie Evt '+Istr(data0[i].indiceMin)+'  '+Istr(data0[i].indiceMax),0);
            end;

          {TI_digiEvent: No implementation }

          TI_neuron:
            begin
              with MultimainBuf[i] do
              data0[i]:=typedataS.create(@BufSmall^[(Qnbpt div QKS[i+1])*numS1],4,0,0,Qnbpt-1);

              data0[i].setConversionX(Dxu*QKS[i+1],X0u);
              data0[i].setConversionY(Dyu(i+1),Y0u(i+1));
              Fchannel[i].initDat0(data0[i],G_single);
            end;
        end;

        Fchannel[i].unitX:=unitX;
        Fchannel[i].unitY:=unitY[i+1];
      end;

    setDataSpkLength(nbVoieSpk,false);
    for i:=0 to nbvoieSpk-1 do
      begin
        dataSpk[i].free;
        dataSpk[i]:=nil;
        dataAtt[i].free;
        dataAtt[i]:=nil;

        with MultiEvtBuf[i] do
        begin
          dataSpk[i]:=typedataLT.createStep(Buf,4,BufSize ,oldIndexT,1,indexT-oldIndexT);
          dataAtt[i]:=typedataByteT.createStep(BufAtt,1,BufSize ,oldIndexT,1,indexT-oldIndexT);
        end;
        dataSpk[i].setConversionX(Dxu,0);
        dataSpk[i].setConversionY(Dxu,0);
        dataAtt[i].setConversionX(Dxu,0);
        dataAtt[i].setConversionY(Dxu,0);
        Fspk[i].initData(dataSpk[i],dataAtt[i],false);
        Fspk[i].unitX:=unitX;
        Fspk[i].unitY:='';

        dataSpkW[i].free;
        dataSpkW[i]:=nil;                             { NIL provisoire. A complèter }
        FWspk[i].initRawData(dataSpkW[i],dataAtt[i]);
      end;


    for i:=1 to MaxVtag do
      begin
        dataTag[i].free;
        Vtag[i].initDat0(nil,G_smallint);
        dataTag[i]:=nil;
      end;

    {Init Voies tag }
    if Ftags<>tmNone then
    begin
      for i:=1 to nbtag do
        begin
          with MultiCyberTagBuf do
          dataTag[i]:=typedataDigiTag.createStep(@BufSmall^[Qnbpt *numS1],2,0,0,Qnbpt-1,i);
          dataTag[i].setConversionX(Dxu,X0u);

          Vtag[i].initDat0(dataTag[i],G_smallint);
          Vtag[i].unitX:=unitX;
          Vtag[i].unitY:='';
        end;

      for i:=1 to nbtag do Vtag[i].invalidateExceptMG0;
    end;
    Mtag.initdata(nil,0,1);
  end;

  if acqInf.Qmoy and not continuousFile and (FepNum>0)
    then Dtag;

end;



procedure TdataFile.initDataAcq(numInit,numS:integer);
var
  i:integer;
begin
  if acqInf.continu then
  begin
    if numS=0 then VerifyVectorLengths(AcqInf.Qnbvoie, AcqInf.CyberElecCount, AcqInf.CyberUnitCount);
    if FmultiMainBuf
      then initDataContMulti(numS)
      else initDataCont(numS)
  end
  else
  begin
    if numS=0 then VerifyVectorLengths(AcqInf.Qnbvoie, AcqInf.nbVoieSpk, AcqInf.CyberUnitCount);
    if FmultiMainBuf
      then initDataSeqMulti(numInit,numS)
      else initDataSeq(numInit,numS);
  end;

  for i:=0 to maxChan-1 do
  begin
    Fchannel[i].updateEditForm;
    Fchannel[i].invalidateExceptMG0;
  end;

  for i:=0 to AcqInf.Qnbvoie-1 do
    Fchannel[i].EpDuration:=AcqInf.Dxu*(AcqInf.Qnbpt-1);
end;


procedure TdataFile.doneAcq(Ffile:boolean;numInit,numS:integer);
begin
  if Ffile then
    begin
      installFile0(AcqinfF.stDat,false,false);
      setEpNum(FepCount);
    end
  else
    begin
      initdataAcq(numInit,numS);
      affdebug('DoneAcq '+Istr(nums),0);
      if assigned(PCLbuf) then FPCL.InitFrames0(true);
    end;
  AcqOn:=false;
end;

procedure TdataFile.initMoy;
var
  i:integer;
begin
  DclearMoy;
  if assigned(AverageForm)
    then AverageForm.afficher;

  (*
  if ContinuousFile then
    for i:=0 to channelCount-1 do
      Fmoy[i].initTemp1(IstartMoy,IendMoy,typeMoy)
  else
    for i:=0 to ChannelCount-1 do
      Fmoy[i].initTemp1(Fchannel[i].Istart,Fchannel[i].Iend,typeMoy);

  for i:=0 to ChannelCount-1 do
    begin
      Fmoy[i].dxu:=Fchannel[i].Dxu;
      Fmoy[i].x0u:=Fchannel[i].x0u;
    end;

  for i:=ChannelCount to maxChan-1 do
    Fmoy[i].initDat1(nil,g_single);
  *)

  for i:=0 to maxChan-1 do
    Fmoy[i].initDat1(nil,g_single);
  { On n'alloue pas les vecteurs moyennes mars 2007 }
end;

procedure TdataFile.InitAverages(tp:typetypeG;i1,i2:integer);
var
  i:integer;
begin
  typeMoy:=tp;
  IstartMoy:=i1;
  IendMoy:=i2;

  if continuousFile then
  begin
    initMoy;
    for i:=0 to channelCount-1 do
      Fmoy[i].initTemp1(IstartMoy,IendMoy,typeMoy)
  end;
end;

procedure TdataFile.setAverageType(tp:typetypeG);
begin
  typeMoy:=tp;
  InitMoy;
end;

procedure TdataFile.installFile(st:AnsiString;FinitMoy:boolean;NoError:boolean);
var
  i:integer;
  newM:integer;
const
  oldM:integer=0;

begin
  fileDesc.free;
  fileDesc:=nil;

  if not fileExists(st) then exit;

  i:=0;
  while (fileDesc=nil) and (i<length(TDesc)) do
  begin
    if TestedFiles[i] then
    begin
      FileDesc:=TDesc[i].create;
      if not fileDesc.init(st) then
      begin
        fileDesc.free;
        fileDesc:=nil;
      end;
    end;
    inc(i);
  end;
  if (fileDesc=nil)  then
  begin
    if NoError=false then  messageCentral('Unable to load '+st+' ');
    exit;
  end;

  with fileDesc do
  begin
    FepNum:=1;
    FepCount:=nbSeqDat;

    memoC.stList.text:=Comment;
    memoC.invalidate;
  end;

  UpdateSpkTable;


  initData(true,false);

  (*
  NewM:=AllocatedMem;
  messageCentral('Diff='+Istr(NewM-oldM));
  oldM:=NewM;
  *)

  installVlist;
  AcqON:=false;

  if FinitMoy then initMoy;
end;

procedure TdataFile.UpdateSpkTable;
begin
  ClearSpkTable;
  if fileDesc.SpkTableCount>0 then
  begin
    if SpkTableNum=-1 then LoadSpkTable(fileDesc.SpkTableCount )
    else
    if (SpkTableNum>0) and (SpkTableNum<=fileDesc.SpkTableCount) then LoadSpkTable(SpkTableNum );
  end;
end;

procedure TdataFile.installFile0(st:AnsiString;FinitMoy:boolean;NoError:boolean);
begin
  installFile(st,FinitMoy,NoError);
  if assigned(fileDesc)
    then stFichier:=st
    else stFichier:='';

  if assigned(afficherNomDat) then afficherNomDat(extractFileName(stFichier));
  if assigned(afficherNumSeq) then afficherNumSeq(FepNum);

  if onChange.valid then
    onChange.pg.executerProcedure1(onChange.ad,tagUO);

end;

procedure TdataFile.installBinaryFile(st:AnsiString;NoError:boolean);
begin
  fileDesc.free;
  fileDesc:=nil;

  fileDesc:= TbinaryDescriptor.create;
  TbinaryDescriptor(fileDesc).InitParams(DataFileRecBin);
  if fileDesc.init(st) then
  with fileDesc do
  begin
    FepNum:=1;
    FepCount:=nbSeqDat;

    memoC.stList.text:=Comment;
    memoC.invalidate;
  end;

  UpdateSpkTable;


  initData(true,false);

  installVlist;
  AcqON:=false;
end;

procedure TdataFile.installBinaryFile0(st:AnsiString;NoError:boolean);
begin
  installBinaryFile(st,NoError);
  if assigned(fileDesc)
    then stFichier:=st
    else stFichier:='';

  if assigned(afficherNomDat) then afficherNomDat(extractFileName(stFichier));
  if assigned(afficherNumSeq) then afficherNumSeq(FepNum);

  if onChange.valid then
    onChange.pg.executerProcedure1(onChange.ad,tagUO);

end;

procedure TdataFile.updateElphyFile;
var
  i:integer;
begin
  if fileDesc is TElphyDescriptor then
  begin
    TElphyDescriptor(fileDesc).reinit;

    FepCount:=fileDesc.nbSeqDat;
    FepNum:=FepCount;

    initData(true,false);
    if assigned(afficherNumSeq) then afficherNumSeq(FepNum);
  end;
end;


procedure TdataFile.DloadFile;
var
  stg,stf:AnsiString;
begin
  stg:=stGen;
  stF:=stFichier;
  if ChoixFichierStandard1(stG,stF,stFiltre,Ifiltre) then
  begin
    stGen:=stg;
    stFichier:=stF;
    installFile0(stFichier,true,false);
  end;
end;

procedure TdataFile.DloadBinaryFile;
var
  stg,stf:AnsiString;
  Iff:integer;
begin
  stg:=stGen;
  stF:=stFichier;
  if ChoixFichierStandard1(stG,stF,'',Iff) then
  begin
    stGen:=stg;
    stFichier:=stF;
    installBinaryFile0(stFichier,false);
  end;
end;

procedure TdataFile.ReloadFile;
begin
  if stFichier <>'' then installFile0(stFichier,true,false);
end;

procedure TdataFile.CloseLastDataBlock;
begin
  if filedesc is TElphyDescriptor then
  begin
    TElphyDescriptor(fileDesc).CloseLastDataBlock;
    ReloadFile;
  end;
end;

procedure TdataFile.DnextFile;
var
  st:AnsiString;
begin
  st:=fichierSuivant(stFichier);
  if st<>stFichier then installFile0(st,true,false);
end;

procedure TdataFile.DpreviousFile;
var
  st:AnsiString;
begin
  st:=fichierPrecedent(stFichier);
  if st<>stFichier then installFile0(st,true,false);
end;


procedure TdataFile.DFileInfo;
begin
  if assigned(fileDesc) then fileDesc.displayInfo;
end;



procedure TdataFile.Daveraging;
begin
  if not assigned(averageForm) then
    begin
      averageForm:=TaverageBox.create(form);
      averageForm.install(self);
    end;

  averageForm.show;
end;


function TdataFile.setEpNum(num:integer):boolean;
var
  nb:integer;
begin
  result:=false;
  if (FileDesc=nil) or AcqON then exit;
  with fileDesc do
  begin
    result:=(num>=1) and (num<=FepCount);
    if result and (num<>FepNum) then
      begin
        FepNum:=num;
        initData(true,false);
        if assigned(afficherNumSeq) then afficherNumSeq(FepNum);
      end;
  end;

end;

procedure TdataFile.MessageCpl;
var
  i:integer;
begin
  for i:=0 to maxChan-1 do
      Fchannel[i].messageCpx;
end;

procedure TdataFile.DNextSeq;
var
  i:integer;
begin
  if not assigned(fileDesc) or AcqON then exit;

  with fileDesc do
  if FichierContinu then
    begin
      for i:=0 to nbvoie-1 do Fchannel[i].translateCoo(true);
      for i:=0 to nbSpk-1 do Fspk[i].translateCoo(true);

      for i:=0 to nbvoie-1 do
        begin
          Fchannel[i].messageCpx;
          Fchannel[i].messageToRef(UOmsg_invalidate,nil);
        end;

      for i:=0 to nbspk-1 do
        begin
          Fspk[i].messageCpx;
          Fspk[i].messageToRef(UOmsg_invalidate,nil);
        end;

    end
  else setEpNum(FepNum+1);
end;

procedure TdataFile.DPrevSeq;
var
  i:integer;
begin
  if not assigned(fileDesc) or AcqON then exit;

  with fileDesc do
  if FichierContinu then
    begin
      for i:=0 to nbvoie-1 do Fchannel[i].translateCoo(false);
      for i:=0 to nbSpk-1 do Fspk[i].translateCoo(true);

      for i:=0 to nbvoie-1 do
        begin
          Fchannel[i].messageCpx;
          Fchannel[i].messageToRef(UOmsg_invalidate,nil);
        end;
      for i:=0 to nbspk-1 do
        begin
          Fspk[i].messageCpx;
          Fspk[i].messageToRef(UOmsg_invalidate,nil);
        end;

    end
  else setEpNum(FepNum-1);
end;

procedure TdataFile.createForm;
begin
  form:=TDataFileform.create(formStm);
  with TdataFileForm(form) do
  begin
    caption:=ident;

    loadD:=DloadFile;
    nextFileD:=DnextFile;
    prevFileD:=DpreviousFile;
    InfoD:=DFileInfo;
    averagingD:=Daveraging;

    prevSeqD:=DprevSeq;
    NextSeqD:=DnextSeq;

    panelName.caption:='';
    AfficherNumSeq:=AffNumSeq0;
    AfficherNomDat:=AffNomDat0;
  end;
end;


procedure TdataFile.BuildInfo(var conf:TblocConf;lecture,tout:boolean);
begin
  inherited;
  maxChanR:=maxChan;
  maxSpkR:=maxSpk;
  maxSpkUnitR:=maxSpkUnit;
  with conf do
  begin
    setvarconf('MaxChan',maxChanR,sizeof(maxChanR));
    setvarconf('MaxSpk',maxSpkR,sizeof(maxSpkR));
    setvarconf('MaxSpkUnit',maxSpkUnitR,sizeof(maxSpkUnitR));

    setvarconf('stGen',stGen,sizeof(stGen));
    setvarconf('stFichier',stFichier,sizeof(stFichier));
    setvarconf('StdMoy',FmoyStd,sizeof(FmoyStd));
    setvarconf('IstartMoy',IstartMoy,sizeof(IstartMoy));
    setvarconf('IendMoy',IendMoy,sizeof(IendMoy));
    setvarconf('typeMoy',typeMoy,sizeof(typeMoy));
    setvarconf('SpkTableNum',SpkTableNum,sizeof(SpkTableNum));
    setvarconf('HasPcl',HasPCL,sizeof(HasPCL));
    setvarconf('NumPCLfilter',NumPCLfilter,sizeof(NumPCLfilter));

    {setvarconf('stHis',stHis,sizeof(stHis));}
  end;
end;

procedure TdataFile.completeLoadInfo;
begin
  CheckOldIdent;
  recupForm;
end;

procedure TdataFile.saveToStream(f:Tstream;Fdata:boolean);
var
  i:integer;
begin
  inherited saveToStream(f,Fdata);
  for i:=0 to maxChan-1 do
    begin
      with Fchannel[i] do
        if IsModified then saveToStream(f,Fdata);

      with Fmoy[i] do
        if IsModified then saveToStream(f,Fdata);
    end;

  for i:=0 to maxChan-1 do
    with Vlist[i] do
      if IsModified then saveToStream(f,Fdata);

  for i:=0 to MaxSpk-1 do
    with Fspk[i] do
      if IsModified then Fspk[i].saveToStream(f,Fdata);

  for i:=0 to MaxSpk-1 do
    with FWspk[i] do
      if IsModified then FWspk[i].saveToStream(f,Fdata);

  for i:=1 to MaxVtag do
      Vtag[i].saveToStream(f,Fdata);

  for i:=1 to 2 do
      Vsound[i].saveToStream(f,Fdata);

  memoC.saveToStream(f,Fdata);
  Mtag.saveToStream(f,Fdata);
  if assigned(FPCL) then FPCL.saveToStream(f,Fdata);
end;

function TdataFile.IdentifierID(stID:AnsiString;var n,num:integer):boolean;
var
  k,code:integer;
begin
  k:=length(ident);
  result:=(copy(stID,1,k+1)=ident+'.');
  if not result then exit;
  {On renvoie OK si la première partie est correcte, même si la suite ne
   correspond à rien. Ceci permet d'éliminer les anciens vecteurs Evt.
  }

  delete(stID,1,k+1);
  n:=0;

  if stID='' then exit;

  if stID[1]='v' then
    begin
      delete(stID,1,1);
      val(stID,num,code);
      if (code=0) and (num>=1) and (num<=MaxAdcCh)
        then n:=1;
    end
  else
  if stID[1]='m' then
    begin
      delete(stID,1,1);
      val(stID,num,code);
      if (code=0) and (num>=1) and (num<=MaxAdcCh)
        then n:=2;
    end
  else
  if copy(stID,1,5)='Vlist' then
    begin
      delete(stID,1,5);
      val(stID,num,code);
      if (code=0) and (num>=1) and (num<=MaxAdcCh)
        then n:=3;
    end
  else
  if copy(stID,1,4)='Vtag' then
    begin
      delete(stID,1,4);
      val(stID,num,code);
      if (code=0) and (num>=1) and (num<=MaxVtag)
        then n:=4;
    end
  else
  if stID='Comment' then n:=5
  else
  if stID='Mtag' then n:=6
  else
  if copy(stID,1,6)='Vsound' then
    begin
      delete(stID,1,6);
      val(stID,num,code);
      if (code=0) and (num>=1) and (num<=2)
        then n:=7;
    end
  else
  if copy(stID,1,4)='Vspk' then
    begin
      delete(stID,1,4);
      val(stID,num,code);
      if (code=0) and (num>=1) and (num<=MaxSpkCh)
        then n:=8;
    end
  else
  if copy(stID,1,4)='Wspk' then
    begin
      delete(stID,1,4);
      val(stID,num,code);
      if (code=0) and (num>=1) and (num<=MaxSpkCh)
        then n:=9;
    end
  else
  if stID='PCL' then n:=10;
end;

{4-10-02: les moyennes sont devenues des Taverage
  il est impossible de charger simplement les anciens vecteurs à cause de la longueur
  du nom de type qui est différente.

}
function TdataFile.loadFromStream(f:Tstream;size:LongWord;Fdata:boolean):boolean;
var
  st1:String[255];
  posf:LongWord;
  res:intG;
  posIni,pos1:LongWord;
  i:integer;

  OldstID:string[30];
  stID:AnsiString;
  conf:TblocConf;
  n,num:integer;

begin
  result:=inherited loadFromStream(f,size,false);

  if not result then exit;

  if f.position>=f.size then exit;

  FLoadObjectsMINI:=true;

  if (maxChanR>=8) and (maxChanR<=MaxAdcCh)
    then setvectors(maxChanR);

  if (maxSpkR>=0) and (maxSpkR<=MaxSpkCh)
    then setSpks(maxSpkR,maxSpkUnitR);

  initPCL(HasPCL);

  repeat
    posIni:=f.position;
    st1:=readHeader(f,size);

    if (st1=Tvector.STMClassName) or (st1=Taverage.STMClassName) or
       (st1=TVlistDF.STMClassName) or
       (st1=TvectorSpk.STMClassName) or (st1=TwaveList.STMClassName) or
       (st1=TstmMemo.STMClassName) or (st1=TMtagVector.STMClassName) or
       (st1=TOIseqPCL.STMClassName) then
      begin
        stID:='';
        OldStID:='';

        pos1:=f.position;
        conf:=TblocConf.create(st1);
        conf.setvarConf('IDENT',OldstId,sizeof(OldstId));
        conf.setStringConf('IDENT1',stId);
        result:=(conf.lire1(f,size)=0);
        conf.free;
        f.Position:=pos1;

        if stID='' then stID:=OldStID;

        result:=IdentifierID(stID,n,num);
        affdebug('Loading datafile ==>'+stID,0);
        if result then
        begin
          if (n>=1) and (n<=3) and (num>maxChan) then setVectors(num);
          if (n=8) and (num>maxSpk) then setSpks(num,maxSpkUnit);
          if (n=10) and not HasPcl then
          begin
            initPCL(true);
            HasPcl:=true;
          end;
          case n of
            1: result:=Fchannel[num-1].loadFromStream(f,size,Fdata);
            2: if st1=Taverage.stmClassName
                 then result:=Fmoy[num-1].loadFromStream1(f,size,Fdata)
                 else f.Position:=posini+size;
            3: result:=Vlist[num-1].loadFromStream(f,size,Fdata);
            4: result:=Vtag[num].loadFromStream(f,size,Fdata);
            5: result:=MemoC.loadFromStream(f,size,Fdata);
            6: result:=Mtag.loadFromStream(f,size,Fdata);
            7: result:=Vsound[num].loadFromStream(f,size,Fdata);
            8: result:=Fspk[num-1].loadFromStream(f,size,Fdata);
            9: result:=FWspk[num-1].loadFromStream(f,size,Fdata);
            10: result:=FPCL.loadFromStream(f,size,Fdata);
            else f.Position:=posini+size;
          end
        end
        else f.Position:=posini+size;
      end
  else
    begin
      result:=false;
      f.Position:=posini+size;
    end;
  until (f.position>=f.size) or not result;
  f.Position:=posini;

  FLoadObjectsMINI:=false;

  setChildNames;
  loadFromStream:=true;
end;

function TdataFile.initialise(st:AnsiString):boolean;
begin
  initialise:=inherited initialise(st);
  setChildNames;
end;

procedure TdataFile.chooseEpisode;
var
  num:integer;
begin
  if (FileDesc=nil) or AcqON then exit;
  with FileDesc do
  begin
    num:=FepNum;
    if chooseEp.execution(num,FepCount) then setEpNum(num);
  end;
end;

procedure TdataFile.Dtag;
var
  i:integer;
begin
  if not Moytag[FepNum] then
    begin
      Moytag[FepNum]:=true;

      for i:=0 to ChannelCount-1 do
        begin
          Fmoy[i].add(Fchannel[i]);
          Fmoy[i].invalidate;
        end;
    end;
end;

procedure TdataFile.Dtag1(x:float);
var
  i:integer;
begin
  for i:=0 to ChannelCount-1 do
    begin
      Fmoy[i].addEx(Fchannel[i],x);
      Fmoy[i].invalidate;
    end;
end;


procedure TdataFile.Duntag;
var
  i:integer;
begin
  if Moytag[FepNum] then
    begin
     Moytag[FepNum]:=false;

     for i:=0 to ChannelCount-1 do
       begin
         Fmoy[i].sub(Fchannel[i]);
         Fmoy[i].invalidate;
       end;
   end;
end;

procedure TdataFile.DclearMoy;
var
  i:integer;
begin
  tagList.clear;

  for i:=0 to ChannelCount-1 do
  begin
    Fmoy[i].clear;
    Fmoy[i].invalidate;
  end;
end;

procedure TdataFile.DtagBloc;
var
  i,j,old:integer;
begin
  if (fileDesc=nil) or AcqON then exit;

  old:=FepNum;
  i:=averageForm.debutBloc;
  while i<=averageForm.finBloc do
  begin
    if not Moytag[i] then
      begin
        Moytag[i]:=true;
        setEpNum(i);
        for j:=0 to FileDesc.nbvoie-1 do
          Fmoy[j].add(Fchannel[j]);
      end;
    inc(i,averageForm.stepBloc);
  end;

  for i:=0 to Filedesc.nbvoie-1 do Fmoy[i].invalidate;
  setEpNum(old);
end;

function TdataFile.DgetStTag:AnsiString;
var
  i,k,l,nb:integer;
  st:AnsiString;
begin
  st:='';
  nb:=0;
  with tagList do
  begin
    if count>0 then
      begin
        k:=intG(items[0]);
        st:=Istr(k);
        nb:=1;
      end;
    for i:=1 to count-1 do
      begin
        l:=intG(items[i]);
        if l=k+nb then inc(nb)
        else
          begin
            if nb=1 then st:=st+' '+Istr(l)
            else
            if nb=2 then st:=st+' '+Istr(k+nb-1)+' '+Istr(l)
            else st:=st+'-'+Istr(k+nb-1)+' '+Istr(l);
            nb:=1;
            k:=l;
          end;
      end;
    if nb=2 then st:=st+' '+Istr(k+nb-1)
    else
    if nb>2 then st:=st+'-'+Istr(k+nb-1);
  end;
  DgetStTag:=st;
end;



procedure TdataFile.sauverMoyPg(var f:file;preseq,postSeq,FileInfoSize:integer;
                                 typeData:typetypeG);
var
  tp:typetypeG;
begin
end;

function TdataFile.getFileName:AnsiString;
begin
  getFileName:=stFichier;
end;

procedure TdataFile.installVlist;
var
  i:integer;
begin
  if fileDesc=nil then
    begin
      for i:=0 to maxChan-1 do
        with Vlist[i] do
        begin
          dataValid0:=false;
          displaySub:=nil;
          count0:=0;
          invalidate;
        end;
    end
  else
    begin
      for i:=fileDesc.nbvoie to maxChan-1 do
        with Vlist[i] do
        begin
          dataValid0:=false;
          displaySub:=nil;
          count0:=0;
          invalidate;
        end;

      for i:=0 to fileDesc.nbvoie-1 do
        with Vlist[i] do
        begin
          voie0:=i+1;
          count0:=FepCount;
          if ligne1>count0 then ligne1:=1;
          dataValid0:=true;
          displaySub:=displaySubG;
          saveList:=saveListG;
          getClone1:=getCloneG;

          getXlim:=getXlimits;
          getYlim:=getYlimits;

          initForm;
          invalidate;
        end;
    end;

end;

procedure TdataFile.displaySubG(voie,numS:integer);
var
  data1:typedataB;
  evtMode:boolean;
  oldVisu:TvisuInfo;

begin
  with fileDesc do
  begin
    data1:=getdata(voie,numS,evtMode);
    Vdum.initDat0(data1,getTpNum(voie,numS));
  end;

  oldVisu:=Vdum.visu;
  Vdum.visu:=Vlist[voie-1].visu;
  {Vdum.visu.fontVisu:=nil;}

  try
    Vdum.displayInside(nil,false,false,false);
  finally
    Vdum.initDat0(nil,G_smallint);
    data1.free;
    Vdum.visu:=oldVisu;
  end;
end;

procedure TdataFile.displaySubG1(voie,numS:integer);
begin
end;

procedure TdataFile.saveListAsDataFile(voie:integer;modeAppend:boolean);
var
  ac1:Tdac2file;
  i,j,cnt:integer;
  p:pointer;
  evtMode:boolean;
begin
  cnt:=0;
  for i:=0 to fileDesc.nbvoie-1 do
    if chToSave[i] then inc(cnt);
  if cnt=0 then exit;

  ac1:=Tdac2File.create;

  if (fileBlock<>0) then ac1.setFileInfoSize(fileBlock);

  if (fileBlock<>0) and (fileDesc.isAcquis1) and FcopyFileInfo then
    with fileDesc do
    begin
      ac1.copyFileInfo(getfileInfoBuf,fileInfoSize);
    end;

  if (EpBlock<>0) then ac1.setEpInfoSize(EpBlock);

  ac1.continu:=Fcontinu;
  ac1.channelCount:=cnt;

  ac1.Xorg:=XorgSave;
  cnt:=0;
  for i:=0 to fileDesc.nbvoie-1 do
    if chToSave[i] then
      begin
        inc(cnt);
        ac1.setChannel(cnt,Fchannel[i],XstartSave,XendSave);
      end;
  if modeAppend then
    begin
      ac1.append(stSave);
      if ac1.error<>0 then
        begin
          messageCentral('Error opening '+stSave+ac1.ErrorString);
          ac1.free;
          exit;
        end;
    end
  else
    begin
      ac1.createFile(stSave);
      if ac1.error<>0 then
        begin
          messageCentral('Error creating '+stSave+ac1.ErrorString);
          ac1.free;
          exit;
        end;
    end;

  with Vlist[voie-1] do
  begin
    for i:=1 to count do
      if selected[i] then
        begin
          fileDesc.initEpisod(i);
          for j:=0 to fileDesc.nbvoie-1 do
            if chToSave[j] then
              begin
                data0[j].free;
                data0[j]:=fileDesc.getdata(j+1,i,evtMode);
                Fchannel[j].initDat1(data0[j],fileDesc.getTpNum(j+1,i));
              end;

          if (EpBlock<>0) and (fileDesc.isAcquis1) and FcopyEpInfo then
            with fileDesc do
            begin
              ac1.copyEpInfo(EpInfo,EpInfoSize);
            end;

          ac1.save;
          if ac1.error<>0 then
            begin
              messageCentral('Error saving '+stSave+ac1.ErrorString);
              ac1.free;
              exit;
            end;

        end;
  end;

  ac1.close;
  ac1.free;

  fileDesc.initEpisod(FepNum);
  for j:=0 to fileDesc.nbvoie-1 do
    if chToSave[j] then
      begin
        data0[j].free;
        data0[j]:=fileDesc.getdata(j+1,FepNum,evtMode);
        Fchannel[j].initDat1(data0[j],fileDesc.getTpNum(j,FepNum));
      end;
end;

procedure TdataFile.saveListAsText;
begin

end;

procedure TdataFile.saveListG(voie:integer;Modeappend:boolean);
var
  i:integer;
  res:integer;
  Fsize,EpSize:integer;

begin
  if not assigned(fileDesc) then exit;

  fillchar(chToSave[0],maxChan,0);
  chToSave[voie-1]:=true;

  if fileDesc.isAcquis1 then
    begin
      Fsize:=Tac1Descriptor(fileDesc).FileInfoSize;
      EpSize:=Tac1Descriptor(fileDesc).EpInfoSize;
    end
  else
    begin
      Fsize:=0;
      EpSize:=0;
    end;

  res:= DFsaveList.execution(true,ident+' Save',fileDesc.nbvoie,ChtoSave,
                             XorgSave,XstartSave,XendSave,Fchannel[0].Xstart,Fchannel[0].Xend,
                             FileBlock,EpBlock,Fsize,EpSize,
                             FCopyFileInfo,FCopyEpInfo,
                             Fcontinu
                             );
  if res=0 then exit;

  if not sauverFichierStandard(stSave,'DAT') then exit;

  if not modeAppend and fichierExiste(stSave) then
    if MessageDlg('File already exists. Continue ?',mtConfirmation,[mbYes,mbNo],0)<>mrYes
      then exit;

  case res of
    1:saveListAsDataFile(voie,modeAppend);
    2:saveListAsText;
  end;
end;

(*
procedure TdataFile.saveListAsDataFile1(voie:integer;modeAppend:boolean);
var
  f:TfileStream;
  i:integer;
begin
  f:=nil;
  TRY
  if modeAppend then
    begin
      f:=TfileStream.create(stSave,fmOpenReadWrite);
      f.Position:=f.size;
    end
  else f:=TfileStream.create(stSave,fmCreate);

  with Tac1Descriptor(fileDesc) do copyEvHeader(f);

  f.free;
  Except
  f.Free;
  End;
end;

procedure TdataFile.saveListG1(voie:integer;Modeappend:boolean);
var
  i:integer;
  res:integer;
  Fsize,EpSize:integer;

begin
  if not (fileDesc.isAcquis1) then exit;

  fillchar(chToSave,sizeof(chToSave),1);

  res:= DFsaveList.execution(false,
                             ident+' Save',16,ChtoSave,
                             XorgSave,XstartSave,XendSave,0,fileDesc.dureeSeq,
                             FileBlock,EpBlock,Fsize,EpSize,
                             FCopyFileInfo,FCopyEpInfo,
                             Fcontinu
                             );
  if res=0 then exit;

  if not sauverFichierStandard(stSave,'DAT') then exit;

  if not modeAppend and fichierExiste(stSave) then
    if MessageDlg('File already exists. Continue ?',mtConfirmation,[mbYes,mbNo],0)<>mrYes
      then exit;

  case res of
    1:saveListAsDataFile1(voie,modeAppend);
    2:saveListAsText;
  end;
end;
*)

procedure TdataFile.getXlimits(var visu1:TvisuInfo;voie:integer);
begin
  visu1.cadrerX(Fchannel[voie-1].data);
end;

procedure TdataFile.getYlimits(var visu1:TvisuInfo;voie:integer);
begin
  visu1.cadrerY(Fchannel[voie-1].data);
end;


function TdataFile.getSM2info(stName,st:AnsiString;var w;size,tp:word):boolean;
begin
  result:=false;
  if not assigned(FileDesc) or not (fileDesc is TAC1Descriptor) then exit;
  with Tac1Descriptor(fileDesc) do
  begin
    result:=getSm2info(FepNum,stName,st,w,size);
  end;

end;

function TdataFile.getSM2RF(var x,y,dx,dy,theta:float):boolean;
begin
  result:=false;
  if not assigned(FileDesc) or not (fileDesc is TAC1Descriptor) then exit;
  with Tac1Descriptor(fileDesc) do
  begin
    result:=getSm2RF(FepNum,x,y,dx,dy,theta);
  end;

end;

function TdataFile.getCloneG(voie,NumSeq:integer):Tvector;
var
  data0:typeDataB;
  vec:Tvector;
  i:integer;
  evtMode:boolean;
begin
  if not assigned(fileDesc) then
    begin
      result:=nil;
      exit;
    end;

  vec:=Tvector.create;
  with filedesc do
  begin
    data0:=getdata(voie,NumSeq,evtMode);
    vec.initDat1(data0,getTpNum(voie,NumSeq));
    vec.unitX:=unitX;
    vec.unitY:=unitY(voie);
  end;

  result:=Tvector(vec.clone(true));
  with result do
  begin
    ident:='_';
    notPublished:=false;
    Fchild:=false;
    inf.readOnly:=false;
    Cpx:=0;
    Cpy:=0;
  end;


  vec.free;
  data0.free;


end;

function TdataFile.getVSposition:integer;
begin
  result:=-1;
  if not (fileDesc is TelphyDescriptor) then exit;

  result:=TelphyDescriptor(fileDesc).getVSposition(FepNum);
end;

procedure TdataFile.copyToBuffer(buf:pointer;bufSize:integer);
var
  i:integer;
begin
  if assigned(Filedesc) then FileDesc.copyToBuffer(buf,bufSize);
end;


procedure TdataFile.TrackPosition(ep:integer;x: float);
var
  i:integer;
begin
  setEpNum(ep);

  if assigned(fileDesc) then
    for i:=1 to fileDesc.nbvoie do
    begin
      Fchannel[i].adjustXminXmax(x);
      Fchannel[i].invalidate;
    end;

end;

function TdataFile.channelCount:integer;
begin
  if assigned(fileDesc) then result:=fileDesc.nbvoie
  else
  if AcqON then result:=Acqinf.Qnbvoie
  else result:=0;
end;

function TdataFile.SpkCount:integer;
begin
  if assigned(fileDesc) then result:=fileDesc.nbSpk
  else
  if AcqON then result:=Acqinf.nbVoieSpk
  else result:=0;
end;


function TdataFile.ContinuousFile:boolean;
begin
  if assigned(fileDesc) then result:=fileDesc.FichierContinu
  else
  if AcqON then result:=Acqinf.continu
  else result:=false;
end;

procedure TdataFile.PlayFile;
var
  i:integer;
begin
  if not assigned(player) then
  begin
    player:=TvectorPlayer.create;
    player.ident:=ident+'.Player';
  end;

  with player do
  begin
    ClearList;

    for i:=1 to 2 do
      if assigned(dataSound[i]) then AddToList(Vsound[i]);

    for i:=0 to ChannelCount-1 do AddToList(Fchannel[i]);
    for i:=1 to MaxVtag do
      if assigned(dataTag[i]) then AddToList(Vtag[i]);


    show(nil);
  end;
end;

procedure TdataFile.setMoyStd(w: boolean);
var
  i:integer;
begin
  if Fmoy[1].count=0 then
  begin
    FmoyStd:=w;
    for i:=0 to maxChan-1 do
      Fmoy[i].stdON:=FmoyStd;
  end;
end;

procedure TdataFile.SaveAverage(ModeAppend:boolean);
var
  i:integer;
  ac1:Tdac2file;
  vecToSave:Tlist;
  SaveRecMoy:TsaveRecord;

begin
  SaveRecMoy.init;

  if not sauverFichierStandard(stSaveMoy,'MOY') then exit;

  if not ModeAppend and fichierExiste(stSaveMoy) then
    if MessageDlg('File already exists. Continue ?',mtConfirmation,[mbYes,mbNo],0)<>mrYes
      then exit;


  ac1:=Tdac2File.create;

  ac1.channelCount:=Channelcount;

  ac1.Xorg:=Fmoy[1].Xstart;
  for i:=1 to Channelcount do
    ac1.setChannel(i,Fmoy[i-1],Fmoy[i-1].Xstart,Fmoy[i-1].Xend);

  ac1.continu:=false;
  ac1.InstalleOptions(saveRecMoy);

  if ModeAppend then
    begin
      ac1.append(stSaveMoy);
      if ac1.error<>0 then
        begin
          messageCentral('Error opening '+stSaveMoy);
          ac1.free;
          exit;
        end;
    end
  else
    begin
      ac1.createFile(stSaveMoy);
      if ac1.error<>0 then
        begin
          messageCentral('Error creating '+stSaveMoy+' '+Istr(ac1.error));
          ac1.free;
          exit;
        end;
    end;

  ac1.save;
  if ac1.error<>0 then
    begin
      messageCentral('Error saving '+stSaveMoy+' '+Istr(ac1.error));
      ac1.free;
      exit;
    end;

  ac1.close;
  ac1.free;
end;

function TdataFile.SearchAndload(st:AnsiString;numOc:integer;pu:typeUO):boolean;
begin
  if FileDesc is TElphyDescriptor then
    result:=TElphyDescriptor(FileDesc).ObjFile.SearchAndload(st,numOc,pu)
  else result:=false;
end;

function TdataFile.SearchClassAndload(numOc:integer;pu:typeUO):boolean;
begin
  if FileDesc is TElphyDescriptor then
    result:=TElphyDescriptor(FileDesc).ObjFile.SearchClassAndload(numOc,pu)
  else result:=false;
end;


function TdataFile.channel(i: integer): Tvector;
begin
  result:=Fchannel[i-1];
end;

function TdataFile.Vspk(i: integer): TvectorSpk;
begin
  result:=Fspk[i-1];
end;

function TdataFile.Wspk(i:integer):TwaveList;
begin
  result:=FWspk[i-1];
end;


function TdataFile.getPopUp: TpopupMenu;
begin
  with PopUps do
  begin
    PopupItem(pop_TdataFile,'TdataFile_Show').onclick:=self.Show;
    PopupItem(pop_TdataFile,'TdataFile_Properties').onclick:=Proprietes;

    result:=pop_Tdatafile;
  end;
end;

procedure TdataFile.Proprietes(sender: Tobject);
var
  nb,nbSpk1,nbUnit1,NumTb:integer;
  HasPcl1:boolean;
  st, st1, st2:Ansistring;
begin
  if AcqOn then exit;

  nb:=maxChan;
  nbSpk1:=maxSpk;
  nbUnit1:=maxSpkUnit;
  NumTb:=SpkTableNum;
  HasPCL1:=HasPCL;

  dataFileProp.Execution(self,nb,nbSpk1,nbUnit1);
  if (nb<>maxChan) or (nbSpk1<>maxSpk) or (nbUnit1<>maxSpkUnit) then
  begin
    st1:='';
    st2:='';
    if assigned(fileDesc) then
    begin
      if (channelCount>nb) then st1:='Current channel count is greater than '+Istr(nb);

      if (SpkCount>nbSpk1) then st2:='Current SPK count is greater than '+Istr(nbSpk1);
      if (st1<>'') or (st2<>'') then
      begin
        st:='Cannot set new properties:  ';
        if st1<>'' then st:=st+ crlf+'  '+ st1;
        if st2<>'' then st:=st+ crlf+'  '+ st2;

        messageCentral(st);
        exit;
      end;
    end;


    setVectors(nb);
    setSpks(nbSpk1,nbUnit1);
    setChildNames;
  end;
  if (NumTb<>SpkTableNum) then
  begin
    updateSpkTable;
    initdata(true,false);
  end;
  if HasPCL<>HasPCL1 then
  begin
    initPCL(HasPCL);
    setChildNames;
  end;
end;

procedure TdataFile.VerifyVectorLengths(nbAdc, NbSpk, NbUnit: integer);
begin
  if nbAdc>maxChan
    then setVectors( ((nbAdc div 8) +ord(nbAdc mod 8<>0) )*8 );

  if (nbSpk>maxSpk) or (NbUnit>maxSpkUnit)
    then setSpks( ((nbSpk div 32) +ord(nbSpk mod 32<>0) )*32 ,NbUnit);

  setChildNames;
end;


function TdataFile.isElphyFile: boolean;
begin
  result:=assigned(fileDesc) and (fileDesc is TElphyDescriptor);
end;

function TdataFile.getOIseq(n: integer): TOIseq;
begin
  result:= getOIseq1(n,true);
end;

function TdataFile.getOIseq1(n: integer; Finit:boolean): TOIseq;
begin
  if assigned(fileDesc)
    then result:=fileDesc.getOIseq(n,Finit)
    else result:=nil;

  if assigned(result) then
    result.ident:=ident+'.OIseq['+Istr(n+1)+']';
end;


function TdataFile.OIseqCount: integer;
begin
  if assigned(fileDesc)
    then result:=fileDesc.OIseqCount
    else result:=0;
end;

procedure TdataFile.AppendOIblocks(stSrc: AnsiString);
begin
  if isElphyFile
    then TElphyDescriptor(fileDesc).AppendOIblocks(stSrc);

end;

function TdataFile.AppendObject(ob:typeUO): int64;
begin
  if isElphyFile then
  begin
     result:= TElphyDescriptor(fileDesc).ObjFile.save(ob);
     TElphyDescriptor(fileDesc).Reinit;
  end
  else result:=-2;
end;

procedure TdataFile.FreeFileStream;
begin
  if assigned(fileDesc) then fileDesc.FreeFileStream;
end;

procedure TdataFile.BuildOIvecFile(stF:AnsiString);
begin
  if isElphyFile
    then TElphyDescriptor(fileDesc).BuildOIvecFile(stF);
end;

procedure TdataFile.setOIvecFile(stF:AnsiString);
begin
  if isElphyFile
    then TElphyDescriptor(fileDesc).setOIvecFile(stF);
end;


function TdataFile.InitSpkTable(table: TspkTable): boolean;
var
  attLen1:TarrayOfArrayOfInteger;
begin
  result:=false;
  if (table=nil) or (fileDesc=nil) then exit;

  attlen1:=fileDesc.getAttLen;
  table.InitDF(AttLen1);
  result:=true;
end;

procedure TdataFile.ClearSpkTable;
begin
  derefObjet(typeUO(SpkTable));
  SpkTable:=nil;
end;

function TdataFile.SetSpkTable(table: TspkTable): boolean;
begin
  result:=false;

  if (table<>nil) and ((fileDesc=nil)  or not SpkTableOK(table)) then exit;

  derefObjet(typeUO(SpkTable));
  SpkTable:=table;
  refObjet(typeUO(SpkTable));

  initData(true,false);
  result:=true;
end;

function TdataFile.SpkTableOK(table: TspkTable):boolean;
var
  attLen1:TarrayOfArrayOfInteger;
  i,j:integer;
begin
  result:=false;
  attlen1:=fileDesc.getAttlen;
  if length(attlen1)<>length(table.att) then exit;

  for i:=0 to high(attlen1) do
  begin
    if length(attlen1[i])<>length(table.Att[i]) then exit;
    for j:=0 to high(attlen1[i]) do
    if assigned(table.Att[i]) and (attlen1[i,j]<>length(table.Att[i,j])) then exit;
  end;

  result:=true;
end;

function TdataFile.loadSpkTable(n:integer):boolean;
var
  Table:TspkTable;
begin
  table:=TspkTable.create;
  result:= SearchClassAndload(n, Table);
  if result then
  begin
    clearSpkTable;
    table.Fchild:=true;
    spkTable:=table;
    initData(true,false);
  end
  else table.free;
end;

procedure TdataFile.processMessage(id:integer;source:typeUO;p:pointer);
begin
  case id of
    UOmsg_destroy:
      begin
        if SpkTable=source then
          begin
            SpkTable:=nil;
            derefObjet(source);
            initData(true,false);
          end;
      end;

  end;
end;

{ Neuroshare: id=identity renvoie le vecteur et son type Neuroshare tpNS
}
function TdataFile.getNsVector(id: integer;var tpNs:integer): Tvector;
var
  Nt,ch:integer;
begin
  result:=nil;
  if not assigned(fileDesc) then exit;

  Nt:=ChannelCount + SpkCount*2 + VtagCount ;
  if Nt=0 then exit;

  ch:= id+1;

  if ch<=ChannelCount then
  begin
    result:=Channel(ch);
    if channel(ch).modeT=DM_evt1
      then tpNS:=4   { NeuralEvent }
      else tpNS:=2;  { Analog }
  end
  else
  if ch<=ChannelCount+SpkCount then
  begin
    result:=Vspk(ch-ChannelCount);
    tpNS:=4; { NeuralEvent }
  end
  else
  if ch<=ChannelCount+2*SpkCount then
  begin
    result:=Wspk(ch-ChannelCount-SpkCount);
    tpNS:=3; { Segment }
  end
  else
  if ch<=ChannelCount+2*SpkCount+VtagCount then
  begin
    result:=Vtag[ch-ChannelCount-2*SpkCount];
    tpns:=2;   { analog }
  end;
end;

function TdataFile.VtagCount: integer;
var
  i:integer;
begin
  result:=0;
  for i:=1 to maxVtag do
    if datatag[i]<>nil then inc(result);
end;

procedure TdataFile.BuildSpkArrays(var spk: TspkArray; var Att: TattArray);
var
  ep,ch,i:integer;
  timeT: float;
begin

  if assigned(spkTable) then
  begin
    ClearSpkTable;
    initData(true,false);
  end;

  setLength(spk,EpCount);
  setLength(att,EpCount);

  for ep:=0 to EpCount-1 do
  begin
    setEpNum(ep+1);

    timeT:=fileDesc.CorrectedCyberTime(ep+1)-fileDesc.CorrectedCyberTime(1);   // temps absolu en secondes

    setLength(spk[ep],SpkCount);
    setLength(att[ep],SpkCount);

    for ch:=0 to SpkCount-1 do
    begin
      setLength(spk[ep,ch],Fspk[ch].Icount);
      setLength(att[ep,ch],Fspk[ch].Icount);

      for i:=0 to Fspk[ch].Icount-1 do
      begin
        spk[ep,ch,i]:=Fspk[ch].Jvalue[1+i]+round(timeT*30000);
        att[ep,ch,i]:=Fspk[ch].AttValue[1+i];
      end;
    end;
  end;


end;

procedure TdataFile.getNSflags;
begin
  NSflagsDlg.Execute(self);

  move(NSVflag,NSVflagGlb,sizeof(NSVflag));
  move(NSVtagflag,NSVtagflagGlb,sizeof(NSVtagflag));
  SpkTableNumGlb:=SpkTableNum;
end;

function TdataFile.fileStream: TStream;
begin
  if fileDesc is TElphyDescriptor
    then result:= TElphyDescriptor(fileDesc).fileStream
    else result:=nil;
end;

function TdataFile.ElphyDataTime(ep: integer): TdateTime;
begin
  if fileDesc is TElphyDescriptor
    then result:= TElphyDescriptor(fileDesc).ElphyDataTime(ep)
    else result:=0;
end;

function Tdatafile.EpPCTime(ep:integer): longword;
begin
  if fileDesc is TElphyDescriptor
    then result:= TElphyDescriptor(fileDesc).EpPCTime(ep)
    else result:=0;
end;

procedure TdataFile.getVisuInfo;
begin
  if not assigned(VisuInfo) then VisuInfo:=TDBrecord.create;
  if filedesc is TElphyDescriptor
    then TElphyDescriptor(fileDesc).getVisuInfo(visuInfo);
end;

{********************* Méthodes stm ****************************************}


procedure proTdataFile_create(name:AnsiString;var pu:typeUO);
begin
  createPgObject(name,pu,TdataFile);

  with Tdatafile(pu) do
  begin
    setChildNames;
  end;
end;

procedure proTdataFile_create_1(var pu:typeUO);
begin
  proTdataFile_create('',pu);
end;

{Les voies : 6 pour le moment }

function fonctionTdataFile_V(i:integer;var pu:typeUO):pointer;
begin
  verifierObjet(pu);

  with Tdatafile(pu) do
  begin
    dec(i);
    if (i>=0) and (i<length(Fchannel))
      then result:=@Fchannel[i]
      else sortieErreur('TdataFile.V  :  invalid channel number');
  end;
end;

function fonctionTdataFile_v1(var pu:typeUO):pointer;
begin
  verifierObjet(pu);
  with Tdatafile(pu) do fonctionTdataFile_v1:=@Fchannel[0];
end;

function fonctionTdataFile_v2(var pu:typeUO):pointer;
begin
  verifierObjet(pu);
  with Tdatafile(pu) do fonctionTdataFile_v2:=@Fchannel[1];
end;

function fonctionTdataFile_v3(var pu:typeUO):pointer;
begin
  verifierObjet(pu);
  with Tdatafile(pu) do fonctionTdataFile_v3:=@Fchannel[2];
end;

function fonctionTdataFile_v4(var pu:typeUO):pointer;
begin
  verifierObjet(pu);
  with Tdatafile(pu) do fonctionTdataFile_v4:=@Fchannel[3];
end;

function fonctionTdataFile_v5(var pu:typeUO):pointer;
begin
  verifierObjet(pu);
  with Tdatafile(pu) do fonctionTdataFile_v5:=@Fchannel[4];
end;

function fonctionTdataFile_v6(var pu:typeUO):pointer;
begin
  verifierObjet(pu);
  with Tdatafile(pu) do fonctionTdataFile_v6:=@Fchannel[5];
end;

{Les moyennes : 6 pour le moment }

function fonctionTdataFile_m(i:integer;var pu:typeUO):pointer;
begin
  verifierObjet(pu);
  with Tdatafile(pu) do
  begin
    dec(i);
    if (i>=0) and (i<length(Fmoy))
      then result:=@Fmoy[i]
      else sortieErreur('TdataFile.M  :  invalid channel number');
  end;
end;

function fonctionTdataFile_m1(var pu:typeUO):pointer;
begin
  verifierObjet(pu);
  with Tdatafile(pu) do fonctionTdataFile_m1:=@Fmoy[0];
end;

function fonctionTdataFile_m2(var pu:typeUO):pointer;
begin
  verifierObjet(pu);
  with Tdatafile(pu) do fonctionTdataFile_m2:=@Fmoy[1];
end;

function fonctionTdataFile_m3(var pu:typeUO):pointer;
begin
  verifierObjet(pu);
  with Tdatafile(pu) do fonctionTdataFile_m3:=@Fmoy[2];
end;

function fonctionTdataFile_m4(var pu:typeUO):pointer;
begin
  verifierObjet(pu);
  with Tdatafile(pu) do fonctionTdataFile_m4:=@Fmoy[3];
end;

function fonctionTdataFile_m5(var pu:typeUO):pointer;
begin
  verifierObjet(pu);
  with Tdatafile(pu) do fonctionTdataFile_m5:=@Fmoy[4];
end;

function fonctionTdataFile_m6(var pu:typeUO):pointer;
begin
  verifierObjet(pu);
  with Tdatafile(pu) do fonctionTdataFile_m6:=@Fmoy[5];
end;

function fonctionTdataFile_Vspk(i:integer;var pu:typeUO):pointer;
begin
  verifierObjet(pu);

  with Tdatafile(pu) do
  begin
    dec(i);
    if (i>=0) and (i<length(Fspk))
      then result:=@Fspk[i]
      else sortieErreur('TdataFile.Vspk  :  invalid channel number');
  end;
end;

function fonctionTdataFile_Wspk(i:integer;var pu:typeUO):pointer;
begin
  verifierObjet(pu);

  with Tdatafile(pu) do
  begin
    dec(i);
    if (i>=0) and (i<length(FWspk))
      then result:=@FWspk[i]
      else sortieErreur('TdataFile.Wspk  :  invalid channel number');
  end;
end;

function fonctionTdataFile_PCL(var pu:typeUO):pointer;
begin
  verifierObjet(pu);

  with Tdatafile(pu) do
  begin
    if not assigned(FPCL) then sortieErreur('TdataFile.PCL : object is not present')
    else
    result:=@FPCL;
  end;
end;


{ Les voies Tag }
function fonctionTdataFile_Vtag(i:integer;var pu:typeUO):pointer;
begin
  verifierObjet(pu);
  if (i<1) or (i>MaxVtag) then sortieErreur(E_Vtag);
  with Tdatafile(pu) do result:=@Vtag[i];
end;

function fonctionTdataFile_Vtag1(var pu:typeUO):pointer;
begin
  verifierObjet(pu);
  with Tdatafile(pu) do result:=@Vtag[1];
end;

function fonctionTdataFile_Vtag2(var pu:typeUO):pointer;
begin
  verifierObjet(pu);
  with Tdatafile(pu) do result:=@Vtag[2];
end;

{ Les voies Sound }
function fonctionTdataFile_Vsound(i:integer;var pu:typeUO):pointer;
begin
  verifierObjet(pu);
  if (i<1) or (i>2) then sortieErreur(E_Vsound);
  with Tdatafile(pu) do result:=@Vsound[i];
end;

function fonctionTdataFile_Vsound1(var pu:typeUO):pointer;
begin
  verifierObjet(pu);
  with Tdatafile(pu) do result:=@Vsound[1];
end;

function fonctionTdataFile_Vsound2(var pu:typeUO):pointer;
begin
  verifierObjet(pu);
  with Tdatafile(pu) do result:=@Vsound[2];
end;


function fonctionTdataFile_nbSeq(var pu:typeUO):integer;
begin
  verifierObjet(pu);
  with Tdatafile(pu) do result:=EpCount;
end;

function fonctionTdataFile_nbvoie(var pu:typeUO):integer;
begin
  verifierObjet(pu);

  with Tdatafile(pu) do
    result:=channelCount;
end;

procedure proTdataFile_afficherNumSeq(var pu:typeUO);
begin
  verifierObjet(pu);
  with Tdatafile(pu) do afficherNumSeq(FepNum);
end;

procedure proTdataFile_setNumSeq(n:integer;var pu:typeUO);
begin
  verifierObjet(pu);
  with Tdatafile(pu) do
    if not setEpNum(n) then sortieErreur(E_numseq);
end;

function fonctionTdataFile_NumSeq(var pu:typeUO):integer;
begin
  verifierObjet(pu);
  with Tdatafile(pu) do fonctionTdataFile_NumSeq:=FepNum;
end;


procedure proTdataFile_NumSeq(n:integer;var pu:typeUO);
begin
  verifierObjet(pu);
  with Tdatafile(pu) do
    if not setEpNum(n) then sortieErreur(E_numseq);
end;

function fonctionTdataFile_NbPtSeq(var pu:typeUO):integer;
begin
  verifierObjet(pu);
  with Tdatafile(pu) do
  begin
    if assigned(fileDesc) then result:=fileDesc.nbptSeq(1)
    else
    if AcqON then result:=acqinf.Qnbpt
    else sortieErreur(E_noData);
  end;
end;

function fonctionTdataFile_NomData(var pu:typeUO):AnsiString;
var
  st:AnsiString;
begin
  verifierObjet(pu);
  with Tdatafile(pu) do
  begin
    if AcqON
      then st:=extractFileName(AcqinfF.stDat)
      else st:=extractFileName(stFichier);
    if pos('.',st)>0 then st:=copy(st,1,pos('.',st)-1);
    result:=st;
  end;
end;

function fonctionTdataFile_CheminData(var pu:typeUO):AnsiString;
begin
  verifierObjet(pu);
  with Tdatafile(pu) do
    if AcqON
      then result:=cheminDuFichier(AcqinfF.stDat)
      else result:=CheminDuFichier(stFichier);
end;

function fonctionTdataFile_ExtData(var pu:typeUO):AnsiString;
begin
  verifierObjet(pu);
  with Tdatafile(pu) do
    if AcqON
      then result:=ExtensionDuFichier(AcqinfF.stDat)
      else result:=ExtensionDuFichier(stFichier);
end;


procedure proTdataFile_NouveauFichier(st:AnsiString;var pu:typeUO);
begin
  verifierObjet(pu);
  with Tdatafile(pu) do
  begin
    if acqON then sortieErreur(E_InstallDataFile);
    installFile0(st,true,false);
    if fileDesc=nil then sortieErreur(E_InstallDataFile);
  end;
end;

procedure proTdataFile_NouveauFichier_1(st:AnsiString;var errCode:integer;var pu:typeUO);
begin
  verifierObjet(pu);
  with Tdatafile(pu) do
  begin
    if acqON then sortieErreur(E_InstallDataFile);
    installFile0(st,true,true);
    errCode:=ord(fileDesc=nil) ;
  end;
end;

procedure proTdataFile_ClearAverage(var pu:typeUO);
begin
  verifierObjet(pu);
  with Tdatafile(pu) do
  begin
    DclearMoy;
  end;
end;

procedure proTdataFile_AddToAverage(var pu:typeUO);
begin
  verifierObjet(pu);
  with Tdatafile(pu) do
  begin
    if channelCount>0 then
      begin
        if not ContinuousFile then Dtag
        else sortieErreur(E_accumulerCont);
      end
    else sortieErreur(E_noData);
  end;
end;

procedure proTdataFile_AddToAverage1(x:float;var pu:typeUO);
begin
  verifierObjet(pu);
  with Tdatafile(pu) do
  begin
    if ChannelCount>0 then
      begin
        if ContinuousFile then Dtag1(x)
        else sortieErreur(E_accumulerNotCont);
      end
    else sortieErreur(E_noData);
  end;
end;

(*
procedure proTdataFile_SaveAverage(numF:integer;var pu:typeUO);
begin
  verifierObjet(pu);
  with Tdatafile(pu) do
  begin
    if channelCount=0
      then sortieErreur(E_noData);
    sauverFichierPg(numF,sauverMoyPg);
  end;
end;
*)
procedure proTdataFile_StdON(w:boolean;var pu:typeUO);
begin
  verifierObjet(pu);
  with Tdatafile(pu) do
  begin
    if Fmoy[0].count>0 then sortieErreur(E_MoyStd);
    setMoyStd(w);
  end;
end;

function fonctionTdataFile_StdON(var pu:typeUO):boolean;pascal;
begin
  verifierObjet(pu);
  with Tdatafile(pu) do
  begin
    result:=FmoyStd;
  end;
end;

procedure proTdataFile_InitAverages(tp,i1,i2:integer;var pu:typeUO);
begin
  verifierObjet(pu);
  with Tdatafile(pu) do
  begin
    if not (typetypeG(tp) in [G_single,G_double,G_extended])
      then sortieErreur(E_typeMoy);
    if (i1>i2) then sortieErreur(E_extentMoy);

    initAverages(typetypeG(tp),i1,i2);
  end;
end;


procedure proTdataFile_AverageType(n:integer;var pu:typeUO);
begin
  verifierObjet(pu);
  with Tdatafile(pu) do
  begin
    if not (typetypeG(n) in [G_single,G_double,G_extended])
      then sortieErreur(E_typeMoy);
    setAverageType(typetypeG(n));
  end;
end;

function fonctionTdataFile_AverageType(var pu:typeUO):integer;
begin
  verifierObjet(pu);
  with Tdatafile(pu) do
  result:=ord(typeMoy)

end;


procedure proTdataFile_GetEpInfo(var x;size:integer;tpn:word;dep:integer;var pu:typeUO);
begin
  verifierObjet(pu);
  with Tdatafile(pu) do
  begin
    if filedesc=nil then sortieErreur(E_pasDeFichierData);
    if not assigned(fileDesc) or not (filedesc.isAcquis1)
      then sortieErreur(E_Acquis1DataFile);

    if not Tac1Descriptor(fileDesc).getEpInfo(x,size,dep)
      then sortieErreur(E_getEpInfo);
  end;
end;

procedure proTdataFile_SetEpInfo(var x;size:integer;tpn:word;dep:integer;var pu:typeUO);
begin
  verifierObjet(pu);
  with Tdatafile(pu) do
  begin
    if filedesc=nil then sortieErreur(E_pasDeFichierData);
    if not assigned(fileDesc) or not (filedesc.isAcquis1)
      then sortieErreur(E_Acquis1DataFile);

    if not Tac1Descriptor(fileDesc).setEpInfo(x,size,dep)
      then sortieErreur(E_setEpInfo);
  end;
end;

procedure proTdataFile_ReadEpInfo(var x;size:integer;tpn:word;var pu:typeUO);
begin
  verifierObjet(pu);
  with Tdatafile(pu) do
  begin
    if filedesc=nil then sortieErreur(E_pasDeFichierData);
    if not assigned(fileDesc) or not (filedesc.isAcquis1)
      then sortieErreur(E_Acquis1DataFile);

    if not Tac1Descriptor(fileDesc).readEpInfo(x,size)
      then sortieErreur(E_getEpInfo);
  end;
end;

procedure proTdataFile_ReadEpInfoExt(var x;size:integer;tpn:word;var pu:typeUO);
{$IFDEF WIN64}
var
  dum: PtabOctet;
  nb,i: integer;
begin
  if (size mod 8<>0) or (tpn<>ord(nbExtended)) then sortieErreur('TdataFile.ReadEpInfoExt : variable type is not extended');

  nb:=size div 8;
  getmem(dum,nb*10);
  try
    proTdataFile_ReadEpInfo(dum^, nb*10, tpn, pu);

    TRY
      for i:=0 to nb-1 do
        PtabDouble(@x)^[i]:=ExtendedToDouble(dum^[i*10]);
    EXCEPT
      for i:=0 to nb-1 do
        PtabDouble(@x)^[i]:=0;
    END;
  finally
   freemem(dum);
  end;
end;
{$ELSE}
begin
   proTdataFile_ReadEpInfo(x, size, tpn, pu);
end;
{$ENDIF}

procedure proTdataFile_WriteEpInfo(var x;size:integer;tpn:word;var pu:typeUO);
begin
  verifierObjet(pu);
  with Tdatafile(pu) do
  begin
    if filedesc=nil then sortieErreur(E_pasDeFichierData);
    if not assigned(fileDesc) or not (filedesc.isAcquis1)
      then sortieErreur(E_Acquis1DataFile);

    if not Tac1Descriptor(fileDesc).writeEpInfo(x,size)
      then sortieErreur(E_setEpInfo);
  end;
end;

procedure proTdataFile_WriteEpInfoExt(var x;size:integer;tpn:word;var pu:typeUO);
{$IFDEF WIN64}
var
  dum:PtabOctet;
  nb,i:integer;
begin
  if (size mod 8<>0) or (tpn<>ord(nbExtended)) then sortieErreur('TdataFile.writeEpInfoExt : variable type is not extended');

  nb:=size div 8;
  getmem(dum,nb*10);
  try
  for i:=0 to nb-1 do
    DoubleToExtended(PtabDouble(@x)^[i], dum^[i*10]);

    proTdataFile_WriteEpInfo(dum^, nb*10, tpn, pu);
  finally
  freemem(dum);
  end;
end;
{$ELSE}
begin
  proTdataFile_WriteEpInfo(x, size, tpn, pu);
end;

{$ENDIF}

procedure proTdataFile_ResetEpInfo(var pu:typeUO);
begin
  verifierObjet(pu);
  with Tdatafile(pu) do
  begin
    if filedesc=nil then sortieErreur(E_pasDeFichierData);
    if not assigned(fileDesc) or not (filedesc.isAcquis1)
      then sortieErreur(E_Acquis1DataFile);

    Tac1Descriptor(fileDesc).resetEpInfo;
  end;
end;


procedure proTdataFile_GetFileInfo(var x;size:integer;tpn:word;dep:integer;var pu:typeUO);
begin
  verifierObjet(pu);
  with Tdatafile(pu) do
  begin
    if filedesc=nil then sortieErreur(E_pasDeFichierData);
    if not assigned(fileDesc) or not (filedesc.isAcquis1)
      then sortieErreur(E_Acquis1DataFile);

    if not Tac1Descriptor(fileDesc).getFileInfo(x,size,dep)
      then sortieErreur(E_getFileInfo);
  end;
end;

procedure proTdataFile_SetFileInfo(var x;size:integer;tpn:word;dep:integer;var pu:typeUO);
begin
  verifierObjet(pu);
  with Tdatafile(pu) do
  begin
    if filedesc=nil then sortieErreur(E_pasDeFichierData);
    if not assigned(fileDesc) or not (filedesc.isAcquis1)
      then sortieErreur(E_Acquis1DataFile);

    if not Tac1Descriptor(fileDesc).setFileInfo(x,size,dep)
      then sortieErreur(E_setFileInfo);
  end;

end;

procedure proTdataFile_ReadFileInfo(var x;size:integer;tpn:word;var pu:typeUO);
var
  i:integer;
begin
  verifierObjet(pu);
  with Tdatafile(pu) do
  begin
    if filedesc=nil then sortieErreur(E_pasDeFichierData);
    if not assigned(fileDesc) or not (filedesc.isAcquis1)
      then sortieErreur(E_Acquis1DataFile);

    if not Tac1Descriptor(fileDesc).readFileInfo(x,size)
      then sortieErreur(E_getFileInfo);

  end;

end;

procedure proTdataFile_ReadFileInfoExt(var x;size:integer;tpn:word;var pu:typeUO);
{$IFDEF WIN64}
var
  dum: PtabOctet;
  nb,i: integer;
  FlagErr: boolean;
begin
  if (size mod 8<>0) or (tpn<>ord(nbExtended)) then sortieErreur('TdataFile.ReadFileInfoExt : variable type is not extended');

  FlagErr:=false;
  nb:=size div 8;
  getmem(dum,nb*10);
  try
    proTdataFile_ReadFileInfo(dum^, nb*10, tpn, pu);
    TRY
      for i:=0 to nb-1 do
      begin
        PtabDouble(@x)^[i]:=ExtendedToDouble(dum^[i*10])+1; // On le force à faire une opération
        PtabDouble(@x)^[i]:= PtabDouble(@x)^[i] -1;
      end;
    EXCEPT
      for i:=0 to nb-1 do
        PtabDouble(@x)^[i]:=0;
      FlagErr:=true;
    END;
  finally
   freemem(dum);
  end;
  if FlagErr then sortieErreur('ReadFileInfoExt error');
end;
{$ELSE}
begin
   proTdataFile_ReadFileInfo(x, size, tpn, pu);
end;
{$ENDIF}


procedure proTdataFile_WriteFileInfo(var x;size:integer;tpn:word;var pu:typeUO);
begin
  verifierObjet(pu);
  with Tdatafile(pu) do
  begin
    if filedesc=nil then sortieErreur(E_pasDeFichierData);
    if not assigned(fileDesc) or not (filedesc.isAcquis1)
      then sortieErreur(E_Acquis1DataFile);

    if not Tac1Descriptor(fileDesc).writeFileInfo(x,size)
      then sortieErreur(E_setFileInfo);
  end;
end;


procedure proTdataFile_WriteFileInfoExt(var x;size:integer;tpn:word;var pu:typeUO);
{$IFDEF WIN64}
var
  dum:PtabOctet;
  nb,i:integer;
begin
  if (size mod 8<>0) or (tpn<>ord(nbExtended)) then sortieErreur('TdataFile.writeFileInfoExt : variable type is not extended');

  nb:=size div 8;
  getmem(dum,nb*10);
  try
  for i:=0 to nb-1 do
    DoubleToExtended(PtabDouble(@x)^[i], dum^[i*10]);

    proTdataFile_WriteFileInfo(dum^, nb*10, tpn, pu);
  finally
  freemem(dum);
  end;
end;
{$ELSE}
begin
  proTdataFile_WriteFileInfo(x, size, tpn, pu);
end;

{$ENDIF}


procedure proTdataFile_ResetFileInfo(var pu:typeUO);
begin
  verifierObjet(pu);
  with Tdatafile(pu) do
  begin
    if filedesc=nil then sortieErreur(E_pasDeFichierData);
    if not assigned(fileDesc) or not (filedesc.isAcquis1)
      then sortieErreur(E_Acquis1DataFile);

    Tac1Descriptor(fileDesc).resetFileInfo;
  end;
end;


function fonctionTdataFile_EpInfoSize(var pu:typeUO):integer;
begin
  verifierObjet(pu);
  with Tdatafile(pu) do
  begin
    if filedesc=nil then sortieErreur(E_pasDeFichierData);
    if not assigned(fileDesc) or not (filedesc.isAcquis1)
      then sortieErreur(E_Acquis1DataFile);

    fonctionTdataFile_EpInfoSize:=Tac1Descriptor(fileDesc).EpInfoSize;
  end;
end;

function fonctionTdataFile_FileInfoSize(var pu:typeUO):integer;
begin
  verifierObjet(pu);
  with Tdatafile(pu) do
  begin
    if filedesc=nil then sortieErreur(E_pasDeFichierData);
    if not assigned(fileDesc) or not (filedesc.isAcquis1)
      then sortieErreur(E_Acquis1DataFile);

    fonctionTdataFile_FileInfoSize:=Tac1Descriptor(fileDesc).FileInfoSize;
  end;
end;

function fonctionTdataFile_Mtag(var pu:typeUO):pointer;
begin
  verifierObjet(pu);
  with Tdatafile(pu) do fonctionTdataFile_Mtag:=@Mtag;
end;

function fonctionTdataFile_Comment(var pu:typeUO):pointer;
begin
  verifierObjet(pu);
  with Tdatafile(pu) do result:=@memoC;
end;


function fonctionTdataFile_getSM2info
  (stName,st:AnsiString;var w;size,tp:word;var pu:typeUO):boolean;
begin
  verifierObjet(pu);
  with Tdatafile(pu) do result:=getSm2Info(stName,st,w,size,tp);
end;


function fonctionTdataFile_getSM2RF(var x,y,dx,dy,theta:float;var pu:typeUO):boolean;
begin
  verifierObjet(pu);
  with Tdatafile(pu) do result:=getSm2RF(x,y,dx,dy,theta);
end;

function fonctionTdataFile_StimInfo(var pu:typeUO):pointer;
begin
  verifierObjet(pu);
  with Tdatafile(pu) do result:=@StimInfo;
end;

function fonctionTdataFile_AcqInfo(var pu:typeUO):pointer;
begin
  verifierObjet(pu);
  with Tdatafile(pu) do result:=@AcqInfo;
end;

function datafile0:TdataFile;
begin
  result:=DacDataFile;
end;

function fonctionTdataFile_SearchAndload(st:AnsiString;numOc:integer;var ob,pu:typeUO):boolean;
begin
  verifierObjet(pu);
  verifierObjet(ob);

  result:=TdataFile(pu).SearchAndload(st,numOc,ob);
end;

function fonctionTdataFile_SearchTypeAndload(numOc:integer;var ob,pu:typeUO):boolean;
begin
  verifierObjet(pu);
  verifierObjet(ob);

  result:=TdataFile(pu).searchClassAndLoad(numOc,ob);
end;


function fonctionTdataFile_OIseqCount(var pu:typeUO):integer;
begin
  verifierObjet(pu);
  result:=TdataFile(pu).OIseqCount;
end;

function fonctionTdataFile_OIseq(n:integer;var pu:typeUO):pointer;
begin
  verifierObjet(pu);
  result:=TdataFile(pu).getOIseq(n-1);
  if result=nil then sortieErreur('TdataFile.OIseq : image sequence not found');

  result:=@TdataFile(pu).OIseqs[n-1].myAd;
end;

procedure proTdataFile_AppendOI(Src: AnsiString;var pu:typeUO);
begin
  verifierObjet(pu);
  TdataFile(pu).AppendOIblocks(Src);
end;

procedure proTdataFile_AppendObject(var ob, pu:typeUO);
begin
  verifierObjet(pu);
  if TdataFile(pu).AppendObject(ob)<0 then sortieErreur('TdataFile.AppendObject : write error');
end;

procedure proTdataFile_BuildOIvecFile(stF: AnsiString;var pu:typeUO);
begin
  verifierObjet(pu);
  TdataFile(pu).BuildOIvecFile(stF);
end;

procedure proTdataFile_setOIvecFile(stF: AnsiString;var pu:typeUO);
begin
  verifierObjet(pu);
  TdataFile(pu).setOIvecFile(stF);
end;


procedure proTdataFile_ReadDBFileInfo(var db:TDBrecord; var pu:typeUO);
var
  db0:TDBrecord;
begin
  verifierObjet(pu);
  verifierObjet(typeUO(db));

  with TdataFile(pu) do
  begin
    db.clear;
    if not (fileDesc is TelphyDescriptor) then exit;
    db0:=TelphyDescriptor(fileDesc).ReadDBFileInfo;

    if assigned(db0) then db.assign(db0);
  end;
end;

procedure proTdataFile_ReadDBepInfo(var db:TDBrecord; var pu:typeUO);
var
  db0:TDBrecord;
begin
  verifierObjet(pu);
  verifierObjet(typeUO(db));

  with TdataFile(pu) do
  begin
    db.clear;
    if not (fileDesc is TelphyDescriptor) then exit;
    db0:=TelphyDescriptor(fileDesc).ReadDBepInfo;

    if assigned(db0) then db.assign(db0);
  end;
end;



procedure proTdataFile_InitSpkTable(var table:TspkTable;var pu:typeUO);
begin
  verifierObjet(typeUO(table));
  verifierObjet(pu);

  if not TdataFile(pu).InitSpkTable(table)
    then sortieErreur('TdataFile.InitSpkTable : unable to initialize Table');
end;

procedure proTdataFile_SetSpkTable(var table:TspkTable;var pu:typeUO);
begin
  verifierObjet(pu);  { table=nil accepté }
  if not TdataFile(pu).SetSpkTable(table)
    then sortieErreur('TdataFile.SetSpkTable : unable to install Table');
end;

procedure proTdataFile_LoadSpkTable(n:integer;var pu:typeUO);
begin
  verifierObjet(pu);
  if not TdataFile(pu).LoadSpkTable(n)
    then sortieErreur('TdataFile.LoadSpkTable : unable to load Table');
end;


function fonctionTdataFile_MaxChannelCount(var pu:typeUO):integer;
begin
  verifierObjet(pu);

  with Tdatafile(pu) do
    result:=maxChan;
end;

function fonctionTdataFile_MaxVspkCount(var pu:typeUO):integer;
begin
  verifierObjet(pu);

  with Tdatafile(pu) do
    result:=maxSpk;
end;

function fonctionTdataFile_VspkCount(var pu:typeUO):integer;
begin
  verifierObjet(pu);

  with Tdatafile(pu) do
    result:=SpkCount;
end;

function fonctionTdataFile_CyberTime(ep:integer; var pu:typeUO):float;
begin
  verifierObjet(pu);
  result:=Tdatafile(pu).filedesc.CyberTime(ep);
end;

function fonctionTdataFile_CorrectedCyberTime(ep:integer; var pu:typeUO):float;
begin
  verifierObjet(pu);
  result:=Tdatafile(pu).filedesc.CorrectedCyberTime(ep);
end;

function fonctionTdataFile_Vcounts(num,ep:integer; var pu:typeUO):integer;
begin
  verifierObjet(pu);

  with Tdatafile(pu) do
  begin
    if (num<1) or (num>ChannelCount) then sortieErreur('TdataFile.Vcounts : channel number out of range');
    if (ep<1) or (ep>epCount) then sortieErreur('TdataFile.Vcounts : episode number out of range');

    if (fileDesc is TelphyDescriptor)
      then result:= TelphyDescriptor(fileDesc).getVCounts(num,ep)
      else result:=0;
  end;
end;

function fonctionTdataFile_VtagCounts(num,ep:integer; var pu:typeUO):integer;
begin
  verifierObjet(pu);

  with Tdatafile(pu) do
  begin
    if (num<1) or (num>VTagCount) then sortieErreur('TdataFile.VtagCounts : Channel number out of range');
    if (ep<1) or (ep>epCount) then sortieErreur('TdataFile.VtagCounts : episode number out of range');

    if (fileDesc is TelphyDescriptor)
      then result:= TelphyDescriptor(fileDesc).getVtagCounts(num,ep)
      else result:=0;
  end;
end;

function fonctionTdataFile_VspkCounts(num,ep:integer; var pu:typeUO):integer;
begin
  verifierObjet(pu);

  with Tdatafile(pu) do
  begin
    if (num<1) or (num>SpkCount) then sortieErreur('TdataFile.VspkCounts : Vspk channel number out of range');
    if (ep<1) or (ep>epCount) then sortieErreur('TdataFile.VspkCounts : episode number out of range');

    if (fileDesc is TelphyDescriptor)
      then result:= TelphyDescriptor(fileDesc).getVspkCounts(num,ep)
      else result:=0;
  end;
end;

function fonctionTdataFile_DataFileSize(var pu:typeUO):int64;
begin
  verifierObjet(pu);
  with Tdatafile(pu) do
  if assigned(fileDesc)
    then result:=fileDesc.fileSizeD
    else result:=0;
end;

function fonctionTdataFile_DataFileAge(var pu:typeUO):TdateTime;
begin
  verifierObjet(pu);
  with Tdatafile(pu) do
  if assigned(fileDesc)
    then result:=fileDesc.FileAgeD
    else result:=0;
end;




procedure TdataFile.TestDF;
var
  mm:integer;
begin
  mm:=AllocatedMem;
  FileDesc:=TElphyDescriptor.create;
  fileDesc.init('D:\dac2\Luc\STA4_01.DAT');
  fileDesc.free;
  fileDesc:=nil;

  messageCentral('mm='+Istr(AllocatedMem-mm));
end;


procedure proTdataFile_OnChange(p:integer;var pu:typeUO);
begin
  verifierObjet(pu);
  with Tdatafile(pu).onChange do setAd(p);
end;

function fonctionTdataFile_OnChange(var pu:typeUO):integer;
begin
  verifierObjet(pu);
  result:=TdataFile(pu).OnChange.ad;
end;

procedure proTdataFile_OnChangeEpisode(p:integer;var pu:typeUO);
begin
  verifierObjet(pu);
  with Tdatafile(pu).onChangeEpisode do setAd(p);
end;

function fonctionTdataFile_OnChangeEpisode(var pu:typeUO):integer;
begin
  verifierObjet(pu);
  result:=TdataFile(pu).OnChangeEpisode.ad;
end;


function fonctionTdataFile_ElphyTime(ep:integer; var pu:typeUO):TdateTime;
begin
  verifierObjet(pu);
  result:=TdataFile(pu).ElphyDataTime(ep);
end;

function fonctionTdataFile_EpPCTime(ep:integer; var pu:typeUO): longword;
begin
  verifierObjet(pu);
  result:=TdataFile(pu).EpPCTime(ep);
end;

procedure proTdataFile_CopyBlockTo(var f: TobjectFile; num: integer;var pu:typeUO);
begin
  verifierObjet(pu);
  verifierObjet(typeUO(f));

  with TdataFile(pu) do
  begin
    if filedesc is TElphyDescriptor then
    begin
      if not f.copy(TElphyDescriptor(fileDesc).ObjFile,num-1)
        then sortieErreur('TdataFile.CopyBlockTo : unable to copy block');
    end
    else sortieErreur('TdataFile.CopyBlockTo : file is not an Elphy File');
  end;
end;

function fonctionTdataFile_ClassNames(n:integer;var pu:typeUO):AnsiString;
begin
  verifierObjet(pu);
  with TdataFile(pu) do
  begin
    if filedesc is TElphyDescriptor then
    with TElphyDescriptor(fileDesc).ObjFile do
    begin
      if (n<1) or (n>stClasses.count) then sortieErreur('TdataFile.ClassNames : index out of range');
      result:=stClasses[n-1];
    end
    else sortieErreur('TdataFile.ClassNames : file is not an Elphy File');
  end;
end;

function fonctionTdataFile_Objcount(var pu:typeUO):integer;
begin
  verifierObjet(pu);
  with TdataFile(pu) do
  begin
    if filedesc is TElphyDescriptor then
    with TElphyDescriptor(fileDesc).ObjFile do
      result:= ObjCount
    else sortieErreur('TdataFile.ObjCount : file is not an Elphy File');
  end;

end;

function fonctionTdataFile_VisuInfo(var pu: typeUO):pointer;
begin
  verifierObjet(pu);
  with TdataFile(pu) do
  begin
    getVisuInfo;
    result:=@VisuInfo;
  end;
end;

procedure proTdataFile_FreeFileStream(var pu:typeUO);
begin
  verifierObjet(pu);

  with TdataFile(pu) do FreeFileStream;
end;


procedure proElphyFileToAnalogBinaryFile(stSrc,stDest: AnsiString; var Vchan: Tvector; DW: integer;mux:boolean; var VstartPos:Tvector);
var
  Chans: TarrayOfInteger;
  startPos:TarrayOfInt64;
  i: integer;
begin
  verifierobjet(typeuo(Vchan));
  verifierobjet(typeuo(VstartPos));

  setLength(Chans, Vchan.Icount);
  for i:=0 to high(Chans) do
    Chans[i]:= Vchan.Jvalue[Vchan.Istart+i];

  ElphyFileToAnalogBinaryFile(stSrc,stDest, Chans, startPos, DW,mux);

  VstartPos.modify(g_double,1,length(StartPos));
  for i:= 1 to length(StartPos) do
    VstartPos[i]:= StartPos[i-1];
end;




procedure TdataFile.GetBinaryFileParams;
begin
  LoadBinForm.execute(DataFileRecBin);
end;

Initialization
AffDebug('Initialization stmdf0',0);

installError(E_channel,'DataFile: Invalid channel number');
installError(E_affectation,'DataFile: cannot modify this object');
installError(E_traceEv,'DataFile: No events');
installError(E_noData,'DataFile: No data');
installError(E_numSeq,'DataFile: Bad episode number');
installError(E_InstallDataFile,'DataFile: unable to install the new data file');
installError(E_accumulerCont,'DataFile: data file cannot be continuous');
installError(E_accumulerNotCont,'DataFile: data file must be continuous');
installError(E_acquis1dataFile,'DataFile: type must be Acquis1 data file type');

installError(E_getEpInfo,'DataFile: Unable to read episode information');
installError(E_setEpInfo,'DataFile: Unable to write episode information');

installError(E_getFileInfo,'DataFile: Unable to read file information');
installError(E_setFileInfo,'DataFile: Unable to write file information');

installError(E_Vtag,'DataFile: Invalid tag number');
installError(E_Vsound,'DataFile: Invalid Sound number');
installError(E_MoyStd,'DataFile.stdON: average count must be zero');

installError(E_typeMoy,'DataFile: Bad average type');
installError(E_extentMoy,'DataFile: Bad average index');


fillchar(testedFiles,sizeof(testedFiles),1);

registerObject(TdataFile,data);

end.
