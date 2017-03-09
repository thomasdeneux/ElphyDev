unit wacq1;

interface
{$IFDEF FPC} {$mode delphi} {$DEFINE AcqElphy2} {$A1} {$Z1} {$ENDIF}

uses windows,classes,forms,controls,sysutils,math,dialogs, messages,
     util1,Dgraphic,Gdos,Ddosfich,debug0,clock0,dtf0,
     Ncdef2,
     stmdef,stmObj,

     acqDef2,acqInf2,stimInf2,
     AcqBuf1,AcqBrd1,Daffac1,NIbrd1,
     multg1,stmdf0,syncObjs,
     dac2File,acqProc0,
     stmError,
     Mtag0,Mtag2,spk0,
     stmMemo1,
     procFile,stmDobj1,
     stmPg,
     recorder1,
     dataGeneFile,ElphyFile,ElphyFormat,Dtrace1,
     acqCom1,
     wave1,
     FdefDac2,
     EvtAcq1,
     DBrecord1,
     cyberK2,
     cyberKbrd1,
     doubleExt,
     PCL0;




type
  TAFDstate=(S_stopped,S_acq,S_waitEnd);


type
  Tacquisition=class
               private
                 AcqOn0:boolean;
                 FtrigActivate:boolean;
                      {Positionné par ActivateTrigger. Permet de lancer l'acquisition
                      avant la fin de InitTraitement, ce qui garantit de prendre le
                      premier top synchro }

                 lastEvt:integer;

                 FlagSave,FlagNotSave:boolean;

                 etat:integer;


                 FrecSound:boolean;
                 waveIn:TwaveIn;
                 bufSound:pointer;
                 nbSound:integer;
                 FlagSound:boolean;

                 LastXend:float;

                 SaveList:TthreadList;

                 SpkScale: TevtScaling;
                 WaveScale: TspkWaveScaling;
                 procedure setAcqOn(w:boolean);


               public

                 FFflagSave:boolean;

                 Qerror:boolean;

                 fAcq:TdataGeneFile;


                 Nbpt:integer;        {= Qnbpt ou maxEntierLong en continu }
                 Nbpt1:integer;
                 NbVacq:integer;
                 NominalPeriod:float; {Periode par voie en ms ou secondes }
                 PeriodeMicro:float;   {Periode par voie en microsecondes }
                 PeriodeMS:float;     {Periode par voie en millisecondes }

                 numseq,numseq0:integer;
                 numseqInit:integer;


                 trigDate:Tlist;
                 oldSyncNum:boolean;
                 cntTraite:integer; {indice du dernier échantillon traite}
                 cntSave:integer;   {compte les échantillons déjà sauvés}

                 maxEp:integer;

                 mainTag:PMtagArray;

                 Fdigi:boolean;
                 nbvEv:integer;
                 nbEvDisp:integer;

                 FaskPause:boolean;
                 AcqAg:integer;     {taille agregat non compressé en points en acquisition }
                 QKSU:array of word;
                 index0Elphy:integer;
                 ImaxEvt:integer; { TotEvt est passé dans AcqCom1 }

                 FsavingData:boolean; { seulement utilisé par Process }
                 FrepriseON:boolean;

                 KeyBoardMode,KeyBoardWaiting:boolean;
                 KeyBoardStart:boolean;
                 KeyBoardEvent:Tevent;

                 DigEventCh0: integer; {indicé à zéro}

                 LastSaveEvt:integer;

                 constructor create;
                 destructor destroy;override;

                 property AcqOn:boolean read acqOn0 write setAcqOn;

                 procedure initVarAcq(reprise:boolean);

                 function openFile:boolean;
                 procedure PrepElphyFile(Fcont,Fmulti:boolean;nb:integer);

                 procedure SaveObjectsToElphyFile(const Fclose:boolean=true);

                 procedure InsertUtag(cc,index,ep1:integer;tm:TdateTime;st:AnsiString);
                 procedure InsertSound(var buf;nb:integer);
                 procedure TraiterDataDac2(n2:integer);

                 procedure TraiterDataElphySingleBuf(n2:integer);
                 procedure TraiterDataElphyMultiBuf(n2:integer);
                 procedure TraiterDataElphy(n2:integer);

                 procedure TraiterData(n2:integer);

                 procedure SaveEvt(Imax:integer) ;
                 procedure SavePCL(Imax:integer; mode:integer) ; // mode=0 original , 1 skip , 2 extra

                 procedure SaveEvtMulti(Imax:integer);
                 procedure SaveEvtContMulti(Imax:integer; AllEvts, AllTags:boolean);

                 procedure TraiterEvt(i,v:integer);


                 procedure StartAcq(Fsave,Freprise:boolean);
                 procedure EndAcq(ThreadToTerminate:integer);

                 procedure updateDataFile0(num:integer);
                 procedure setMtag(cc:integer);

                 procedure lancerAcq;
                 procedure lancer;

                 procedure StartAcqVS(FdispDat,Fsave, FinitBoard:boolean);
                 procedure EndAcqVS;

                 procedure setSave;
                 procedure setNotSave;
                 procedure buildAcqContext(reprise:boolean);

                 procedure setState(w:TAFDstate);

                 procedure InstallProcess(p00,p0,p1,p2:integer);
                 procedure DisplayBoardErrorMsg;

                 function writeObject(uo:typeUO):boolean;
               end;

type
  TthreadAcq=
             class(Tthread)
               oldNumSeq:integer;
               acq:Tacquisition;

               constructor create(acquisition:Tacquisition);
               destructor destroy;override;
               procedure execute;override;
             end;


var
  acquisition:Tacquisition;

  threadAcq:TthreadAcq;

  DebugTime:float;
  DebugCnt:integer;

procedure displayInfoAcq;


function fonctionTacquisition_Channels(n:integer;var pu:typeUO):pointer;pascal;

procedure proTacqChannel_device(w:integer;var pu:TchannelInfo);pascal;
function fonctionTacqChannel_device(var pu:TchannelInfo):integer;pascal;

procedure proTacqChannel_PhysNum(w:integer;var pu:TchannelInfo);pascal;
function fonctionTacqChannel_PhysNum(var pu:TchannelInfo):integer;pascal;

procedure proTacqChannel_ChannelType(w:integer;var pu:TchannelInfo);pascal;
function fonctionTacqChannel_ChannelType(var pu:TchannelInfo):integer;pascal;

function fonctionTacqChannel_Dy(var pu:TchannelInfo):float;pascal;

function fonctionTacqChannel_y0(var pu:TchannelInfo):float;pascal;

procedure proTacqChannel_unitY(w:AnsiString;var pu:TchannelInfo);pascal;
function fonctionTacqChannel_unitY(var pu:TchannelInfo):AnsiString;pascal;

procedure proTacqChannel_setScale(j1,j2:integer;y1,y2:float;var pu:TchannelInfo);pascal;

procedure proTacqChannel_Gain(w:integer;var pu:TchannelInfo);pascal;
function fonctionTacqChannel_Gain(var pu:TchannelInfo):integer;pascal;

function fonctionTacqChannel_DownSamplingFactor(var pu:TchannelInfo):integer;pascal;
procedure proTacqChannel_DownSamplingFactor(w:integer;var pu:TchannelInfo);pascal;

function fonctionTacqChannel_EvtThreshold(var pu:TchannelInfo):float;pascal;
procedure proTacqChannel_EvtThreshold(w:float;var pu:TchannelInfo);pascal;

function fonctionTacqChannel_EvtHysteresis(var pu:TchannelInfo):float;pascal;
procedure proTacqChannel_EvtHysteresis(w:float;var pu:TchannelInfo);pascal;

function fonctionTacqChannel_EvtRisingEdge(var pu:TchannelInfo):boolean;pascal;
procedure proTacqChannel_EvtRisingEdge(w:boolean;var pu:TchannelInfo);pascal;

function fonctionTacqChannel_NrnSymbolName(var pu:TchannelInfo):AnsiString;pascal;
procedure proTacqChannel_NrnSymbolName(w:AnsiString;var pu:TchannelInfo);pascal;


function fonctionTacquisition_Fcontinuous(var pu:typeUO):boolean;pascal;
procedure proTacquisition_Fcontinuous(w:boolean;var pu:typeUO);pascal;
function fonctionTacquisition_MaxEpCount(var pu:typeUO):integer;pascal;
procedure proTacquisition_MaxEpCount(w:integer;var pu:typeUO);pascal;

function fonctionTacquisition_ChannelCount(var pu:typeUO):integer;pascal;
procedure proTacquisition_ChannelCount(w:integer;var pu:typeUO);pascal;


function fonctionTacquisition_ISI(var pu:typeUO):float;pascal;
procedure proTacquisition_ISI(w:float;var pu:typeUO);pascal;

function fonctionTacquisition_EpDuration(var pu:typeUO):float;pascal;
procedure proTacquisition_EpDuration(w:float;var pu:typeUO);pascal;
function fonctionTacquisition_PeriodPerChannel(var pu:typeUO):float;pascal;
procedure proTacquisition_PeriodPerChannel(w:float;var pu:typeUO);pascal;
function fonctionTacquisition_MaxDuration(var pu:typeUO):float;pascal;
procedure proTacquisition_MaxDuration(w:float;var pu:typeUO);pascal;

function fonctionTacquisition_PreTrigDuration(var pu:typeUO):float;pascal;
procedure proTacquisition_PreTrigDuration(w:float;var pu:typeUO);pascal;

function fonctionTacquisition_Fstimulate(var pu:typeUO):boolean;pascal;
procedure proTacquisition_Fstimulate(w:boolean;var pu:typeUO);pascal;

function fonctionTacquisition_TriggerMode(var pu:typeUO):integer;pascal;
procedure proTacquisition_TriggerMode(w:integer;var pu:typeUO);pascal;

function fonctionTacquisition_TrigChannel(var pu:typeUO):integer;pascal;
procedure proTacquisition_TrigChannel(w:integer;var pu:typeUO);pascal;

function fonctionTacquisition_ThresholdUp(var pu:typeUO):float;pascal;
procedure proTacquisition_ThresholdUp(w:float;var pu:typeUO);pascal;
function fonctionTacquisition_ThresholdDw(var pu:typeUO):float;pascal;
procedure proTacquisition_ThresholdDw(w:float;var pu:typeUO);pascal;

function fonctionTacquisition_TestInterval(var pu:typeUO):integer;pascal;
procedure proTacquisition_TestInterval(w:integer;var pu:typeUO);pascal;

function fonctionTacquisition_NIrisingSlope(var pu:typeUO):boolean;pascal;
procedure proTacquisition_NIrisingSlope(w:boolean;var pu:typeUO);pascal;


procedure proTacquisition_MinimalTimeInBuffer(w:float;var pu:typeUO);pascal;
function  fonctionTacquisition_MinimalTimeInBuffer(var pu:typeUO): float;pascal;

function fonctionTacquisition_ElectrodeCount(var pu:typeUO):integer;pascal;
procedure proTacquisition_ElectrodeCount(w:integer;var pu:typeUO);pascal;

function fonctionTacquisition_MaxNumberOfUnits(var pu:typeUO):integer;pascal;
procedure proTacquisition_MaxNumberOfUnits(w:integer;var pu:typeUO);pascal;

function fonctionTacquisition_SpkWaveLength(var pu:typeUO):integer;pascal;
procedure proTacquisition_SpkWaveLength(w:integer;var pu:typeUO);pascal;

function fonctionTacquisition_SpkSampleBeforeTrigger(var pu:typeUO):integer;pascal;
procedure proTacquisition_SpkSampleBeforeTrigger(w:integer;var pu:typeUO);pascal;

procedure proTacquisition_setWaveFormScale(j1,j2:integer;y1,y2:float;var pu:typeUO);pascal;


function fonctionTacquisition_comment(var pu:typeUO):pointer;pascal;

procedure proTacquisition_GetEpInfo(var x;size:integer;tpn:word;dep:integer;var pu:typeUO);pascal;
procedure proTacquisition_SetEpInfo(var x;size:integer;tpn:word;dep:integer;var pu:typeUO);pascal;

procedure proTacquisition_ReadEpInfo(var x;size:integer;tpn:word;var pu:typeUO);pascal;
procedure proTacquisition_WriteEpInfo(var x;size:integer;tpn:word;var pu:typeUO);pascal;
procedure proTacquisition_ReadEpInfoExt(var x;size:integer;tpn:word;var pu:typeUO);pascal;
procedure proTacquisition_WriteEpInfoExt(var x;size:integer;tpn:word;var pu:typeUO);pascal;

procedure proTacquisition_ResetEpInfo(var pu:typeUO);pascal;
procedure proTacquisition_GetFileInfo(var x;size:integer;tpn:word;dep:integer;var pu:typeUO);pascal;
procedure proTacquisition_SetFileInfo(var x;size:integer;tpn:word;dep:integer;var pu:typeUO);pascal;

procedure proTacquisition_ReadFileInfo(var x;size:integer;tpn:word;var pu:typeUO);pascal;
procedure proTacquisition_WriteFileInfo(var x;size:integer;tpn:word;var pu:typeUO);pascal;
procedure proTacquisition_ReadFileInfoExt(var x;size:integer;tpn:word;var pu:typeUO);pascal;
procedure proTacquisition_WriteFileInfoExt(var x;size:integer;tpn:word;var pu:typeUO);pascal;

procedure proTacquisition_ResetFileInfo(var pu:typeUO);pascal;
function fonctionTacquisition_EpInfoSize(var pu:typeUO):integer;pascal;
procedure proTacquisition_EpInfoSize(w:integer;var pu:typeUO);pascal;
function fonctionTacquisition_FileInfoSize(var pu:typeUO):integer;pascal;
procedure proTacquisition_FileInfoSize(w:integer;var pu:typeUO);pascal;

procedure proTacquisition_Start(var pu:typeUO);pascal;
procedure proTacquisition_StartAndSave(var pu:typeUO);pascal;
procedure proTacquisition_StartAndSave_1(append:boolean;var pu:typeUO);pascal;
procedure proTacquisition_Stop(var pu:typeUO);pascal;


procedure proTacquisition_GenericFileName(st:AnsiString;var pu:typeUO);pascal;
function fonctionTacquisition_GenericFileName(var pu:typeUO):AnsiString;pascal;

procedure proTacquisition_ActivateTrigger(var pu:typeUO);pascal;
function fonctionTacquisition_Special1(mask,delay:integer;var pu:typeUO):integer;pascal;

procedure proTacquisition_waitMode(b:boolean;var pu:PparamStim);pascal;
function fonctionTacquisition_waitMode(var pu:PparamStim):boolean;pascal;

function fonctionTacquisition_Saving(var pu:typeUO):boolean;pascal;
function fonctionTacquisition_Append(var pu:typeUO):boolean;pascal;
function fonctionTacquisition_Stopped(var pu:typeUO):boolean;pascal;


procedure proTacquisition_ProcessDelay(x:integer;var pu:typeUO);pascal;
function fonctionTacquisition_ProcessDelay(var pu:typeUO):integer;pascal;

procedure proTacquisition_InstallProcess(p00,p0,p1,p2:integer;var pu:typeUO);pascal;

function fonctionTacquisition_UseTagStart(var pu:typeUO):boolean;pascal;
procedure proTacquisition_UseTagStart(w:boolean;var pu:typeUO);pascal;

function fonctionTacquisition_isRunning(var pu:typeUO):boolean;pascal;

procedure proTacquisition_WriteDBfileInfo(var db:TDBrecord; var pu:typeUO);pascal;
procedure proTacquisition_WriteDBepInfo(var db:TDBrecord; var pu:typeUO);pascal;

function fonctionTacquisition_InsertObject(var uo:typeUO; var pu:typeUO):boolean;pascal;

procedure proTAcquisition_InsertTag(code:integer; st:AnsiString;var pu:typeUO);pascal;
procedure proTAcquisition_InsertTagAndObject(code:integer; st:AnsiString;var uo:typeUO; var pu:typeUO);pascal;

procedure proTAcquisition_ProgRestart(var pu:typeUO);pascal;

function fonctionTacquisition_TestPhotonTime(DT: float;var pu:typeUO):float;pascal;

function fonctionTacquisition_ReadDigitalInput(device, port:integer;var pu:typeUO): integer;pascal;
function fonctionTacquisition_WriteDigitalOutput(device, port, value:integer;var pu:typeUO): integer;pascal;

function fonctionTacquisition_Fdisplay(var pu:typeUO):boolean;pascal;
procedure proTacquisition_Fdisplay(w:boolean;var pu:typeUO);pascal;

function fonctionTacquisition_FimmediateDisplay(var pu:typeUO):boolean;pascal;
procedure proTacquisition_FimmediateDisplay(w:boolean;var pu:typeUO);pascal;

function fonctionTacquisition_Fprocess(var pu:typeUO):boolean;pascal;
procedure proTacquisition_Fprocess(w:boolean;var pu:typeUO);pascal;

function fonctionTacquisition_FholdDisplay(var pu:typeUO):boolean;pascal;
procedure proTacquisition_FholdDisplay(w:boolean;var pu:typeUO);pascal;

procedure proTacquisition_Refresh(var pu:typeUO);pascal;
function fonctionTacquisition_SamplesPerChannel(var pu:typeUO):integer;pascal;

function fonctionTacquisition_SetDigitalOutput(num:integer;value:boolean; var pu:typeUO): integer;pascal;

procedure proTacquisition_VspkBufferSize(w:integer;var pu:typeUO);pascal;
function  fonctionTacquisition_VspkBufferSize(var pu:typeUO): integer;pascal;

procedure proTacquisition_TestCentralSim(w:boolean;var pu:typeUO);pascal;
function  fonctionTacquisition_TestCentralSim(var pu:typeUO): boolean;pascal;


implementation

uses mdac;

var
  E_GIO:integer;
  E_testSize:integer;



constructor Tacquisition.create;
begin

  TRIGDate:=Tlist.create;

  getmem(MainTag,8+200*sizeof(TMtag));
  MainTag^.init(200);

  memoA:=TstmMemo.create;
  with memoA do
  begin
    init(nil);
    notPublished:=true;
    Fchild:=true;
    ident:='Acquisition.Comment';

  end;

  SaveList:=TthreadList.create;
end;

procedure Tacquisition.setAcqOn(w:boolean);
begin
  acqOn0:=w;
  acquisitionON:=w;
end;

destructor Tacquisition.destroy;
begin
  TrigDate.free;
  if assigned(MainTag) then freemem(MainTag,Maintag^.size);
  memoA.free;
  SaveList.free;
end;



procedure Tacquisition.initVarAcq(reprise:boolean);
var
  i:integer;
  ppcm0:integer;
begin
  FlagStop:=false;
  FlagStop2:=false;
  FlagStopPanic:=false;

  numseq:=0;

  if AcqInf.continu
    then nbpt:=maxEntierLong
    else nbpt:=acqInf.Qnbpt;

  nbpt1:=acqInf.nbvoieAcq*acqInf.Qnbpt;
  nbVacq:=acqInf.nbvoieAcq;


  DigEventCh0:=-1;
  with acqInf do
  begin
    setLength(QKSU,nbvoieAcq+1);
    acqAg:=nbVoieAcq;

    for i:=1 to Qnbvoie do
      if channelType[i]=TI_digiEvent then DigEventCh0:=i-1;

    if (DFformat=ElphyFormat1) then
    begin
      for i:=1 to Qnbvoie do
      begin
        QKSU[i]:=QKS[i];          {QKS commence à 1}
        if ChannelType[i] in [TI_anaEvent, TI_digiEvent] then QKSU[i]:=0;
      end;

      if nbVoieAcq>Qnbvoie then QKSU[nbVoieAcq]:=1;

      ppcm0:=1;
      for i:=1 to nbvoieAcq do
      if QKSU[i]>0 then
        ppcm0:=ppcm(ppcm0,QKSU[i]);

      acqAg:={acqAg* 260309} ppcm0;

    end;
  end;

  with acqInf do
  begin
    if continu then
      begin
        if maxDuration<=0
          then ADCMaxSample:=maxEntierLong
          {else ADCMaxSample:=roundL(maxDuration*1E6/periodeUS) div AcqAg*AcqAg-1;}
          else ADCMaxSample:=roundL(maxDuration*1E3/periodeParVoieMS) div AcqAg*AcqAg-1; {260309}

        maxDiffProcess:=nbAg0 div 2;
      end
    else
      begin
        if maxEpCount<=0
          then maxEp:=maxEntierLong
          else maxEp:=maxEpCount;
        if MaxEp<>maxEntierLong
          then ADCMaxSample:=maxEp*Qnbpt-1  {maxEp*Qnbpt*nbvoieAcq -1 } {260309}
          else ADCMaxSample:=maxEntierLong;

        maxDiffProcess:=Qnbpt{*nbvoieAcq}*(nbseq0-1);    {260309}
      end;
  end;


  MainBufIndex:=0;
  if not reprise then
  begin
    MainBufIndex0:=0;
    lastXend:=0;
  end;

  cntTraite:=-1;
  cntSave:=0;

  mainTag^.reset;

  Fdigi:=(board.dataFormat in [Fdigi1200,Fdigi1322]);


  if not FmultiMainBuf then EvtAcq1.init;

  nbvEv:=acqInf.nbvoieEvt + ord(acqInf.HasDigEvent);

  nbEvDisp:=0;
  lastEvt:=0;

  baseIndex:=0;

  index0Elphy:=0;

  ImaxEvt:=round(20000/AcqInf.periodeParVoieMS);
  LastSaveEvt:=0;

  NominalPeriod:=AcqInf.periodeParVoie;
  PeriodeMicro:=AcqInf.periodeParVoieMs*1000;
  PeriodeMS:=AcqInf.periodeParVoieMs;

  initAcqCom1;

  KeyBoardMode:=(AcqInf.modeSynchro=msClavier);
  if KeyBoardMode then KeyBoardEvent:=Tevent.create(nil,false,false,'');

  SpkScale.Dxu:= AcqInf.periodeParVoie;
  SpkScale.x0u:= 0;
  SpkScale.unitX:= AcqInf.unitX;

  WaveScale.Dxu:= AcqInf.periodeParVoieMS;
  WaveScale.x0u:= 0;
  WaveScale.unitX:= 'ms';

  WaveScale.Dyu:= AcqInf.DyuSpk;
  WaveScale.y0u:= AcqInf.Y0uSpk;
  WaveScale.unitY:= AcqInf.UnitYSpk;

  WaveScale.DxuSource:=AcqInf.periodeParVoie;
  if AcqInf.continu
    then WaveScale.UnitXSource:='sec'
    else WaveScale.UnitXSource:='ms';

  WaveScale.tpNum:=g_smallint;
end;

function Tacquisition.openFile:boolean;
var
  i,p:integer;
  ok:boolean;
  st:AnsiString;
  exStDat:AnsiString;
  espace:longint;
  stgen1:AnsiString;
  oldSt:AnsiString;
begin
  oldSt:=AcqInfF.stDat;
  result:=false;

  datafile0.FreeFileStream;

  screen.cursor:=crHourGlass;
  ok:=AcqInfF.verifierGen;
  screen.cursor:=crDefault;
  if not ok then
    begin
      messageCentral('Path not found');
      exit;
    end;

  stGen1:=AcqInfF.stGenAcq;
  p:=pos('$',stGen1);
  if p>0 then
    begin
      delete(stGen1,p,1);
      insert(datePclamp,stGen1,p);
      if stGen1[length(stGen1)] in ['0'..'9'] then stGen1:=stGen1+'-';
    end
  else
  begin
    p:=pos('#',stGen1);
    if p>0 then
      begin
        delete(stGen1,p,1);
        insert(dateClassic,stGen1,p);
        if stGen1[length(stGen1)] in ['0'..'9'] then stGen1:=stGen1+'-';
      end;
  end;
  st:=premierNomDisponible(stGen1+'.DAT');

  delete(st,length(st)-2,3);
  st:=st+'DAT';
  AcqInfF.stDat:=st;

  repeat
    AcqInfF.stDat:=GsaveFile('Choose a file name',AcqInfF.stDat,'DAT');
    if AcqInfF.stDat='' then
      begin
        AcqInfF.stDat:=oldSt;
        exit;
      end
    else ok:=ecraserFichier(AcqInfF.stDat);
  until ok;
  result:=ok;
end;


var
  tlancer:float;

procedure Tacquisition.buildAcqContext(reprise:boolean);
begin
  acqContext:=TacqContext.create;
  acqContext.PCLobj:=datafile0.FPCL;
  acqContext.Build(reprise,LastXend);
end;

procedure Tacquisition.PrepElphyFile(Fcont,Fmulti:boolean;nb:integer);
// janvier 2017: PreElphyFile est appelé avec Fmulti<>false uniquement en stim visuelle

var
  seqrec:TseqRecord;
  adc:TadcChannels;
  i:integer;
  FileFormat: integer;

begin
  with seqrec do
  begin
    nbvoie:=acqInf.nbvoieAcq;
    nbpt:=nb;
    tpData:=G_smallint;

    continu:=Fcont;
    if continu
      then uX:='sec'
      else uX:='ms';
    Dxu:=acqinf.Dxu;
    x0u:=0;

    nbSpk:=acqInf.nbVoieSpk;

    DxuSpk:=acqInf.DxuSpk;
    X0uSpk:=acqInf.X0uSpk;
    UnitXspk:=acqInf.unitXspk;

    DyuSpk:=acqInf.DyuSpk;
    Y0uSpk:=acqInf.Y0uSpk;
    UnitYspk:=acqInf.unitYspk;

    TagMode:=board.TagMode;
    TagShift:=board.tagShift;

    DxEvent:=Dxu;
  end;

  setLength(adc,seqrec.nbvoie);
  fillchar(adc[0],sizeof(adc[0])*seqrec.nbvoie,0);

  for i:=1 to AcqInf.Qnbvoie do
  begin
    QKSU[i]:=AcqInf.QKS[i];
    if (AcqInf.ChannelType[i] in [TI_anaEvent, TI_digiEvent]) then QKSU[i]:=0;
    if AcqInf.channelType[i]=TI_digiEvent then
    begin
      seqrec.DigEventCh:=i;
      seqrec.DigEventDxu:=1E-6;  { 1 microseconde }
    end;
  end;

  if Fmulti and not Fcont then FileFormat:=1 else FileFormat:=0;

  TElphyFile(facq).setSeqRecord(seqrec,FileFormat);

  if AcqInf.Qnbvoie<AcqInf.nbVoieAcq then QKSU[AcqInf.Qnbvoie+1]:=1;

  for i:=1 to acqInf.nbvoieAcq do
  begin
    facq.setKSampling(i,QKSU[i]);
    facq.setKtype(i,AcqInf.ChannelNumType[i]);
  end;

  case FileFormat of
    0:  for i:=1 to seqrec.nbvoie do
          TElphyFile(facq).setChannel0(i-1,acqinf.dyu(i), acqinf.y0u(i), acqinf.unitY[i]);
    1:  for i:=1 to seqrec.nbvoie do
          TElphyFile(facq).setChannel1(i-1, acqinf.dyu(i), acqinf.y0u(i), acqinf.unitY[i], QKSU[i]);
  end;

end;


procedure Tacquisition.StartAcq(Fsave,Freprise:boolean);
var
  i:integer;

procedure StopEveryThing;
begin
  FlagStop:=true;
  AcqContext.free;
  AcqContext:=nil;

  threadProcess.Free;
  threadProcess:=nil;

  if assigned(fAcq) then
    begin
      fAcq.erase;
      facq.free;
      facq:=nil;
    end;

  DataFile0.doneAcq(false,0,0);

  setState(s_stopped);
  
end;

begin
  FlagStop:=false;
  DebugTime:=0;
  DebugCnt:=0;

  errorExe:=0;
  FtrigActivate:=false;

  FlagSave:=false;
  FlagNotSave:=false;

  FFflagSave:=Fsave;

  setState(S_stopped);
  FnoSmartTestEscape:=true;

  SaveList.Clear;

  if not DriverAcqOK then
    begin
      messageCentral('ADC driver not installed');
      exit;
    end;

  acqInf.controle;


  AcqInf.FFdat:=Fsave;

  acqInf.WaitMode:=false;
  board.init0;

  if AcqInf.FFdat then                              {Créer l'objet Dac2File}
    begin
      if AcqInf.DFFormat=ElphyFormat1
        then fAcq:=TElphyFile.create
        else fAcq:=Tdac2File.create;

      with fAcq do
      begin
        if acqInf.Qnbvoie>0 then
        begin
          TagMode:=board.TagMode;
          tagShift:=board.tagShift;
        end
        else
        begin
          TagMode:=tmNone;
          tagShift:=0;
        end;
        setFileInfoSize(AcqInf.FileInfoSize);
        setEpInfoSize(AcqInf.EpInfoSize);
        comment:=memoA.stList.text;
        while length(comment)<AcqInf.miniCommentSize do comment:=comment+' ';
        setMTag(mainTag);
      end;
    end;

  {L'utilisateur peut maintenant modifier tout ce qu'il veut dans la partie
   InitProcess0. En particulier, on peut modifier les tailles des blocs
   d'info fichier et Episode.
   C'est là qu'il faut aussi écrire les info fichier.
   }

//  FrecSound:=AcqInf.recSound and AcqInf.continu and AcqInf.FFdat and (AcqInf.DFformat=ElphyFormat1);

  FrecSound:= false;

  Tpg2(dacPg).FinExeUpg2:=false;
  if AcqInf.Fprocess then
    begin
      FsavingData:=Fsave;
      FrepriseON:=Freprise;
      UserMinimalTimeInBuffer:=0; // Peut être modifié uniquement dans InitProcess0
      UserMaxMultiEvt:=0;

      Tpg2(dacPg).traitement00;

      {Si erreur ou si l'utilisateur a utilisé Shift+Esc ou si le pg a utilisé Acquisition.stop,
      on arrête tout}
      if (errorEXE<>0) or finExeU^ or flagStop then
        begin
          facq.free;
          facq:=nil;

          setState(S_Stopped);  // Si le pg contient "acquisition.stop" , l'état est S_waitEnd
          exit;
        end;
    end;

  if acqInf.WaitMode and acqInf.continu then acqInf.WaitMode:=false;

  if not Freprise then
  begin
    {saisir le nom du fichier}
    numseqInit:=0;
    if AcqInf.FFdat and not openFile then
    begin
      facq.free;
      facq:=nil;
      exit;
    end;
  end
  else
  begin
    acqinfF.stDat:=datafile0.stFichier;
    numseqInit:=datafile0.EpCount;
    {if AcqInf.continu then AdjustXminXmax;}
  end;



  {Creer les buffers principaux}
  adjustMainBuffers;

  {Mettre en place les variables d'acquisition}
  initvarAcq(Freprise);

  {Installer le stimulateur.}
  paramStim.install;
  {Creer le thread Process/stim sans le lancer. Cela a aussi pour effet de
   remplir mainDac}
  if AcqInf.Fprocess or AcqInf.Fstim or AcqInf.Qmoy then
    ThreadProcess:=TthreadProcess.create(updateDataFile0);

  {Signaler à dataFile0 qu'une acquisition est en cours. Les propriétés de dataFile0
  (nbVoie, nbpt, etc...) seront celles de l'acquisition}

  datafile0.periodeMicro:=PeriodeMicro;
  if AcqInf.FFdat
    then datafile0.initAcq(extractFileName(AcqinfF.stDat),numseqInit,numSeq,Freprise,true)
    else datafile0.initAcq('',0,numSeq,Freprise,true);


  {Ecrire l'entête du fichier de données}
  if AcqInf.FFdat then
    begin
      if AcqInf.DFformat=ElphyFormat1 then PrepElphyFile(acqInf.continu, false, acqInf.Qnbpt)
      else
      with fAcq do
      begin
        ignoreError:=true;
        ChannelCount:=AcqInf.Qnbvoie;
        continu:= (AcqInf.continu);
        for i:=1 to AcqInf.Qnbvoie do
          setChannel(i,dataFile0.channel(i),0,AcqInf.Xend);
      end;

      with fAcq do
      begin
        setAcqInf(@acqInf);
        if not AcqInf.continu and AcqInf.Fstim and not ParamStim.setByProgP
          then setStim(@paramStim);

        datafile0.FreeFileStream;

        try
          if AcqInf.DFformat=ElphyFormat1 then
          begin
            if Freprise
              then TelphyFile(facq).AppendAcqFile(AcqInfF.stDat)
              else TelphyFile(facq).createAcqFile(AcqInfF.stDat);
          end
          else createFile(AcqInfF.stDat);

        except
          messageCentral('Unable to open '+AcqInfF.stDat   );

          free;
          exit;
        end;
      end;
    end;



  {Executer la partie InitTraitement}
  if AcqInf.Fprocess then
    begin
      {appeler clear pour tous les objets de ObjectsToClear }
      with ObjectsToClear do
      for i:=0 to count-1 do
        with TypeUO(items[i]) do
        begin
          clear;
          invalidate;
        end;
      {invalider tous les objets de ObjectsToClear et
       mettre FimDisplay à true pour les vecteurs tableau
      }
      ImList.clear;
      with ObjectsToRefresh do
      for i:=0 to count-1 do
        if typeUO(items[i]) is TdataObj then
          with TdataObj(items[i]) do
          begin
            if flags.FmaxIndex or Fexpand then
              begin
                FimDisplay:=true;
                ImList.add(items[i]);
              end;
            invalidate;
          end;


      Tpg2(dacPg).traitement0;

      if (errorEXE<>0) or finExeU^ or flagStop then
      {Si erreur ou si l'utilisateur a utilisé Shift+Esc ou si le pg a utilisé Acquisition.stop,
       on arrête tout}
        begin
          if not FtrigActivate then
            begin
              StopEveryThing;
              exit;
            end
          else
            FlagStop:=true;
        end;

      datafile0.MessageCpl;
      updateAff;
    end;

  {Construire le contexte d'acquisition qui permet l'affichage pendant
  l'acquisition}
  buildAcqContext(Freprise);


  {Initialiser la carte d'acquisition }
  Board.init;
  if flagStopPanic then
  begin
    StopEveryThing;
    board.displayErrorMsg;
    exit;
  end;

  if AcqInf.Fstim then paramStim.setOutPutValues(cntStim);

  if not FtrigActivate then lancer;

  if FRecSound then
  begin
    waveIn:=TwaveIn.create(8000,InsertSound);
    waveIn.StartRecording;
  end;



  AcqOn:=true;
  setState(S_acq);

  AcqCommand.initAcq;
  if acqInf.FcontrolPanel then
    begin
      AcqCommand.show;
    end
  else AcqCommand.hide;
end;


procedure Tacquisition.lancerAcq;
begin
  board.lancer;
  FaskPause:=false;
end;

procedure Tacquisition.lancer;
begin
  {Lancer la carte d'acquisition}
  lancerAcq;

  {Lancer le thread d'interruption}
  threadInt:=TthreadInt.create(false);

  {Lancer le thread d'acquisition}
  threadAcq:=TthreadAcq.create(self);

  {Lancer le thread d'affichage}


  threadAff:=TthreadAff.create(acqContext,AcqInf.maxPts,
                               AcqInf.periodeParVoieMS,AcqInf.immediateDisplay,false );
  threadAff.numseq0:=numseqInit;

  {Lancer le thread Process/stimulation}
  if AcqInf.Fprocess or AcqInf.Fstim or AcqInf.Qmoy
    then ThreadProcess.resume;

  {Valider les raccourcis Mtags}
  sendmessage(formStm.handle,msg_shortcut,100,0);
end;



procedure Tacquisition.TraiterDataDac2(n2:integer);
var
  i,j,k:integer;
  bufS:array[0..9999] of smallint;
  w:smallint;
  Sstart,Send:integer;
  nbpt0:integer;
begin
  Sstart:=(cntTraite+1)*nbVacq;
  Send:=(n2+1)*nbVacq-1;             {n2 est un nb de points par voie 260309}
  nbpt0:=nbAg0*nbVacq;

  try
  if AcqInf.FFdat then
    begin
      j:=0;
      for i:=Sstart to Send do
        begin
          if (i mod nbpt1=0) and not acqInf.continu then
            begin
              if FlagSave then
                begin
                  FFflagSave:=true;
                  FlagSave:=false;
                end;
              if FlagNotSave then
                begin
                  FFflagSave:=false;
                  FlagNotSave:=false;
                end;

              if j<>0 then fAcq.f.Write(bufS,j*sizeof(smallint));
              j:=0;
              if FFflagSave then
                begin
                  fAcq.EcrirePreseq;
                end;
            end;

          if FFflagSave then
            begin
              bufS[j]:=mainBuf^[i mod nbpt0];
              inc(j);
            end;

          if FFflagSave then inc(cntsave);

          if FFflagSave and (i mod nbpt1=nbpt1-1) and not acqInf.continu then
            begin
              if j<>0 then fAcq.f.Write(bufS,j*sizeof(smallint));

              j:=0;
              fAcq.ecrirePostSeq;
            end;

          if j=10000 then
            begin
              fAcq.f.write(bufS,sizeof(bufS));
              j:=0;

            end;

        end;

      if j<>0 then fAcq.f.Write(bufS,j*sizeof(smallint));

    end;

  cntTraite:=n2;

 except
    sendStmMessage('Write error ');
    FlagStop:=true;
    setState(S_stopped);
 end;
end;


procedure Tacquisition.InsertUtag(cc,index,ep1:integer;tm:TdateTime;st:AnsiString);
var
  mm:TmemoryStream;
begin
  if acqON and acqInf.FFdat and (acqInf.DFformat=ElphyFormat1) then
  begin
    mm:= TelphyFile(facq).createUtagStream(cc,index,ep1,tm,st);
    saveList.Add(mm);
  end;
  acqContext.afficherMtag(index*acqInf.periodeParVoie,MtagColors[cc and 15]);
end;


procedure Tacquisition.InsertSound(var buf; nb: integer);
begin
{
  FlagSound:=true;
  bufSound:=@buf;
  nbSound:=nb;

  }
end;

procedure Tacquisition.SaveObjectsToElphyFile(const Fclose:boolean=true);
var
  tb:PtabPointer;
  i,Nb:integer;
  flag:boolean;
  mm:TmemoryStream;
begin
  { On copie d'abord les pointeurs afin de bloquer le système pendant un temps minimum}
  try
    with SaveList.LockList do
    begin
      Nb:=count;
      getmem(tb,Nb*sizeof(pointer));
      if nb>0 then system.Move(list[0],tb^,count*sizeof(pointer));
      clear;
    end;
  finally
    SaveList.UnlockList;
  end;

  if Nb>0 then
  begin
    if Fclose then flag:=TelphyFile(facq).closeDataBlock;
    for i:=0 to Nb-1 do
    begin
      mm:=tb[i];
      mm.position:= 0;
      fAcq.f.CopyFrom(mm,mm.Size);
      mm.Free;
    end;
    if Fclose and flag then TelphyFile(facq).OpenDataBlock;
  end;

end;


procedure Tacquisition.TraiterDataElphySingleBuf(n2:integer);
Const
  BufSSize=20000;
var
  i,j,k,n:integer;
  Buffer:array[0..BufSSize+1000] of byte;  { 1000 doit être supérieur à la taille d'un agrégat}
  bufS,P:Pointer;
  w:smallint;
  iseq:integer;

  mm:TmemoryStream;
begin
  {n2 est un nb de points par voie 260309}

  affDebug('n2='+Istr(n2)+'  cnTraite='+Istr(cntTraite),101);

  try
  if AcqInf.FFdat then
    begin
      bufS:=@Buffer;

      for i:=cntTraite+1 to n2 do
      begin
        { Episodes: en début d'épisode, on écrit preseq }
        if (i mod nbpt=0) and not acqInf.continu then
        begin
          // SavePCL(i mod nbpt, 2); marche peut-être ?

          if FlagSave then
            begin
              FFflagSave:=true;
              FlagSave:=false;
            end;
          if FlagNotSave then
            begin
              FFflagSave:=false;
              FlagNotSave:=false;
            end;

          if bufS<>@Buffer then fAcq.f.write(buffer,intG(bufS)-intG(@Buffer));
          bufS:=@Buffer;
          if FFflagSave then
            begin
              fAcq.EcrirePreseq;
            end;
        end;


        iseq:= i mod nbpt;         // indice dans la séquence
        if FFflagSave then
        for k:=0 to nbvAcq-1 do
        { On fait passer le point de mainBuf à BufS si nécessaire }
          begin
            if (QKSU[k+1]=0) then TraiterEvt(i,k)
            else
            if (QKSU[k+1]<>0) and (iseq mod QKSU[k+1]=0)  then
              begin
                intG(P):=intG(mainBuf)+(i mod nbAg0)*AgTotSize+AgOffsets[k];
                move(P^,bufS^,AgSampleSizes[k]);

                inc( intG(BufS),AgSampleSizes[k]);
              end;
          end;

        if FFflagSave then inc(cntsave);

        if assigned(PCLbuf) and (PCLbuf.NbAvailable> MaxPhoton div 2) then savePCL(i mod nbpt,0);

        { En fin d'épisode, on ecrit PostSeq }
        if FFflagSave and (i mod nbpt=nbpt-1) and not acqInf.continu then
          begin
            if bufS<>@Buffer then fAcq.f.write(buffer,intG(BufS)-intG(@Buffer));

            BufS:=@Buffer;
            fAcq.ecrirePostSeq;

            SaveEvt(i mod nbpt);
            SavePCL(i mod nbpt, 1);
            index0Elphy:=i;
          end;


        if intG(BufS)-intG(@Buffer)>=BufSSize then
          begin
            fAcq.f.write(buffer,intG(BufS)-intG(@Buffer));
            BufS:=@Buffer;
          end;
      end;

      if BufS<>@Buffer then
        begin
          fAcq.f.write(buffer,intG(BufS)-intG(@Buffer));
          affDebug('Write data '+Istr(n2)
                    +' sz='+Istr(facq.f.size),1);
        end;

      {
      if FlagSound then
      begin
        FlagSound:=false;
        TelphyFile(facq).InsertSound(bufSound^,nbSound,false,Now);
      end;
      }
      SaveObjectsToElphyFile;
    end
  else
    for i:=cntTraite+1 to n2 do
    begin
      for k:=0 to nbvAcq-1 do
        if (QKSU[k+1]=0) then TraiterEvt(i,k);

      if not acqInf.continu and (i mod nbpt=nbpt-1) then
        begin
          for k:=1 to AcqInf.Qnbvoie do
          if AcqInf.ChannelType[k] in [TI_anaEvent, TI_digiEvent]
            then EvtBuf[k].getSpikeCount((i mod nbpt)*periodeMS);
            { Fait avancer IndexT }
          index0Elphy:=i;

          if assigned(PCLbuf) then PCLbuf.GetRecCount((i mod nbpt)*periodeMicro);
        end;
    end;

  cntTraite:=n2;
  debugTime:=debugTime+getTimer2;
  debugCnt:=debugCnt+1;

  except
    sendStmMessage('Write error');
    FlagStop:=true;
    setState(S_stopped);
  end;
end;

procedure Tacquisition.TraiterDataElphyMultiBuf(n2:integer);  { 260309 : n2 est un nombre de points nominal par voie }
Const
  BufSSize=10000;
var
  i,j,k,n:integer;
  Buffer:array[0..BufSSize+10] of smallint;
  bufS,P:Psmallint;
  w:smallint;
  mm:TmemoryStream;
begin
  if cntTraite>=n2 then exit;  {Danger si n décroit ! }

  try
  if AcqInf.FFdat then
    begin
      bufS:=@Buffer;
      for i:=cntTraite+1 to n2 do
      begin
        { Episodes: en début d'épisode, on écrit preseq }
        if (i mod nbpt=0) and not acqInf.continu then
          begin
            if FlagSave then
              begin
                FFflagSave:=true;
                FlagSave:=false;
              end;
            if FlagNotSave then
              begin
                FFflagSave:=false;
                FlagNotSave:=false;
              end;

            if bufS<>@Buffer then fAcq.f.write(buffer,intG(bufS)-intG(@Buffer));
            bufS:=@Buffer;
            if FFflagSave then
              begin
                fAcq.EcrirePreseq;
              end;
          end;

        { On fait passer le point de MultiMainBuf à BufS si nécessaire }
        if FFflagSave then
          begin
            for k:=0 to nbVacq-1 do
            if (QKSU[k+1]<>0) and (i  mod QKSU[k+1]=0)  then
              begin
                with MultimainBuf[k] do
                bufS^:=GetSmall(i div QKSU[k+1]);
                inc( intG(BufS),2);
              end;
          end;

        if FFflagSave then inc(cntsave);

        { En fin d'épisode, on ecrit PostSeq }
        if FFflagSave and (i mod nbpt=nbpt-1) and not acqInf.continu then
          begin
            if bufS<>@Buffer then fAcq.f.write(buffer,intG(BufS)-intG(@Buffer));

            BufS:=@Buffer;
            fAcq.ecrirePostSeq;

            SaveEvtMulti(i mod nbpt);

            index0Elphy:=i;
          end;



        if intG(BufS)-intG(@Buffer)>=BufSSize then
          begin
            fAcq.f.write(buffer,intG(BufS)-intG(@Buffer));
            BufS:=@Buffer;
            affDebug('Write data 10000',1);
          end;
      end;

      if BufS<>@Buffer then
        begin
          fAcq.f.write(buffer,intG(BufS)-intG(@Buffer));
          affDebug('Write data '+Istr(n2)
                    +' sz='+Istr(facq.f.size),1);
        end;
      {flushFileBuffers(TfileRec(fAcq.f).handle);}
       {à faire entre deux seq ? ou sur option}

      {
      if FlagSound then
      begin
        FlagSound:=false;
        TelphyFile(facq).InsertSound(bufSound^,nbSound,false,Now);
      end;
      }
      saveEvtContMulti(n2,false,false);

      SaveObjectsToElphyFile;
    end
  else
    for i:=cntTraite+1 to n2 do
    begin
      if not acqInf.continu and (i mod nbpt=nbpt-1) then
        begin
          for j:=0 to AcqInf.nbvoieSpk-1 do
            MultiEvtBuf[j].getSpikeCount((i mod nbpt)*periodeMS);

          index0Elphy:=i;
        end;
    end;

  cntTraite:=n2;
  debugTime:=debugTime+getTimer2;
  debugCnt:=debugCnt+1;

  except
    sendStmMessage('Write error');
    FlagStop:=true;
    setState(S_stopped);
  end;
end;


procedure Tacquisition.TraiterDataElphy(n2:integer);
begin
  if FmultiMainBuf
    then TraiterDataElphyMultiBuf(n2)
    else TraiterDataElphySingleBuf(n2);

end;

procedure Tacquisition.SaveEvt(Imax:integer);
var
  flag:boolean;
  size,nbV:integer;
  nb:array of integer;
  i:integer;
  n1,n2:integer;
  nbspike,cnt:integer;
begin
  // if not AcqInf.FFdat then exit;
  
  size:=0;
  nbSpike:=0;
  nbV:=0;

  setLength(nb,AcqInf.Qnbvoie+1);

  for i:=1 to AcqInf.Qnbvoie do
  if AcqInf.channelType[i] in [TI_anaEvent,TI_digiEvent] then
  begin
    inc(nbV);
    nb[nbV]:=EvtBuf[i].getSpikeCount(Imax*periodeMS);//
    nbSpike:=nbSpike+nb[nbV];
  end;


  FlagFullEvt:=false;

  size:=(nbspike+nbV+1)*sizeof(integer);

  if (nbSpike>0) then
  with TelphyFile(facq) do
  begin
    flag:=closeDataBlock;
    WriteReventHeader(f,size,now,false);

    f.Write(nbV,sizeof(nbV));
    f.Write(Nb[1],nbV*4);

    for i:=1 to AcqInf.Qnbvoie do
    if AcqInf.channelType[i] in [TI_anaEvent,TI_digiEvent] then
      EvtBuf[i].saveLastData(f);

    if flag then openDataBlock;
  end;

  LastSaveEvt:=Imax;
end;

procedure Tacquisition.SavePCL(Imax:integer; mode:integer);
var
  flag:boolean;
  size,nb:integer;
begin
  Affdebug('savePCL  000 ',82);
  if not AcqInf.FFdat OR not assigned(PCLbuf) then exit;

  case mode of
    0: nb:=PclBuf.getRecCount(Imax*periodeMicro);
    1: nb:=PclBuf.getRecCountPCL(Imax*periodeMicro);
    2: nb:=PclBuf.getRecCountExtra(Imax*periodeMicro);
  end;
  
  size:= nb*sizeof(TPCLrecord)+sizeof(nb);

  if (nb>0) then
  with TelphyFile(facq) do
  begin
    flag:=closeDataBlock;
    WriteRPCLHeader(f,size,now,false);

    f.Write(nb,sizeof(nb));
    PCLBuf.saveLastData(f);

    if flag then openDataBlock;
  end;

  Affdebug('savePCL  '+Istr(nb),82);
end;



procedure Tacquisition.SaveEvtMulti(Imax:integer);
var
  flag:boolean;
  nbSpike,size,nbV:integer;
  wavelen,pretrig:integer;
  nb:array of integer;
  i:integer;

begin
  //if not AcqInf.FFdat then exit;

  nbSpike:=0;
  size:=0;
  nbV:=0;

  setLength(nb,AcqInf.nbvoieSpk+1);

  for i:=0 to AcqInf.nbvoieSpk-1 do
  begin
    inc(nbV);
    nb[nbV]:=MultiEvtBuf[i].getSpikeCount(Imax*periodeMS);
    nbSpike:=nbSpike+nb[nbV];
  end;

  if nbSpike>0 then
  begin
    size:=(nbV+1)*sizeof(integer)  + nbSpike*5 ;  { 5 octets pour chaque spike }

    with TelphyFile(facq) do
    begin
      WriteRspkHeader(f,size,now,false,SpkScale);

      f.Write(nbV,sizeof(nbV));
      f.Write(Nb[1],nbV*4);

      for i:=0 to AcqInf.nbvoieSpk-1 do
        MultiEvtBuf[i].saveLastData(f);
    end;

    { Sauver les waveforms  }

    wavelen:=AcqInf.CyberWaveLen;
    pretrig:=AcqInf.PretrigWave;
    size:= (nbV+3)*sizeof(integer)  + nbSpike*( wavelen*2 +ElphySpkPacketFixedSize) ;

    with TelphyFile(facq) do
    begin

      WriteRspkWaveHeader(f,size,now,false,WaveScale);

      f.Write(wavelen,sizeof(wavelen));
      f.Write(pretrig,sizeof(pretrig));

      f.Write(nbV,sizeof(nbV));
      f.Write(Nb[1],nbV*4);

      for i:=0 to AcqInf.nbvoieSpk-1 do
        MultiEvtBuf[i].saveLastWaves(f);

    end;
  end;

  if assigned(MultiCyberTagBuf) then
    with TelphyFile(facq) do
    MultiCyberTagBuf.SaveLastTags(f,Imax);

end;





procedure Tacquisition.SaveEvtContMulti(Imax:integer; AllEvts, AllTags:boolean);
var
  flag:boolean;
  nbspike,size,nbV:integer;
  nb:array of integer;
  i:integer;
  wavelen,pretrig:integer;
  FlagEvt,FlagCyb:boolean;
begin
  if not AcqInf.FFdat then exit;

  size:=0;
  nbSpike:=0;
  nbV:=0;

  FlagEvt:= AllEvts or FlagFullMulti;
  FlagCyb:= assigned(MultiCyberTagBuf) and (AllTags or MultiCyberTagBuf.BufTagFull);

  if not FlagCyb and not FlagEvt then exit;

  setLength(nb,AcqInf.nbvoieSpk+1);

  for i:=0 to AcqInf.nbvoieSpk-1 do
  begin
    inc(nbV);
    nb[nbV]:=MultiEvtBuf[i].getSpikeCount(Imax*periodeMS); // modifie les indexT
    nbSpike:=nbSpike+nb[nbV];
  end;
  FlagFullMulti:=false;

  size:=(nbV+1)*sizeof(integer)  + nbSpike*5; { 5octets pour chaque spike }

  with TelphyFile(facq) do
  begin
    flag:=closeDataBlock;

    if (nbSpike>0) then
    begin
      WriteRspkHeader(f,size,now,false,SpkScale);

      f.Write(nbV,sizeof(nbV));
      f.Write(Nb[1],nbV*4);

      for i:=0 to AcqInf.nbvoieSpk-1 do
        MultiEvtBuf[i].saveLastData(f);

    { Sauver les waveforms  }

      wavelen:=AcqInf.CyberWaveLen;
      pretrig:=AcqInf.PretrigWave;
      size:= (nbV+3)*sizeof(integer)  + nbSpike*( wavelen*2 +ElphySpkPacketFixedSize);

      WriteRspkWaveHeader(f,size,now,false,WaveScale);

      f.Write(wavelen,sizeof(wavelen));
      f.Write(pretrig,sizeof(pretrig));

      f.Write(nbV,sizeof(nbV));
      f.Write(Nb[1],nbV*4);

      for i:=0 to AcqInf.nbvoieSpk-1 do
        MultiEvtBuf[i].saveLastWaves(f);

      
    end;

    if FlagCyb then MultiCyberTagBuf.SaveLastTags(f,Imax,AllTags);

    if flag then openDataBlock;
  end;
end;

procedure Tacquisition.TraiterEvt(i,v:integer);
var
  x,xR:smallint;
  nbpt0:integer;
  i1:integer;
begin
  if nbVeV=0 then exit;
  if v=DigEventCh0 then
  begin
    if FlagFullEvt and AcqInf.FFdat then saveEvt(i mod nbpt);
    exit;
  end;

  if (i mod nbpt=0) then evtBuf[v+1].storeLong(-1);

  nbpt0:=nbAg0*nbvoie;

  i1:=i*nbvAcq+v;

  x:=mainBuf^[i1 mod nbpt0];
  if Fdigi then
  {$IFNDEF WIN64}
    asm
      mov  ax,x
      mov  cx,shiftDigi
      sar  ax,cl
      mov  xR,ax
    end
  {$ELSE}
     xR:=sar(x,ShiftDigi)
  {$ENDIF}
  else xR:=x;

  xR:=getEvent(xR,v);

  if xR<>0 then
  begin
    if AcqInf.continu then
      begin
        evtBuf[v+1].storeLong(i +mainBufIndex0 div nbvAcq) ;
        if FlagFullEvt and AcqInf.FFdat  then saveEvt(i);
      end
    else
      begin
        evtBuf[v+1].storeLong(i mod nbpt);
      end
  end;

  if AcqInf.continu and (i-LastSaveEvt>ImaxEvt) and AcqInf.FFdat then saveEvt(i);
end;

procedure Tacquisition.TraiterData(n2:integer);     {260309 n2 est un nombre point par voie}
begin
  if AcqInf.DFformat=Dac2Format
    then TraiterDataDac2(n2)
    else TraiterDataElphy(n2);

end;


procedure Tacquisition.EndAcq(ThreadToTerminate:integer);
var
  nb,nbS,numH:integer;
  i:integer;
begin
  if (threadAcq=nil) and (threadAff=nil) and (threadProcess=nil)
    then exit;

  case ThreadToTerminate of
    1:begin
        threadAcq.free;
        threadAcq:=nil;


      end;
    2:begin
        threadAff.free;
        threadAff:=nil;
      end;
    3:begin
        threadProcess.free;
        threadProcess:=nil;
      end;
  end;


  if (threadAcq=nil) and (threadAff=nil) and (threadProcess=nil) then
    begin
      if AcqInf.FFdat then
        begin
          fAcq.updateMtag;
          fAcq.updateComment(memoA.stList.text);

          if AcqInf.DFformat=ElphyFormat1 then
            begin
              if AcqInf.continu then
              begin
                if FmultiMainBuf
                  then SaveEvtContMulti(MainBufIndex,true,true )
                  else saveEvt(MainBufIndex mod nbpt);
                savePCL(MainBufIndex,0);
              end
              else
              begin
                if FmultiMainBuf
                  then {saveEvtMulti(MainBufIndex mod nbpt )}
                  else saveEvt(maxentierLong);
              end;
              if FRecSound then
              begin
                waveIn.free;
                waveIn:=nil;
              end;

            end;
          fAcq.close(MainBufIndex);
          facq.free;
        end;

      board.terminer;
      threadInt.free;
      threadInt:=nil;

      AcqContext.updateVectors;

      AcqContext.free;
      AcqContext:=nil;

      with acqInf do
      if continu
        then DataFile0.doneAcq(FFdat,NumSeqInit,ADCMaxSample)
        else DataFile0.doneAcq(FFdat,NumSeqInit,numSeq0);


      paramStim.reset;

      AcqOn:=false;


      if AcqInf.Fprocess and (errorExe=0) then Tpg2(dacPg).traitement2;

      { Remettre le flag FimDisplay à false pour tous les objets }
      with ObjectsToRefresh do
      for i:=0 to count-1 do
        if typeUO(items[i]) is TdataObj then TdataObj(items[i]).FimDisplay:=false;

      Tpg2(DacPg).ActiveProgram;

      postMessage(formStm.handle,msg_EndAcq2,0,0);

      {Invalider les raccourcis Mtags}
      sendmessage(formStm.handle,msg_shortcut,101,0);


      inc(mainBufIndex0,MainBufIndex+1);
      lastXend:= mainBufIndex0 * acqInf.periodeParVoie ;

      if acqInf.continu and (paramStim.ActiveChannels>0)
        then baseIndex:=roundL(mainBufIndex0*acqInf.periodeUS/(paramstim.periodeParDac*1000*paramStim.ActiveChannels))
        else baseIndex:=paramStim.nbpt1*numSeq0;

      {messageCentral('mainBufIndex0='+Istr(mainBufIndex0));}
      {if DebugCnt>0 then
        messageCentral('N='+Istr(debugCnt)+' TT='+Estr(debugTime/DebugCnt,3));}

       FnoSmartTestEscape:=false; 
    end;

  {SaveArrayAsDac2File(debugPath+'mainBuf.dat',mainBuf^,nbpt0,g_smallint);}
end;

procedure Tacquisition.updateDataFile0(num:integer);
begin
  TdataFile(dacDataFile).initDataAcq(numseqInit,num);
end;

procedure Tacquisition.setMtag(cc:integer);
var
  dd:integer;
begin
  if assigned(MainTag) and (acqInf.DFformat<>ElphyFormat1) then
    begin
      dd:=board.getSampleIndex;     { 26-03-09 : getSampleIndex retourne un nombre de points par voie }
      with MainTag^do
      if nb<nbMax then
      begin
        add(dd*nbVacq,cc);
        acqContext.afficherMtag(dd*NominalPeriod,MtagColors[cc and 15]);
      end;

    end;
end;





procedure Tacquisition.StartAcqVS(FdispDat, Fsave, FinitBoard:boolean);
begin
  if not DriverAcqOK then
    begin
      messageCentral('ADC driver not installed');
      exit;
    end;


  acqInf.WaitMode:=true;

  paramStim.bufferCountU:=1;

  {Creer les buffers principaux}
  adjustMainBuffers;

  {Mettre en place les variables d'acquisition}
  initvarAcq(false);

  {Installer le stimulateur.}
  paramStim.install;
  {Creer le thread Process/stim sans le lancer. Cela a aussi pour effet de
   remplir mainDac}
  if AcqInf.Fprocess or AcqInf.Fstim or AcqInf.Qmoy then
    ThreadProcess:=TthreadProcess.create(updateDataFile0);


  {Signaler à dataFile0 qu'une acquisition est en cours. Les propriétés de dataFile0
  (nbVoie, nbpt, etc...) seront celles de l'acquisition}

  datafile0.periodeMicro:=PeriodeMicro;
  if Fsave
    then datafile0.initAcq(extractFileName(AcqinfF.stDat),0,1,false,false)
    else datafile0.initAcq('',0,1,false,false);


  {Initialiser la carte d'acquisition ainsi que les buffers DMA}
  // Finitboard n'est utilisé que par cyberK

  if not(board is TcyberKinterface) then Finitboard:= true;

  if FinitBoard then Board.init;
  
  if flagStopPanic then
  begin
    board.displayErrorMsg;
    exit;
  end;

  AcqOn:=true;

  if FdispDat then
    begin
      BuildAcqContext(false);
      threadAff:=TthreadAff.create(acqContext,AcqInf.maxPts,
                                   AcqInf.periodeUS,AcqInf.immediateDisplay,true );
      AcqContext.init(true);
      updateAff;

    end;

  lancerAcq;

  {Créer le thread d'interruption (suspendu)}
  threadInt:=TthreadInt.create(true);

  if FdispDat then AcqContext.resetWindows;
end;

procedure Tacquisition.endAcqVS;
begin
  board.terminer;

  threadInt.free;
  threadInt:=nil;

  threadProcess.free;
  threadProcess:=nil;

  threadAff.free;
  threadAff:=nil;

  AcqContext.free;
  AcqContext:=nil;

  AcqOn:=false;


end;


procedure Tacquisition.setSave;
begin
  if acqInf.continu
    then FFflagSave:=true
    else flagSave:=true;
end;

procedure Tacquisition.setNotSave;
begin
  if acqInf.continu
    then FFflagSave:=false
    else flagNotSave:=true;
end;


procedure Tacquisition.setState(w:TAFDstate);
begin
  case w of
    S_stopped:
        begin
          mainDac.start1.caption:='Start (display only)';
          mainDac.start1.enabled:=true;
          mainDac.Startandsave1.visible:=true;
          mainDac.continue1.enabled:=TRUE;
        end;
    S_acq:
        begin
          mainDac.start1.caption:='Stop';
          mainDac.start1.enabled:=true;
          mainDac.Startandsave1.visible:=false;
          mainDac.continue1.enabled:=false;
        end;
     S_waitEnd:
        begin
          mainDac.start1.caption:='Stop';
          mainDac.start1.enabled:=false;
          mainDac.Startandsave1.visible:=false;
          mainDac.continue1.enabled:=false;
        end;
  end;
end;

procedure Tacquisition.InstallProcess(p00,p0,p1,p2:integer);
begin
  if AcqOn then exit;

  Tpg2(dacPg).installProcT(p00,p0,p1,p2);
  acqInf.Fprocess:=(p00>0) or (p0>0) or (p1>0) or (p2>0);
end;


procedure Tacquisition.DisplayBoardErrorMsg;
begin
  board.DisplayErrorMsg;
end;

function Tacquisition.writeObject(uo:typeUO):boolean;
var
  ff:TmemoryStream;
begin
  result:=false;
  if {not AcqInf.FFdat or} not assigned(facq) then exit;  // FFdat vaut toujours false en VS

  ff:=TmemoryStream.create;
  uo.saveToStream(ff,true);

  saveList.Add(ff); // on range le bloc dans une liste sous la forme d'un TmemoryStream
  result:=true;
end;

{*********************** Méthodes de TthreadAcq ***********************}

constructor TthreadAcq.create(acquisition:Tacquisition);
begin
  inherited create(false);
  acq:=acquisition;
end;

destructor TthreadAcq.destroy;
begin
  inherited;
end;

procedure TthreadAcq.execute;
var
  index,numH,nbS:integer;
  i,j:integer;
  fini:boolean;
  FadcMax:boolean;

begin

  fini:=false;
  FadcMax:=false;
  with acq do
  begin
    repeat
      index:=board.getSampleIndex;        { 26-03-09 : getSampleIndex retourne l'indice du dernier point disponible sur une voie }
      //affdebug('GetSampleIndex = '+Istr(index),79);
      with AcqInf do
      begin
        if continu then
          begin
            if FlagStop and not FadcMax then
            begin
              ADCMaxSample:=(index div AcqAg+1)*AcqAg-1;
              FadcMax:=true;
            end;

            if index>=ADCMaxSample then
              begin
                index:=ADCMaxSample;
                fini:=true;
                setState(S_waitEnd);

                if FRecSound
                  then waveIn.StopRecording;
              end;
            TraiterData(index);
          end
        else
          begin
            numseq:=(cntTraite+1) div nbpt {nbpt1}+1; {260309}

            if FlagStop and not FadcMax then
              begin
                if index<=(numseq-1)* nbpt {nbpt1} {260309}
                   then NumSeq0:=numseq-1
                   else NumSeq0:=numSeq;

                ADCMaxSample:=numSeq0*nbpt {nbpt1}-1; {260309}
                FadcMax:=true;
              end;
            if index>=ADCMaxSample then
              begin
                TraiterData(ADCMaxSample);
                fini:=true;
                index:=ADCMaxSample;
                if not FlagStop then setState(S_WaitEnd);
              end
            else
              begin
                TraiterData(index);
              end;
          end;
      end;

      MainBufIndex:=index;
      {ThreadProcess se base sur MainBufIndex, il ne peut donc pas prendre d'avance
      sur la sauvegarde. Si une manip range des infos séquence, on ne risque pas
      de ranger ces infos dans la séquence précédente. Par contre, si le traitement
      prend trop de retard, on pourrait les ranger dans la séquence suivante.
      Dans une manip synchronisée sur le stimulateur visuel, ceci est impossible
      puisqu'on attend la fin du traitement pour envoyer le prochain top synchro.

      ThreadAff se base aussi sur MainBufIndex.
      }
      MainSaveIndex:=cntSave;

      if FlagStopPanic then fini:=true;

      if fini then
        begin
          FlagStop2:=true;
          numSeq0:=(ADCMaxSample+1) div nbpt {nbpt1}; {260309}
        end
      else
      if board.isWaiting then
      begin
        if KeyBoardMode then
        begin
          if not KeyBoardWaiting then
          begin
            postMessage(formstm.Handle,msg_KeyBoardAcq,0,0);
            KeyBoardWaiting:=true;
          end
          else
          if keyBoardStart then
          begin
            board.relancer;
            keyBoardStart:=false;
            RestartEnabled:=false;
          end;
        end
        else
        if (not acqinf.waitMode OR (RestartEnabled and acqInf.waitMode ))      {RestartEnabled est positionné à la fin du PG2 }
            AND
           (not restartOnTimer OR (getTickCount-acqTime0>=paramStim.Isi*1000) ) then
        begin
          board.relancer;
          RestartEnabled:=false;
        end;
      end
      else keyBoardWaiting:=false;


      if assigned(ThreadProcess) then
        begin
          if fini then ThreadProcess.maxCount:=ADCMaxSample;

          if (mainBufIndex-ThreadProcess.count>maxDiffProcess) and (errorExe=0) then
            begin
              Tpg2(DacPg).stopProgram;
              FlagStop:=true;
              setState(S_waitEnd);
              sendStmMessage('Process doesn''t follow acquisition '
                             +Istr(mainBufIndex)+' '+Istr(ThreadProcess.count)+' '+Istr(maxDiffProcess)
              );
            end;

          if ProcessDelay>0
            then ThreadDelay.go(ProcessDelay)
            else eventProcess.setEvent;
        end;

      //affdebug('EventAff.setEvent  ',79);
      EventAff.setEvent;

      if not fini
        then eventInt.waitFor(10000)
        else terminate;

    until terminated;

    if assigned(EventProcess) then EventProcess.setEvent;
    EventAff.setEvent;

    postMessage(formStm.handle,msg_EndAcq1,1,0);

  end;
end;

procedure displayInfoAcq;
begin
 {
  messageCentral('Interrupt time=    '+Estr(getIntTime,3)+#10+
                 'Max interrupt time='+Estr(getMaxIntTime,3)+#10+
                 'dma1 buffer size=  '+Istr(board.getNbptDma1(1))+#10+
                 'dma2 buffer size=  '+Istr(board.getNbptDma2)+#10+
                 'ADC buffer size=  '+Istr(nbpt0)+#10+
                 'DAC buffer size=  '+Istr(nbptDAC)+#10+

                 'tlancer=           '+Estr(tlancer,3)
                 );
                 }
end;




{******************** Méthodes Stm de Tacquisition **************************}

var

  E_LogChannelNum:integer;
  E_PhysChannelNum:integer;

  E_gainMax:integer;
  E_ISI:integer;

  E_dy:integer;
  E_scale:integer;

  E_genericFileName:integer;

  E_setEpInfo:integer;
  E_getEpInfo:integer;
  E_readEpInfo:integer;
  E_writeEpInfo:integer;
  E_epInfoSize:integer;


  E_setFileInfo:integer;
  E_getFileInfo:integer;
  E_readFileInfo:integer;
  E_writeFileInfo:integer;
  E_FileInfoSize:integer;



function fonctionTacquisition_Channels(n:integer;var pu:typeUO):pointer;
begin
  with TacqInfo(pu) do
  begin
    if (n<1) or (n>length(channels))
      then sortieErreur('Tacquisition.Channels : index out of range');
    result:=@channels[n-1];
  end;
end;

procedure proTacqChannel_device(w:integer;var pu:TchannelInfo);
begin
  if (w<0) or (w>=board.deviceCount)
    then sortieErreur('TacqChannel: invalid device number');
  pu.Qdevice:=w;
end;

function fonctionTacqChannel_device(var pu:TchannelInfo):integer;
begin
  result:=pu.Qdevice;
end;

procedure proTacqChannel_PhysNum(w:integer;var pu:TchannelInfo);
var
  max:integer;
begin
  with pu do
  begin
    if (w<0) {or (w>=max)}
      then sortieErreur('TacqChannel: invalid physical channel number');

    QvoieAcq:=w;
  end;
end;

function fonctionTacqChannel_PhysNum(var pu:TchannelInfo):integer;
begin
  result:=pu.QvoieAcq;
end;

procedure proTacqChannel_ChannelType(w:integer;var pu:TchannelInfo);
begin
  if (w<0) or (w>ord(high(TinputType)))
    then sortieErreur('TacqChannel: invalid channel type');
  byte(pu.ChannelType) :=w;
end;

function fonctionTacqChannel_ChannelType(var pu:TchannelInfo):integer;
begin
  result:=ord(pu.ChannelType);
end;


function fonctionTacqChannel_Dy(var pu:TchannelInfo):float;
begin
  with pu do
  begin
    if jru1<>jru2
    then result:=(Yru2-Yru1)/(jru2-jru1)
    else result:=1;
  end;
end;

function fonctionTacqChannel_y0(var pu:TchannelInfo):float;
var
  dyB:float;
begin
  with pu do
  begin
    if jru1<>jru2
      then DyB:=(Yru2-Yru1)/(jru2-jru1)
      else DyB:=1;
    result:=Yru1-Jru1*DyB;
  end;
end;


procedure proTacqChannel_unitY(w:AnsiString;var pu:TchannelInfo);
begin
  pu.unitY  :=w;
end;

function fonctionTacqChannel_unitY(var pu:TchannelInfo):AnsiString;
begin
  result:=pu.unitY;
end;


procedure proTacqChannel_setScale(j1,j2:integer;y1,y2:float;var pu:TchannelInfo);
begin
  if (j1=j2) then sortieErreur(E_scale);

  with pu do
  begin
    jru1:=j1;
    jru2:=j2;
    Yru1:=y1;
    Yru2:=y2;
  end;
end;


procedure proTacqChannel_Gain(w:integer;var pu:TchannelInfo);
begin
  pu.Qgain :=w;
end;

function fonctionTacqChannel_Gain(var pu:TchannelInfo):integer;
begin
  result:=pu.Qgain;
end;

function fonctionTacqChannel_DownSamplingFactor(var pu:TchannelInfo):integer;
begin
  result:=pu.QKS;
end;

procedure proTacqChannel_DownSamplingFactor(w:integer;var pu:TchannelInfo);
begin
  pu.QKS:=w;
end;

function fonctionTacqChannel_EvtThreshold(var pu:TchannelInfo):float;
begin
  result:=pu.EvtThreshold;
end;

procedure proTacqChannel_EvtThreshold(w:float;var pu:TchannelInfo);
begin
  pu.EvtThreshold:=w;
end;

function fonctionTacqChannel_EvtHysteresis(var pu:TchannelInfo):float;
begin
  result:= pu.EvtHysteresis;
end;

procedure proTacqChannel_EvtHysteresis(w:float;var pu:TchannelInfo);
begin
  pu.EvtHysteresis:=w;
end;


function fonctionTacqChannel_EvtRisingEdge(var pu:TchannelInfo):boolean;
begin
  result:=pu.FRising;
end;

procedure proTacqChannel_EvtRisingEdge(w:boolean;var pu:TchannelInfo);pascal;
begin
  pu.FRising:=w;
end;

function fonctionTacqChannel_NrnSymbolName(var pu:TchannelInfo):AnsiString;
begin
  result:=AcqInf.nrnAcqName[pu.logCh-1];
end;

procedure proTacqChannel_NrnSymbolName(w:AnsiString;var pu:TchannelInfo);pascal;
begin
  AcqInf.nrnAcqName[pu.logCh-1]:=w;
end;




function fonctionTacquisition_Fcontinuous(var pu:typeUO):boolean;
begin
  result:=acqInf.continu;
end;

procedure proTacquisition_Fcontinuous(w:boolean;var pu:typeUO);
begin
  acqInf.continu:=w;
end;

function fonctionTacquisition_MaxEpCount(var pu:typeUO):integer;
begin
  result:=acqInf.maxEpCount;
end;

procedure proTacquisition_MaxEpCount(w:integer;var pu:typeUO);
begin
  controleParam(w,0,maxEntierLong,'TAcquisition: MaxEpCount must be positive ');
  acqInf.maxEpCount:=w;
end;

function fonctionTacquisition_ChannelCount(var pu:typeUO):integer;
begin
  result:=AcqInf.Qnbvoie;
end;

procedure proTacquisition_ChannelCount(w:integer;var pu:typeUO);
begin

  AcqInf.Qnbvoie:=w;
end;

function fonctionTacquisition_ISI(var pu:typeUO):float;
begin
  result:=AcqInf.ISIsec;
end;


procedure proTacquisition_ISI(w:float;var pu:typeUO);
begin
  controleParam(w,0.001,maxSingle,E_ISI);
  AcqInf.IsiSec:=w;
end;



function fonctionTacquisition_EpDuration(var pu:typeUO):float;
begin
  result:=acqInf.DureeSeq;  {lecture différente de l'affectation ci-dessous}
end;

procedure proTacquisition_EpDuration(w:float;var pu:typeUO);
begin
  controleParam(w,0,maxSingle,'TAcquisition: invalid episode duration');
  acqInf.DureeSeqU:=w;
end;

function fonctionTacquisition_PeriodPerChannel(var pu:typeUO):float;
begin
  result:=acqInf.periodeCont;
end;

procedure proTacquisition_PeriodPerChannel(w:float;var pu:typeUO);
begin
  controleParam(w,0.001,maxSingle,'TAcquisition: invalid period');
  acqInf.periodeCont:=w;
end;

function fonctionTacquisition_MaxDuration(var pu:typeUO):float;
begin
  result:=acqInf.maxDuration;
end;

procedure proTacquisition_MaxDuration(w:float;var pu:typeUO);
begin
  controleParam(w,0,maxSingle,'TAcquisition: MaxDuration must be positive ');
  acqInf.maxDuration:=w;
end;


function fonctionTacquisition_PreTrigDuration(var pu:typeUO):float;
begin
  result:=acqInf.DureePreTrigU;
end;

procedure proTacquisition_PreTrigDuration(w:float;var pu:typeUO);
begin
  acqInf.DureePreTrigU:=w;
end;


function fonctionTacquisition_Fstimulate(var pu:typeUO):boolean;
begin
  result:=AcqInf.Fstim;
end;

procedure proTacquisition_Fstimulate(w:boolean;var pu:typeUO);
begin
  AcqInf.Fstim:=w;
end;

function fonctionTacquisition_Fdisplay(var pu:typeUO):boolean;
begin
  result:=AcqInf.Fdisplay;
end;

procedure proTacquisition_Fdisplay(w:boolean;var pu:typeUO);
begin
  AcqInf.Fdisplay:= w;
end;


function fonctionTacquisition_FimmediateDisplay(var pu:typeUO):boolean;
begin
  result:=AcqInf.Fimmediate;
end;

procedure proTacquisition_FimmediateDisplay(w:boolean;var pu:typeUO);pascal;
begin
  AcqInf.Fimmediate:=w;
end;


function fonctionTacquisition_Fprocess(var pu:typeUO):boolean;pascal;
begin
  result:= AcqInf.Fprocess;
end;

procedure proTacquisition_Fprocess(w:boolean;var pu:typeUO);
begin
  AcqInf.Fprocess:= w;
end;


function fonctionTacquisition_FholdDisplay(var pu:typeUO):boolean;
begin
  result:= AcqInf.Fhold;
end;

procedure proTacquisition_FholdDisplay(w:boolean;var pu:typeUO);
begin
   AcqInf.Fhold:=w;
end;

procedure proTacquisition_Refresh(var pu:typeUO);
begin
  if assigned(ThreadAff) then ThreadAff.FlagRefresh:=true;
end;




function fonctionTacquisition_TriggerMode(var pu:typeUO):integer;
begin
  result:=ord(AcqInf.modeSynchro)+1;
end;

procedure proTacquisition_TriggerMode(w:integer;var pu:typeUO);
begin
  controleParam(w,1,length(TrigType),'TAcquisition: invalid trigger mode ');
  AcqInf.modeSynchro:=TmodeSync(w-1);
  AcqCommand.UpdateThresholds;
end;

function fonctionTacquisition_TrigChannel(var pu:typeUO):integer;
begin
  result:=AcqInf.voieSynchro;
end;

procedure proTacquisition_TrigChannel(w:integer;var pu:typeUO);
begin
  AcqInf.voieSynchro:=w;
end;

function fonctionTacquisition_ThresholdUp(var pu:typeUO):float;
begin
  result:=AcqInf.SeuilPlus;
end;

procedure proTacquisition_ThresholdUp(w:float;var pu:typeUO);
begin
  AcqInf.SeuilPlus:=w;

end;


function fonctionTacquisition_ThresholdDw(var pu:typeUO):float;
begin
  result:=AcqInf.SeuilMoins;
end;

procedure proTacquisition_ThresholdDw(w:float;var pu:typeUO);
begin
  AcqInf.SeuilMoins:=w;
end;


function fonctionTacquisition_TestInterval(var pu:typeUO):integer;
begin
  result:=AcqInf.IntervalTest;
end;

procedure proTacquisition_TestInterval(w:integer;var pu:typeUO);
begin
  AcqInf.IntervalTest:=w;
end;

function fonctionTacquisition_NIrisingSlope(var pu:typeUO):boolean;
begin
  result:=AcqInf.NIRisingSlope;
end;

procedure proTacquisition_NIrisingSlope(w:boolean;var pu:typeUO);
begin
  AcqInf.NIRisingSlope:=w;
end;

procedure proTacquisition_MinimalTimeInBuffer(w:float;var pu:typeUO);
begin
  if w>=10 then UserMinimalTimeInBuffer:=w;
end;

function  fonctionTacquisition_MinimalTimeInBuffer(var pu:typeUO): float;
begin
  result:=UserMinimalTimeInBuffer;
end;

procedure proTacquisition_VspkBufferSize(w:integer;var pu:typeUO);
begin
  if w>0 then UserMaxMultiEvt:=w;
end;

function  fonctionTacquisition_VspkBufferSize(var pu:typeUO): integer;
begin
  if UserMaxMultiEvt > MaxMultiEvt
    then result:= UserMaxMultiEvt
    else result:= MaxMultiEvt;
end;


function fonctionTacquisition_comment(var pu:typeUO):pointer;
begin
  result:=@memoA;
end;



procedure proTacquisition_GetEpInfo(var x;size:integer;tpn:word;dep:integer;var pu:typeUO);
begin
  with acquisition do
  if not( assigned(facq) and facq.getEpInfo(x,size,dep))
      then sortieErreur(E_getEpInfo);
end;

procedure proTacquisition_SetEpInfo(var x;size:integer;tpn:word;dep:integer;var pu:typeUO);
begin
  with acquisition do
  if not( assigned(facq) and facq.setEpInfo(x,size,dep))
        then sortieErreur(E_setEpInfo);
end;

procedure proTacquisition_ReadEpInfo(var x;size:integer;tpn:word;var pu:typeUO);
begin
  with acquisition do
  if not( assigned(facq) and facq.ReadEpInfo(x,size))
        then sortieErreur(E_readEpInfo);
end;

procedure proTacquisition_WriteEpInfo(var x;size:integer;tpn:word;var pu:typeUO);
begin
  with acquisition do
  if not( assigned(facq) and facq.writeEpInfo(x,size))
        then sortieErreur(E_writeEpInfo);
end;

procedure proTacquisition_ReadEpInfoExt(var x;size:integer;tpn:word;var pu:typeUO);
{$IFDEF WIN64}
var
  dum: PtabOctet;
  nb,i: integer;
begin
  if (size mod 8<>0) or (tpn<>ord(nbExtended)) then sortieErreur('Tacquisition.ReadEpInfoExt : variable type is not extended');

  nb:=size div 8;
  getmem(dum,nb*10);
  try
  proTacquisition_ReadEpInfo(dum^, nb*10, tpn, pu);
  for i:=0 to nb-1 do
    PtabDouble(@x)^[i]:=ExtendedToDouble(dum^[i*10]);
  finally
  freemem(dum);
  end;
end;
{$ELSE}
begin
   proTacquisition_ReadEpInfo(x, size, tpn, pu);
end;
{$ENDIF}

procedure proTacquisition_WriteEpInfoExt(var x;size:integer;tpn:word;var pu:typeUO);
{$IFDEF WIN64}
var
  dum:PtabOctet;
  nb,i:integer;
begin
  if (size mod 8<>0) or (tpn<>ord(nbExtended)) then sortieErreur('Tacquisition.writeEpInfoExt : variable type is not extended');

  nb:=size div 8;
  getmem(dum,nb*10);
  try
  for i:=0 to nb-1 do
    DoubleToExtended(PtabDouble(@x)^[i], dum^[i*10]);

    proTacquisition_WriteEpInfo(dum^, nb*10, tpn, pu);
  finally
  freemem(dum);
  end;
end;
{$ELSE}
begin
  proTacquisition_WriteEpInfo(x, size, tpn, pu);
end;
{$ENDIF}


procedure proTacquisition_ResetEpInfo(var pu:typeUO);
begin
  if assigned(acquisition.facq) then
    acquisition.facq.resetEpInfo;
end;

procedure proTacquisition_GetFileInfo(var x;size:integer;tpn:word;dep:integer;var pu:typeUO);
begin
  with acquisition do
  if not( assigned(facq) and facq.getFileInfo(x,size,dep))
      then sortieErreur(E_getFileInfo);
end;

procedure proTacquisition_SetFileInfo(var x;size:integer;tpn:word;dep:integer;var pu:typeUO);
begin
  with acquisition do
  if not( assigned(facq) and facq.setFileInfo(x,size,dep))
        then sortieErreur(E_setFileInfo);
end;

procedure proTacquisition_ReadFileInfo(var x;size:integer;tpn:word;var pu:typeUO);
begin
  with acquisition do
  if not( assigned(facq) and facq.ReadFileInfo(x,size))
        then sortieErreur(E_readFileInfo);
end;


procedure proTacquisition_WriteFileInfo(var x;size:integer;tpn:word;var pu:typeUO);
begin
  with acquisition do
  if not( assigned(facq) and facq.writeFileInfo(x,size))
        then sortieErreur(E_writeFileInfo);
end;

procedure proTacquisition_ReadFileInfoExt(var x;size:integer;tpn:word;var pu:typeUO);
{$IFDEF WIN64}
var
  dum: PtabOctet;
  nb,i: integer;
begin
  if (size mod 8<>0) or (tpn<>ord(nbExtended)) then sortieErreur('Tacquisition.ReadFileInfoExt : variable type is not extended');

  nb:=size div 8;
  getmem(dum,nb*10);
  try
  proTacquisition_ReadFileInfo(dum^, nb*10, tpn, pu);
  for i:=0 to nb-1 do
    PtabDouble(@x)^[i]:=ExtendedToDouble(dum^[i*10]);
  finally
  freemem(dum);
  end;
end;
{$ELSE}
begin
   proTacquisition_ReadFileInfo(x, size, tpn, pu);
end;
{$ENDIF}

procedure proTacquisition_WriteFileInfoExt(var x;size:integer;tpn:word;var pu:typeUO);
{$IFDEF WIN64}
var
  dum:PtabOctet;
  nb,i:integer;
begin
  if (size mod 8<>0) or (tpn<>ord(nbExtended)) then sortieErreur('Tacquisition.writeFileInfoExt : variable type is not extended');

  nb:=size div 8;
  getmem(dum,nb*10);
  try
  for i:=0 to nb-1 do
    DoubleToExtended(PtabDouble(@x)^[i], dum^[i*10]);

    proTacquisition_WriteFileInfo(dum^, nb*10, tpn, pu);
  finally
  freemem(dum);
  end;
end;
{$ELSE}
begin
  proTacquisition_WriteFileInfo(x, size, tpn, pu);
end;
{$ENDIF}



procedure proTacquisition_ResetFileInfo(var pu:typeUO);
begin
  if assigned(acquisition.facq) then
    acquisition.facq.resetFileInfo;
end;


function fonctionTacquisition_EpInfoSize(var pu:typeUO):integer;
begin
  if assigned(acquisition.facq) then result:=acquisition.facq.getEpInfoSize
  else
  result:= AcqInf.EpInfoSize;
end;

procedure proTacquisition_EpInfoSize(w:integer;var pu:typeUO);
begin
  AcqInf.EpInfoSize:=w;

  if assigned(acquisition.facq) then
    if not acquisition.facq.setEpInfoSize(w)
       then sortieErreur(E_EpInfoSize);;
end;

function fonctionTacquisition_FileInfoSize(var pu:typeUO):integer;
begin
  if assigned(acquisition.facq) then result:=acquisition.facq.getFileInfoSize
  else
  result:= AcqInf.FileInfoSize;
end;

procedure proTacquisition_FileInfoSize(w:integer;var pu:typeUO);
begin
  AcqInf.FileInfoSize:=w;

  if assigned(acquisition.facq) then
   if not acquisition.facq.setFileInfoSize(w)
       then sortieErreur(E_FileInfoSize);
end;

procedure proTacquisition_Start(var pu:typeUO);
begin
  prosendCommand(1);
end;

procedure proTacquisition_StartAndSave(var pu:typeUO);
begin
  prosendCommand(2);
end;

procedure proTacquisition_StartAndSave_1(append:boolean;var pu:typeUO);
begin
  if append
    then prosendCommand(3)
    else prosendCommand(2);
end;

procedure proTacquisition_stop(var pu:typeUO);
begin
  FlagStop:=true;
  acquisition.setState(S_waitEnd);
end;

procedure proTacquisition_GenericFileName(st:AnsiString;var pu:typeUO);
begin
  acqInfF.stGenAcq:=st;
  if not acqInfF.verifierGen
    //then sortieErreur(E_genericFileName);
    then messageCentral('TAcquisition.GenericFileName : path not found');
end;

function fonctionTacquisition_GenericFileName(var pu:typeUO):AnsiString;
begin
  result:=acqInfF.stGenAcq;
end;

procedure proTacquisition_ActivateTrigger(var pu:typeUO);
begin
  if Tpg2(dacPg).processPhase=phase_init then
    begin
      acquisition.lancer;
      acquisition.FtrigActivate:=true;
    end;
end;

function fonctionTacquisition_Special1(mask,delay:integer;var pu:typeUO):integer;
begin
  result:=board.Special1(mask,delay);
end;

procedure proTacquisition_waitMode(b:boolean;var pu:PparamStim);
begin
  controleProcessPhase([phase_Init0]);

  acqInf.waitMode:=b;
end;

function fonctionTacquisition_waitMode(var pu:PparamStim):boolean;
begin
  controleProcessPhase([phase_Init0]);

  result:=acqInf.waitMode;
end;


procedure proTacquisition_ProcessDelay(x:integer;var pu:typeUO);
begin
  controleProcessPhase([phase_Init0]);

  ProcessDelay:=x;
end;

function fonctionTacquisition_ProcessDelay(var pu:typeUO):integer;
begin
  controleProcessPhase([phase_Init0]);

  result:=ProcessDelay;
end;

function fonctionTacquisition_Saving(var pu:typeUO):boolean;
begin
  result:=acquisition.FsavingData;
end;

function fonctionTacquisition_Append(var pu:typeUO):boolean;
begin
  result:=acquisition.FrepriseON;
end;

function fonctionTacquisition_Stopped(var pu:typeUO):boolean;
begin
  result:=FlagStop;
end;


procedure proTacquisition_InstallProcess(p00,p0,p1,p2:integer;var pu:typeUO);
begin
  acquisition.InstallProcess(p00,p0,p1,p2);
end;

function fonctionTacquisition_UseTagStart(var pu:typeUO):boolean;
begin
  if assigned(board) then result:=(board.TagMode<>tmNone);
end;

procedure proTacquisition_UseTagStart(w:boolean;var pu:typeUO);
begin
  if assigned(board) then board.FuseTagStart:=w;
end;

function fonctionTacquisition_isRunning(var pu:typeUO):boolean;
begin
  result:=assigned(acquisition) and acquisition.acqON OR animationON;
end;

procedure proTacquisition_WriteDBfileInfo(var db:TDBrecord; var pu:typeUO);
begin
  with acquisition do
  if assigned(facq)
    then facq.setDBFileInfo(db)
    else sortieErreur('Error Tacquisition.WriteDBfileInfo');
end;

procedure proTacquisition_WriteDBEpInfo(var db:TDBrecord; var pu:typeUO);
begin
  with acquisition do
  if assigned(facq)
    then facq.setDBepInfo(db)
    else sortieErreur('Error Tacquisition.WriteDBepInfo');
end;

function fonctionTacquisition_InsertObject(var uo:typeUO; var pu:typeUO):boolean;
begin
  verifierObjet(uo);
  acquisition.writeObject(uo);
end;

procedure proTAcquisition_InsertTag(code:integer; st:AnsiString;var pu:typeUO);
var
  i,index,ep:integer;
begin
  if acquisition.acqON and acqInf.FFdat and (acqInf.DFformat=ElphyFormat1) then
  begin
    i:=board.getSampleIndex;
    if acqInf.continu then
    begin
      Index:=i;
      ep:=1;
    end
    else
    begin
      Index:=i mod acqInf.Qnbpt;
      ep:=i div acqInf.Qnbpt;
    end;

    acquisition.InsertUtag(code,index,ep, Now, st);
  end;
end;

procedure proTAcquisition_InsertTagAndObject(code:integer; st:AnsiString;var uo:typeUO; var pu:typeUO);
var
  i,index,ep:integer;
begin
  verifierObjet(uo);
  if acquisition.acqON and acqInf.FFdat and (acqInf.DFformat=ElphyFormat1) then
  begin
    i:=board.getSampleIndex;
    if acqInf.continu then
    begin
      Index:=i;
      ep:=1;
    end
    else
    begin
      Index:=i mod acqInf.Qnbpt;
      ep:=i div acqInf.Qnbpt;
    end;

    acquisition.InsertUtag(code,index,ep, Now, st);
    acquisition.writeObject(uo);
  end;
end;

procedure proTAcquisition_ProgRestart(var pu:typeUO);
begin
  board.ProgRestart;
end;


function fonctionTacquisition_ElectrodeCount(var pu:typeUO):integer;
begin
  result:=AcqInf.CyberElecCount;
end;

procedure proTacquisition_ElectrodeCount(w:integer;var pu:typeUO);
begin
  if (w=0) or (w=32) or (w=64) or (w=96) or (w=128)
    then AcqInf.CyberElecCount:=w;
end;

function fonctionTacquisition_MaxNumberOfUnits(var pu:typeUO):integer;
begin
  result:=AcqInf.CyberUnitCount-1;
end;

function fonctionTacquisition_SamplesPerChannel(var pu:typeUO):integer;
begin
  result:=AcqInf.Qnbpt;
end;


procedure proTacquisition_MaxNumberOfUnits(w:integer;var pu:typeUO);
begin
  if (w>=0) and (w<=10) then AcqInf.CyberUnitCount:=w+1;
end;

function fonctionTacquisition_SpkWaveLength(var pu:typeUO):integer;
begin
  result:= AcqInf.CyberWaveLen;
end;

procedure proTacquisition_SpkWaveLength(w:integer;var pu:typeUO);
begin
  if (w>=16) and (w<=128) then AcqInf.CyberWaveLen:=w;
end;

function fonctionTacquisition_SpkSampleBeforeTrigger(var pu:typeUO):integer;
begin
  result:= AcqInf.PretrigWave;
end;

procedure proTacquisition_SpkSampleBeforeTrigger(w:integer;var pu:typeUO);
begin
  if (w>=0) and (w<=128) then  AcqInf.PretrigWave:=w;
end;

procedure proTacquisition_setWaveFormScale(j1,j2:integer;y1,y2:float;var pu:typeUO);
begin
  AcqInf.setCyberScale(j1,j2,y1,y2);
end;

function fonctionTacquisition_TestPhotonTime(DT: float;var pu:typeUO):float;
begin
  if board is TNIboard then result:= TNIboard(board).TestPhotonTime(DT);
end;

function fonctionTacquisition_ReadDigitalInput(device, port: integer;var pu:typeUO): integer;
begin
  if assigned(board)
    then result:=board.inDIO(device,port)
    else result:=-1;
end;

function fonctionTacquisition_WriteDigitalOutput(device, port, value:integer;var pu:typeUO): integer;
begin
  if assigned(board)
    then result:=board.outDIO(device,port,value)
    else result:=-1;
end;

function fonctionTacquisition_SetDigitalOutput(num:integer;value:boolean; var pu:typeUO): integer;
begin
  if assigned(board)
    then result:=board.setDout(num,value)
    else result:=-1;
end;

procedure proTacquisition_TestCentralSim(w:boolean;var pu:typeUO);
begin
  TestCentralSim:=w;
end;

function  fonctionTacquisition_TestCentralSim(var pu:typeUO): boolean;
begin
  result:= TestCentralSim;
end;


Initialization
AffDebug('Initialization wacq1',0);

installError(E_LogChannelNum, 'TAcquisition: invalid logical channel number ');
installError(E_PhysChannelNum, 'TAcquisition: invalid physical channel number ');

installError(E_Dy, 'Tacquisition: Dy must be strictly positive ');
installError(E_scale, 'Tacquisition.setScale: invalid parameter ');

installError(E_genericFileName, 'Tacquisition.genericFileName: path not found ');

installError(E_GIO,'Error writing data');
installError(E_testSize,'Missing data');

installError(  E_setEpInfo,'Acquisition.setEpInfo error');
installError(  E_getEpInfo,'Acquisition.getEpInfo error');
installError(  E_readEpInfo,'Acquisition.readEpInfo error');
installError(  E_writeEpInfo,'Acquisition.writeEpInfo error');
installError(  E_EpInfoSize,'Acquisition: EpInfo error');

installError(  E_setFileInfo,'Acquisition.setFileInfo error');
installError(  E_getFileInfo,'Acquisition.getFileInfo error');
installError(  E_readFileInfo,'Acquisition.readFileInfo error');
installError(  E_writeFileInfo,'Acquisition.writeFileInfo error');
installError(  E_FileInfoSize,'Acquisition: FileInfo error');


end.
