{  DEFINE PCLTEST}  // A supprimer en version release

unit NIbrd1;

interface
{$IFDEF FPC} {$mode delphi} {$DEFINE AcqElphy2} {$A1} {$Z1} {$ENDIF}

uses windows,classes,math, stdCtrls, mmSystem,
     util1,varconf1,
     debug0,
     stmdef,AcqBrd1,
     dataGeneFile,FdefDac2,
     Ncdef2,
     acqCom1, AcqInterfaces,
     acqDef2,acqInf2,stimInf2,
     NiDAQmx0,

     ViewListG2,
     stmTCPIP1, PCL0;


Const
  EnableStaticDO= false; // Permet de générer des tops sync soft

{  Photon system

   Cable Pin                     NI input                 NI Connector ( 1 & 2 )
       1           Y lsb         P0.0                     C1 52
       3                                                     17
       ..                                                    49
                                                             47
                                                             19
                                                             51
                                                             16
                                                             48

                                                          C2 52
       19          Y             P0.9                        17

       21          X lsb         P0.10                       49
       ...                                                   47
                                                             19
                                                             51
                                                             16
                                                             48
                                                             11
                                                             10
                                                             43
       39          X             P0.19                       42

       41          Strobe
       43          Rate          PFI9                     C1  3

       2,4,6...    Ground

}


var
  NiDevNames:TstringList; // initialisée au démarrage. Utilisée par stmNI

const
  PCLclockFrequency=4E6;  // 4 MHz

type
  TXYTrecord= record
                t: double;
                xy: longint;
              end;

  TtabXYTrecord= array[0..1000000] of TXYTrecord;
  PtabXYTrecord = ^TtabXYTrecord;

  TNIboard = class(TacqInterface)
  private
    DevName:  AnsiString;           // Device name ex: Dev2
    SdevName: AnsiString;           // idem with slash: /Dev2
    AItaskHandle: TtaskHandle;
    DItaskHandle: TtaskHandle;
    AOtaskHandle: TtaskHandle;
    DOtaskHandle: TtaskHandle;

    DOstaticHandle: TtaskHandle;    // Utilisé pour tester les tops synchro logiciels
                                    // Néfaste pour Fredo: utilisation de NI.Dout pour envoyer un code sur une autre machine
                                    // Neutralisé le 27-08-13
    DigEvTaskHandle0:TtaskHandle;
    DigEvTaskHandle1:TtaskHandle;
    DigEvTaskHandle2:TtaskHandle;


    {buffers utilisés par le driver NI }
    AIbuffer:PtabDouble;
    DIbuffer:PtabLong;
    DigEvBuffer,DigEvBuffer2: PtabLongWord;

    {Buffers intermédiaires}
    readBuffer:PtabEntier;
    ReadBufferSize:integer;
    PreadBuffer:integer;

    AObuffer:PtabDouble;
    DObuffer:PtabEntier;

    DigBuffer: PtabXYTrecord;
    DigBufferSize: integer;
    PdigBuffer:integer;

    status:integer;
    Fwaiting:boolean;
    nextSeq:integer;

    StatusStep:integer;
    LastErrorStatus:integer;
    stError:AnsiString;

    pstimBuf: TFbuffer;
    StoredEp:integer;
    EpSize:integer;
    EpSize1:integer;
    HoldSize:integer;
    IsiSize:integer;
    IsiSize1:integer;
    reliquat:integer;

    nbDataOut:int64;
    nbChOut:integer;
    nbDac:integer;
    nbDigi:integer;

    GIdig:integer;

    Vhold:array[0..100] of integer;

    ProcessData:procedure of Object;

    FStimUpdate:boolean;
    everyN:integer;
    FwaitInternalTrig: boolean;

    AItrigMin,AItrigMax:double;

    FperiodIN, FperiodOut: float;
    Frun:boolean;    { set by Init, reset by Terminer }
                     { if Frun, FperiodIN and FperiodOut can be read directly }

    Qnbvoie: integer;    { = AcqInf.Qnbvoie: le nombre de voies analogiques demandées }
    NbvAI: integer;      { le vrai nombre de voies AI }
    DigiEventCh0:integer;{ Le numéro de la voie digiEvent. Commence à zéro }

    PhotonMode: byte;    {reçoit AcqInf.AcqPhotons}

    DefaultStep: integer;

    PhotonTime0:double;                // Start time for  Continuous mode

    PhotonSystemTime: double;          // PC time in seconds
    PhotonPCLTime: double;             // Estimated PCL time

    function getCount:integer;override;
    function getCount2:integer;override;

    procedure StoreDigiEvent(ttt: double);
    procedure ProcessDigiEvent(it:integer);
    procedure ProcessDigiEvent1(it1, it2:integer);

    procedure StorePCLEvent(tt: double;xy:integer);  // tt en secondes
    procedure ProcessPCLEvent(it:integer);
    procedure ProcessPCLEvent1(it1, it2:integer);


    procedure doContinuous;
    procedure doInterne;

    procedure doNumPlus;

    procedure DoAnalogAbs;

    procedure nextSample;override;
    procedure CopySample(i:integer);override;

    procedure relancer;override;
    procedure restartAfterWait;override;

    procedure AIToReadBuffer(x:double);
    procedure DIToReadBuffer(x:word);
    procedure DigEvToDigBuffer(x1,x2:longword);

    function OutData(i0,nb:int64):boolean;
    function OutDataHold(nb:int64):boolean;
    Procedure OutPoints(nb:int64);
    procedure PreloadDac;

    function StopError(n:integer):boolean;overload;
    function StopError:boolean;overload;

    procedure FreeATaskHandle(var Handle: TtaskHandle; numError: integer);
    procedure FreeTaskHandles;
    procedure FreeBuffers;

    procedure SetHasDigInputs;
    procedure SetProcessData;

    procedure DoNothing;
   
 public
    DigInputs:array[0..7] of boolean;
    HasDigInputs:boolean;
    SingleDiff:integer;

    constructor create(var st1:driverString);override;
    destructor destroy;override;

    function transferData2(nsamples:integer): integer;

    procedure setThresholds;override;

    procedure init;override;
    function lancerDigiEvent: boolean;
    procedure lancer;override;
    procedure terminer;override;

    function dataFormat:TdataFormat;override;
    function dacFormat:TdacFormat;override;


    function PeriodeElem:float;override;
    function PeriodeMini:float;override;

    procedure outdac(num,j:word);override;
    function outDIO(dev,port,value: integer): integer;override;
    function inADC(n:integer):smallint;override;
    function inDIO(dev,port:integer):integer;override;

    function RAngeString:AnsiString;override;
    function MultiGain:boolean;override;
    function gainLabel:AnsiString;override;
    function nbGain:integer;override;

    function channelRange:boolean;override;

    procedure GetOptions;override;
    procedure setDoAcq(var procInt:ProcedureOfObject);override;

    procedure initcfgOptions(conf:TblocConf);override;

    function TagMode:TtagMode;override;
    function tagShift:integer;override;
    function TagCount:integer;override;

    function getMinADC:integer;override;
    function getMaxADC:integer;override;

    function deviceCount:integer;override;  { nb device }

    function ADCcount(dev:integer):integer;override;     { nb ADC par device }
    function DACcount(dev:integer):integer;override;     { nb DAC par device }

    function DigiOutCount(dev:integer):integer;override; { nb Digi Out par device }
    function DigiInCount(dev:integer):integer;override;  { nb Digi In par device }

    function bitInCount(dev:integer):integer;override;   { nb bits par entrée digi }
    function bitOutCount(dev:integer):integer;override;  { nb bits par sortie digi }

    function CheckParams:boolean;override;
    function nbVoieAcq(n:integer):integer;override;

    procedure setVSoptions;override;
    procedure GetPeriods(PeriodU:float;nbADC,nbDI,nbDAC,nbDO:integer;var periodIn,periodOut:float);override;

    function setValue(Device,tpout,physNum,value:integer):boolean;override;
    function getValue(Device,tpIn,physNum:integer;var value:smallint):boolean;override;

    procedure DisplayErrorMsg;override;
    function IsWaiting:boolean;override;

    procedure relancerNI;

    function IsWaitingTrig:boolean;override;

    function getDetLine(n:integer): AnsiString;
    procedure TestChangeDetect;
    procedure TestDetectEvent;
    procedure TestDetectAndChange;
    procedure TestDetectAndChange1;

    function CanAcqPhotons:boolean;override;

    procedure setDOStatic(v1,v2: boolean);
    procedure ReceiveTCPIP;
    procedure ReceiveTCPIP1(tt1,tt2:float);
    function TestPhotonTime(PacketDuration:float):float;
  end;

procedure EnterNI;
procedure LeaveNI;

procedure initNIBoards;

function getNIerrorString: string;

implementation

uses NiOptions,stmvec1;

const
  MaxIsi = 1000000000;  { valeur permettant de calculer x mod Isi }

procedure EnterNI;
begin
{$IFNDEF WIN64}
  asm      {Réinitialise le FPU: met tous les registres à zéro ! }
    Finit
  end;
{$ELSE}
  ClearExceptions;
  Reset8087CW;
{$ENDIF}
end;

procedure LeaveNI;
begin
  setPrecisionMode(pmExtended);
end;



procedure initNIBoards;
var
  i:integer;
  st,st1:AnsiString;
  res:int64;
var
  
  version:integer;
  buffer:array[0..999] of Ansichar;

begin
  if not initNIlib then exit;
  Affdebug('InitNIboards',254);
  NiDevNames:=TstringList.Create;
  NiDevNames.Clear;

  fillchar(buffer,sizeof(buffer),0);


  // 5 octobre 2012 : la fonction DAQmxGetSysDevNames ne ressort pas
  //   après un plantage des drivers NI
  //   aucun message
  EnterNI;
  res:=DAQmxGetSysDevNames(@buffer[0], 1000);
  leaveNI;

  st:=Pansichar(@buffer);
  //messageCentral(st);

  while (st<>'') and (pos(',',st)>0) do
  begin
    st1:=copy(st,1,pos(',',st)-1);
    if st1<>'' then NiDevNames.Add(st1);
    delete(st,1,pos(',',st));
  end;
  if st<>'' then NiDevNames.Add(st);

  For i:=0 to NiDevNames.count-1 do
    RegisterBoard('NI '+NiDevNames[i],pointer(TNIboard));


end;

{ TNIboard }

constructor TNIboard.create(var st1: driverString);
var
  stOut: string;
begin
  inherited;

  BoardFileName:='NI';
  DevName:=st1;
  delete(DevName,1,3); { retirer 'NI ' }
  DevName:=Fsupespace(DevName);

  SdevName:='/'+devName;

  readBufferSize:=65536; { 64K samples }
  getmem(readBuffer,readBufferSize*2);


  SingleDiff:= DAQmx_Val_RSE;

  if EnableStaticDO then
  begin
    EnterNI;
    status:= DAQmxCreateTask('',@DOstaticHandle); { La tâche Static }
    LeaveNI;
    if StopError(830)  then exit;

    stOut:=devName+'/PFI14,' + devName+'/PFI15';
    EnterNI;
    status:= DAQmxCreateDOChan(DOstaticHandle, Pansichar(stOut),'',DAQmx_Val_ChanForAllLines);
    LeaveNI;
    if StopError(831)  then exit;

    EnterNI;
    status:=DAQmxStartTask(DOStaticHandle);   { lancer la tâche DOstatic }
    LeaveNI;
    if StopError(816)  then exit;
  end;



end;

destructor TNIboard.destroy;
begin
  if EnableStaticDO then FreeAtaskHandle(DOstaticHandle, 314);

  freemem(readBuffer);
  inherited;
end;


procedure TNIboard.AIToReadBuffer(x: double);
begin
  readBuffer^[PreadBuffer mod nbpt0DMA]:=roundI(32767*x/10);
  inc(PreadBuffer);
  if PreadBuffer mod nbvoie=digiEventCh0 then inc(PreadBuffer);
end;

procedure TNIboard.DIToReadBuffer(x: word);
begin
  readBuffer^[PreadBuffer mod nbpt0DMA]:=x;
  inc(PreadBuffer);
end;

procedure TNIboard.DigEvToDigBuffer(x1,x2:longword);
begin
  with DigBuffer^[PdigBuffer mod DigBufferSize] do
  begin
    t:=x1/PCLclockFrequency;  // temps en secondes
    xy:=x2;
  end;
  inc(PdigBuffer);
//  affdebug('Dig '+Istr(PdigBuffer)+'  '+Istr(x),101);
end;

var
  vecDebug: Tvector;

function TNIboard.transferData2(nsamples:integer): integer;
var
  sampsPerChanRead1,sampsPerChanRead2, NbRead:integer;
  Nbread1, NbRead2: integer;
  n0,nDisp:integer;
  i,j:integer;

begin
//  if not assigned(vecDebug) then vecDebug:=Tvector.create(g_longint,0,-1);

  FwaitInternalTrig:=false;
  if nsamples<=0 then
  begin
    nsamples:=everyN;
  end;

  TRY
  result:=0;
  if status<0 then exit;


  reallocmem(AIbuffer,nsamples*nbvAI*sizeof(double));
  reallocmem(DIbuffer,nsamples*sizeof(longint));

  EnterNI;
  status:= DAQmxReadAnalogF64 (AItaskHandle, -1, DAQmx_Val_WaitInfinitely, DAQmx_Val_GroupByScanNumber, @AIBuffer[0], nSamples*nbvAI, @sampsPerChanRead1, nil);
  LeaveNI;
  if stopError(201) then exit;
  // AffDebug('NSamples='+Istr(Nsamples)+ '    Samps='+Istr(sampsPerChanRead1),97); provoque une erreur ( thread séparé )
//  vecDebug.addtoList(sampsPerChanRead1);
  result:=SampsPerChanRead1;

  if HasDigInputs then
  begin
    EnterNI;
    status:= DAQmxReadDigitalU32 (DItaskHandle, -1, DAQmx_Val_WaitInfinitely, DAQmx_Val_GroupByChannel, @DIBuffer[0], nSamples, @sampsPerChanRead2, nil);
    LeaveNI;
    if stopError(202) then exit;
  end;

  for i:=0 to sampsPerChanRead1-1 do
  begin
    for j:=0 to nbvAI-1 do AIToReadBuffer(AIbuffer[i*nbvAI+j]);
    if HasDigInputs then DItoReadBuffer(DIbuffer[i]);
  end;

  if PhotonMode=1 then
  begin
    EnterNI;
    status:=DAQmxReadCounterU32(DigEvtaskHandle0,-1,10.0,@DigEvBuffer^[0],100000,@NbRead1,Nil);   {100000 est la taille du buffer}
    LeaveNI;
    stopError;

    EnterNI;
    status:= DAQmxReadDigitalU32 (DigEvtaskHandle2, Nbread1, DAQmx_Val_WaitInfinitely, DAQmx_Val_GroupByChannel, @DigEvBuffer2^[0], 100000, @Nbread2, nil);
    LeaveNI; StopError;

    if Nbread2<NbRead1 then
    begin
      status:=-1;
      stopError;
    end;

    for i:=0 to NbRead1-1 do DigEvToDigBuffer(DigEvbuffer^[i],DigEvBuffer2^[i]);
  end
  else
  if (DigiEventCh0>=0) then
  begin
    EnterNI;
    status:=DAQmxReadCounterU32(DigEvtaskHandle0,-1,10.0,@DigEvBuffer^[0],100000,@NbRead,Nil);   {100000 est la taille du buffer}
    LeaveNI;
    stopError;

    for i:=0 to NbRead-1 do DigEvToDigBuffer(DigEvbuffer[i],0);
  end;



  ProcessData;

  FINALLY
    //affdebug('R1='+Istr(sampsPerChanRead1)+'   R2='+Istr(sampsPerChanRead2)+'   R='+Istr(PreadBuffer) ,79);
  END;
end;


function EveryNCallback(taskHandle:integer; everyNsamplesEventType:integer; nSamples:longword; callbackData:pointer):integer;cdecl;
var
  nb:integer;
begin
  nb:=TNIboard(callBackData).transferData2(nSamples);
  with TNIboard(callBackData) do
  if FStimUpdate then OutPoints(nb);
end;

function SignalCallback(taskHandle:integer; signalID:integer; callbackData:pointer):integer;cdecl;
var
  nb:integer;
begin
  nb:=TNIboard(callBackData).transferData2(10);
  with TNIboard(callBackData) do
  if FStimUpdate then OutPoints(nb);
end;


function DoneCallback( taskHandle: integer; status:integer; callbackData:pointer):integer;cdecl;
begin
  with TNIboard(callBackData) do
  if reliquat>0 then transferData2(reliquat);

end;

procedure TNIboard.nextSample;assembler;
asm
 {$IFNDEF WIN64}
     push  esi
     mov   esi,Ptab
     xor   eax,eax
     mov   ax,[esi]              {lire un point}

     add   esi,2
     cmp   esi,Ptabfin           {incrémenter Ptab}
     jl    @@1                   {mais si la fin est atteinte}
     mov   esi,Ptab0             {ranger l'adresse de début}
@@1: mov   Ptab,esi

     mov   word ptr wsample,ax            {ranger l'échantillon}
     mov   word ptr wsampleR,ax

@fin:pop   esi
{$ELSE}
     push  rsi
     mov   rsi,Ptab
     xor   eax,eax
     mov   ax,[rsi]              {lire un point}

     add   rsi,2
     cmp   rsi,Ptabfin           {incrémenter Ptab}
     jl    @@1                   {mais si la fin est atteinte}
     mov   rsi,Ptab0             {ranger l'adresse de début}
@@1: mov   Ptab,rsi

     mov   word ptr wsample,ax            {ranger l'échantillon}
     mov   word ptr wsampleR,ax

@fin:pop   rsi

{$ENDIF}
end;


procedure TNIboard.init;
begin
  SetHasDigInputs;

  // PCLbuf est alloué si AcqInf.AcqPhotons>0
  PhotonMode:= AcqInf.AcqPhotons;
  if (PhotonMode=2)and assigned(TCPIPserver) then
  begin
    if PhotonSystemTime=0 then
    begin
      flagStopPanic:=true;
      LastErrorStatus:=-1;
      stError:='Photon Time Not Initialized';
      exit;
    end;
    TCPIPserver.Fprivate:=true;

    PhotonTime0:= PhotonPCLTime +timeGetTime/1000-PhotonSystemTime;
  end;

  FreeTaskHandles; // Au cas où..

  PreadBuffer:=0;
  tabDma1:=ReadBuffer;
  nbpt0DMA:=(ReadBufferSize div AcqInf.nbVoieAcq)*AcqInf.nbVoieAcq ;

  initPadc;
  baseIndex:=0;
  nbvoie:=AcqInf.nbVoieAcq;     {nombre de voies dans MainBuf}
  GI1:=-1;
  GI1x:=-1;

  cntStim:=0;
  cntStoreDac:=0;

  Fwaiting:=false;
  StatusStep:=0;
  LastErrorStatus:=0;

  pstimBuf:=paramStim.buffers;
  StoredEp:=paramStim.StoredEp;

  if AcqInf.continu
    then EpSize:=paramStim.EpSize
    else EpSize:=AcqInf.Qnbpt;

  EpSize1:=EpSize*AcqInf.nbVoieAcq;

  FStimUpdate:=AcqInf.Fstim;
  if acqInf.continu then IsiSize:=EpSize
  else
  if (acqInf.ModeSynchro in [MSclavier, MSnumPlus] )
      or
     (acqInf.ModeSynchro in [MSimmediat,MSinterne]) and (acqInf.WaitMode) then
     begin
       IsiSize:=EpSize;
       FStimUpdate:=false;
     end
  else IsiSize:=AcqInf.IsiPts div AcqInf.nbVoieAcq;

  IsiSize1:=IsiSize*AcqInf.nbVoieAcq;
  HoldSize:=IsiSize-EpSize;

  if AcqInf.Fstim then
  begin
    nbChOut:=length(pstimBuf);
    nbDac:=paramStim.nbDac;
    nbDigi:=paramStim.nbDigi;
  end
  else
  begin
    nbChOut:=0;
    nbDac:=0;
    nbDigi:=0;
  end;

  setProcessData;
  Frun:=true;
end;

procedure TNIboard.setThresholds;
var
  stTrigChan:AnsiString;
  NItriggerSlope:integer;
  NItriggerLevel:double;

begin
 { Inutilisable , il faut stopper la tâche pour modifier les propriétés
 }

  if AcqInf.NIRisingSlope
      then NItriggerSlope:= DAQmx_Val_RisingSlope
      else NItriggerSlope:= DAQmx_Val_FallingSlope;
  NItriggerLevel:=acqInf.seuilPlusPts*10/32767;

  EnterNI;
  status:= DAQmxSetAnlgEdgeStartTrigLvl(AItaskHandle, NItriggerLevel);
  LeaveNI;
  if stopError(2001) then exit;

  EnterNI;
  status:= DAQmxSetAnlgEdgeStartTrigSlope(AItaskHandle, NItriggerSlope);
  LeaveNI;
  if stopError(2002) then exit;

end;

// On appelle LancerDigiEvent si PCLbuf est alloué ou si DigiEvent
function TNIboard.LancerDigiEvent: boolean;
var
  i,max:integer;
  stStrobe: string;
  stPort0: string;
  Nlines: longword;
begin
  result:=false;

  GIdig:=0;
  if assigned(PCLbuf)
    then storePCLevent(-1,0)
    else storeDigiEvent(-1);

  if PhotonMode=2 then
  begin
    result:=true;
    exit;
  end;

  {***************************** Programmation de ctr1 *****************************}
  { Génère un signal d'horloge  à 1 Mhz}
  EnterNI;
  status:=DAQmxCreateTask('DigEv1',@DigEVtaskHandle1);
  LeaveNI;
  if stopError(500) then exit;


  EnterNI;               // Horloge à 1 MHz
  status:=DAQmxCreateCOPulseChanFreq(DigEVtaskHandle1,Pansichar(SDevName+'/ctr1'),'',DAQmx_Val_Hz,DAQmx_Val_Low, 0 ,PCLclockFrequency ,0.50);
  LeaveNI;
  if stopError then exit;

  EnterNI;
  status:=DAQmxSetCOPulseTerm(DigEVtaskHandle1, Pansichar(SDevName+'/ctr1'), Pansichar(SDevName+'/pfi8'));    { Fixe la sortie de ctr1 sur PFI8 au lieu de PFI13 }
  LeaveNI;
  if stopError then exit;                                                     { doit être appelé après DAQmxCreateCOPulseChanFreq }

  EnterNI;
  status:=DAQmxCfgImplicitTiming(DigEVtaskHandle1,DAQmx_Val_ContSamps,1000000);
  LeaveNI;
  if stopError then exit;

  EnterNI;                                { Trigger digital}
  status:=DAQmxSetArmStartTrigType(DigEVtaskHandle1, DAQmx_Val_DigEdge);
  LeaveNI;
  if stopError then exit;

  EnterNI;                                { Le compteur démarrera en même temps que l'acquisition }
  status:=DAQmxSetDigEdgeArmStartTrigSrc(DigEVtaskHandle1,Pansichar(SDevName+'/ai/StartTrigger'));
  LeaveNI;
  if stopError then exit;

  {******************************** Programmation de ctr0 *************************}

  EnterNI;
  status:= DAQmxCreateTask('DigEv0',@DigEVtaskHandle0);
  LeaveNI;
  if stopError then exit;

  EnterNI;
  status:=DAQmxCreateCICountEdgesChan(DigEVtaskHandle0,Pansichar(SDevName+'/ctr0'),'',DAQmx_Val_Rising,0,DAQmx_Val_CountUp);
  LeaveNI;
  if stopError then exit;

  EnterNI;
  status:=DAQmxSetCICountEdgesTerm(DigEVtaskHandle0,Pansichar(SDevName+'/ctr0'),Pansichar(SDevName+'/PFI8'));      { Fixe l'horloge de ctr0 }
  LeaveNI;                                                  { Doit être placé après DAQmxCreateCICountEdgesChan !!! }
  if stopError then exit;

  if assigned(PCLbuf)
    then stStrobe:=SDevName+'/PFI9'
    else stStrobe:=SDevName+'/PFI10';
  EnterNI;
  status:=DAQmxCfgSampClkTiming(DigEVtaskHandle0,Pansichar(StStrobe),1000000 ,DAQmx_Val_Rising,DAQmx_Val_ContSamps,1000000);
                   // PFI9 est l'entrée strobe  ==> OK
                   // 1000000 samples/sec max
                   // 1000000 samples in buffer
  LeaveNI;
  if stopError then exit;


  {********************************  La tâche Change Detect  sur Port0 ************************************}

  if assigned(PCLbuf) then
  begin
    EnterNI;
    status:= DAQmxCreateTask('DigEv2',@DigEvTaskHandle2);
    LeaveNI; StopError;

    EnterNI;         {Acquisition des lignes synchronisées (P0)  }
    status:= DAQmxCreateDIChan(DigEvTaskHandle2,Pansichar( SDevName+'/port0'),'',DAQmx_Val_ChanForAllLines);     // SDevName+'/port0/line0:31'
    LeaveNI; StopError;

    {
    EnterNI;
    status:= DAQmxGetDINumLines( DigEvTaskHandle2,Pansichar( SDevName+'/port0/'), @Nlines);
    LeaveNI; StopError;
    messageCentral('Nlines='+Istr(Nlines));
    }

    EnterNI;         { On indique sur quelles lignes on détecte les changements }
    status:= DAQmxCfgChangeDetectionTiming(DigEvTaskHandle2,Pansichar(SDevName+'/PFI9'),'',DAQmx_Val_ContSamps,1000000);
    LeaveNI; StopError;
  end;

  {********************************* Triggers ***************************************************************}
  EnterNI;                                { Trigger digital }
  status:=DAQmxSetArmStartTrigType(DigEVtaskHandle0, DAQmx_Val_DigEdge);
  LeaveNI;
  if stopError then exit;

  EnterNI;                                { Le compteur démarrera en même temps que l'acquisition }
  status:=DAQmxSetDigEdgeArmStartTrigSrc(DigEVtaskHandle0,Pansichar(SDevName+'/ai/StartTrigger'));
  LeaveNI;
  if stopError then exit;


  {********************************* Task Start ***************************************************************}
  EnterNI;
  status:=DAQmxStartTask(DigEVtaskHandle1);
  LeaveNI;
  if stopError then exit;

  EnterNI;
  status:=DAQmxStartTask(DigEVtaskHandle0);
  LeaveNI;
  if stopError then exit;

  if assigned(PCLbuf) then
  begin
    EnterNI;
    status:=DAQmxStartTask(DigEVtaskHandle2);
    LeaveNI;
    if stopError then exit;
  end;

  result:=true;
end;

procedure TNIboard.lancer;
var
  i:integer;
  stChan,stOut,stTrigChan:AnsiString;

  NIbufSize:integer;

  mxrate:double;
  mxMode:integer;
  mxNbPt:integer;

  mxPFI0:boolean;
  mxPFI0val: integer;

  mxAnalog:boolean;
  NItriggerSlope:integer;
  NItriggerLevel:double;

begin
  affdebug('LANCER',80);

  Qnbvoie:=AcqInf.Qnbvoie;
  nbvAI:=0;
  DigiEventCh0:=-1;
  for i:=1 to Qnbvoie do
  begin
    if AcqInf.ChannelType[i] in [TI_analog,TI_anaEvent] then inc(nbvAI);
    if AcqInf.ChannelType[i]=TI_digiEvent then DigiEventCh0:=i-1;
  end;

  if assigned(PCLbuf) then
  begin
    DigBufferSize:=100000;
    reallocmem(DigEvBuffer, DigBufferSize*sizeof(integer));
    reallocmem(DigEvBuffer2,DigBufferSize*sizeof(integer));

    reallocmem(DigBuffer,DigBufferSize*sizeof(TXYTrecord));
    PdigBuffer:=0;
  end
  else
  if DigiEventCh0>=0 then
  begin
    DigBufferSize:=100000;
    reallocmem(DigEvBuffer,DigBufferSize*sizeof(integer));
    freemem(DigEvBuffer2);
    DigEvBuffer2:= nil;
    reallocmem(DigBuffer,DigBufferSize*sizeof(TXYTrecord));
    PdigBuffer:=0;
  end
  else
  begin
    freemem(DigEvBuffer);
    freemem(DigEvBuffer2);

    DigEvBuffer:=nil;
    DigEvBuffer2:=nil;

    DigBufferSize:=0;
    freemem(DigBuffer);
    DigBuffer:=nil;
  end;

  Ptab:=Ptab0;

  restartOnTimer:=false;
  AcqTime0:=GetTickCount;
  nextSeq:=AcqInf.Qnbpt*AcqInf.nbVoieAcq;

  mxrate:=round(1000/AcqInf.periodeCont);
  mxPFI0:=false;
  mxAnalog:=false;

  { Définir mxMode , mxNbPt et mxPFI en fonction des différents modes d'aquisition }
  if AcqInf.continu then
  begin
    if (AcqInf.maxDuration>0) and (AcqInf.MaxAdcSamples<1E6) then
    begin
      // Avec cette méthode, le driver NI alloue un buffer qui doit recevoir tous les échantillons. Si le buffer est trop grand, ça ne marche plus (>100 Mega)
      // Avantage minime: l'acq s'arrête précisément sur le dernier échantillon
      mxMode:= DAQmx_Val_FiniteSamps;
      mxNbpt:=AcqInf.MaxAdcSamples div NbvAI +1;
    end
    else
    begin
      // Ici, l'acq ne s'arrête jamais. Comme Elphy compte les éch traités, l'acq s'arrête quand le nb est dépassé
      mxMode:= DAQmx_Val_ContSamps;
      mxNbpt:=10000;
    end;
    mxPFI0:= (acqInf.ModeSynchro in [MSnumPlus,MSnumMoins]);
    if acqInf.ModeSynchro = MSnumPlus then mxPFI0val:= DAQmx_Val_Rising else mxPFI0val:= DAQmx_Val_Falling;
  end
  else
  begin
    if (acqInf.ModeSynchro in [MSimmediat,MSinterne]) and acqInf.waitMode then
    begin
      mxMode:= DAQmx_Val_FiniteSamps;
      mxNbPt:= AcqInf.Qnbpt;
      restartOnTimer:=true;
    end
    else
    if (acqInf.ModeSynchro in [MSimmediat,MSinterne]) and (acqInf.maxEpCount>0) then
    begin
      {En donnant une limite globale au nb d'échantillons acquis, on évite le démarrage
      d'une séquence de trop , ce qui peut être génant si on stimule
      }
      mxMode:= DAQmx_Val_FiniteSamps;
      if acqInf.maxEpCount=1
        then mxNbPt:=AcqInf.Qnbpt
        else mxNbPt:=IsiSize*(acqInf.maxEpCount-1) +epSize;

      {Mais si la durée totale est trop importante, le driver NI alloue un énorme buffer
       On se limite à 50 mégaoctets.
       Dans ce cas ou bien si l'intervalle entre épisodes est supérieur à 100 ms,
       on fait comme si maxEpCount n'était pas fixé
      }
      if (mxNbPt> 5E7) or (AcqInf.IsiSec*1000-AcqInf.dureeSeq>100) then
      begin
        mxMode:= DAQmx_Val_ContSamps;
        mxNbpt:=10000;
      end;
    end
    else
    if (acqInf.ModeSynchro in [MSnumPlus,MSnumMoins, MSclavier]) then
    begin
      mxPFI0:= (acqInf.ModeSynchro in [MSnumPlus,MSnumMoins]);
      if acqInf.ModeSynchro = MSnumPlus then mxPFI0val:= DAQmx_Val_Rising else mxPFI0val:= DAQmx_Val_Falling;
      mxMode:= DAQmx_Val_FiniteSamps;
      mxNbpt:=AcqInf.Qnbpt;
    end
    else
    if (acqInf.ModeSynchro =MSanalogNI) then
    begin
      mxMode:= DAQmx_Val_FiniteSamps;
      mxNbpt:=AcqInf.Qnbpt;
      mxAnalog:=true;
    end
    else       { mode synchro analog ou immediat,interne si maxEpCount=0}
    begin
      mxMode:= DAQmx_Val_ContSamps;
      mxNbpt:=10000;
    end;
  end;


  if AcqInf.Fstim then
  begin
    { Programmer la stimulation analogique }
    if nbdac>0 then
    begin
      stOut:='';                                    { stOut est la liste des canaux utilisés }
      for i:=0 to paramstim.nbDac-1 do
      with paramStim.BufferInfo[i]^ do
      if (physNum>=0) and (physNum<=ADCcount(0)-1)  then
      begin
        if stOut<>'' then stOut:=stOut+',';
        stOut:=stOut+devName+'/ao'+Istr(physNum);
      end;

      EnterNI;
      status:= DAQmxCreateTask('AO', @AOtaskHandle);  { Créer la tâche  }
      LeaveNI;
      if StopError(100) then exit;

      EnterNI;
      status:= DAQmxCreateAOVoltageChan(AOtaskHandle,Pansichar(stOut),'',-10.0,10.0,DAQmx_Val_Volts,Nil); { Les canaux }
      LeaveNI;
      if StopError(101)  then exit;

      EnterNI;
      status:= DAQmxCfgSampClkTiming(AOtaskHandle,Pansichar('/'+DevName+'/ai/SampleClock'),mxrate,DAQmx_Val_Rising,DAQmx_Val_ContSamps,1000); { L'horloge }
      LeaveNI;                                                    { On indique que l'on utilise l'horloge définie pour les entrées analogiques }
      if StopError(102)  then exit;
    end;

     { Programmer la stimulation digitale }
    if nbDigi>0 then
    begin
      stOut:='';                                    { stOut est la liste des canaux logiques utilisés }

      with paramStim.BufferInfo[nbDac]^ do
      if (physNum>=0) and (physNum<=DigiOutCount(0)-1)   then
      begin
        for i:=0 to 7 do
          if not DigInputs[i] then
          begin
            if stOut<>'' then stOut:=stOut+',';
            stOut:=stOut+devName+'/port'+Istr(physNum)+'/line'+Istr(i);
          end;
      end;


      EnterNI;
      status:= DAQmxCreateTask('DO',@DOtaskHandle); { La tâche }
      LeaveNI;
      if StopError(130)  then exit;

      EnterNI;
      status:= DAQmxCreateDOChan(DOtaskHandle, Pansichar(stOut),'',DAQmx_Val_ChanForAllLines);
      LeaveNI;
      if StopError(131)  then exit;

      EnterNI;
      status:= DAQmxCfgSampClkTiming(DOtaskHandle,Pansichar('/'+DevName+'/ai/SampleClock'),mxrate,DAQmx_Val_Rising,DAQmx_Val_ContSamps,10000);
      LeaveNI;                                                { On utilise l'horloge définie pour les entrées analogiques }
      if StopError(132)  then exit;
    end;
  end;



  { Programmer les entrées analogiques }


  { stChan contient la liste des canaux }
  stChan:='';
  for i:=1 to acqInf.Qnbvoie   do
  if AcqInf.ChannelType[i] in [TI_analog,TI_anaEvent] then
  begin
    if stchan<>'' then stChan:=stChan+',';
    stchan:= stChan +devName+'/ai'+Istr(AcqInf.QvoieAcq[i]);
  end;

  try
  EnterNI;
  status:= DAQmxCreateTask('AI', @AItaskHandle);     { Créer la tâche }
  LeaveNI;
  if StopError(103)  then exit;

  EnterNI;
  status:= DAQmxCreateAIVoltageChan(AItaskHandle,Pansichar(stChan),'',SingleDiff,-10.0,10.0,DAQmx_Val_Volts,Nil); { Les canaux }
  LeaveNI;
  if StopError(104)  then exit;

  EnterNI;
  status:= DAQmxCfgSampClkTiming(AItaskHandle,'',mxrate,DAQmx_Val_Rising, mxMode, mxNbPt );            { L'horloge est interne }
  LeaveNI;
  if StopError(105)  then exit;

  if mxPFI0 then
  begin
    EnterNI;
    DAQmxCfgDigEdgeStartTrig(AItaskHandle,Pansichar('/'+devName+'/PFI0'),mxPFI0val);   { Le trigger éventuel }
    LeaveNI;
  end
  else
  if mxAnalog then
  begin
    stTrigChan:=devName+'/ai'+Istr(AcqInf.QvoieAcq[AcqInf.voieSynchro]);
    if AcqInf.NIRisingSlope
        then NItriggerSlope:= DAQmx_Val_RisingSlope
        else NItriggerSlope:= DAQmx_Val_FallingSlope;

    NItriggerLevel:=acqInf.seuilPlusPts*10/32767;

    AItrigMin:=-9.980;
    AItrigMax:=9.980;

    if NItriggerLevel> AItrigMax then NItriggerLevel:= AItrigMax;
    if NItriggerLevel< AItrigMin then NItriggerLevel:= AItrigMin;


    {status:=}
    EnterNi;
    DAQmxCfgAnlgEdgeStartTrig (AItaskHandle, Pansichar(stTrigChan), NItriggerSlope, NItriggerLevel);
    LeaveNI;
  end;


  if StopError(106)  then exit;

  { Programmer les entrées digitales }
  if HasDigInputs then
  begin
    stChan:='';
    for i:=0 to 7 do
    if DigInputs[i] then
    begin
      if stChan<>'' then stChan:=stChan+',';
      stChan:=stChan+devName+'/port0/line'+Istr(i);
    end;

    EnterNI;
    status:= DAQmxCreateTask('DI',@DItaskHandle); { La tâche }
    LeaveNI;
    if StopError(107)  then exit;

    EnterNI;
    status:= DAQmxCreateDIChan(DItaskHandle, Pansichar(stChan),'',DAQmx_Val_ChanForAllLines);
    LeaveNI;
    if StopError(108)  then exit;

    EnterNI;
    status:= DAQmxCfgSampClkTiming(DItaskHandle,Pansichar('/'+DevName+'/ai/SampleClock'),mxrate,DAQmx_Val_Rising,DAQmx_Val_ContSamps,1000);
    LeaveNI;                                                { On utilise l'horloge définie pour les entrées analogiques }
    if StopError(109)  then exit;
  end;

  { On souhaite définir une callback function appelée toutes les 50 millisecondes (tous les everyN points)
    Mais la taille du buffer NI doit être un multiple de everyN et doit être paire
    On ajuste donc la taille du buffer NI pour tenir compte de cette contrainte.
  }

  EnterNI;
  status:=DAQmxGetBufInputBufSize(AItaskHandle, @NIbufSize);  { NIbufSize = taille actuelle }
  LeaveNI;
  if StopError(111)  then exit;

  everyN:= round(mxrate/(20*10)*0.8)*10; {nombre de pts par voie en 50 millisecondes }       // ou 40
  if everyN<=2 then everyN:=2;

  getmem(AIbuffer,nbvAI*everyN*sizeof(double));
  if HasDigInputs then getmem(DIbuffer,everyN*sizeof(longint));


  if NIbufSize mod everyN <>0 then
  begin
    EnterNI;
    status:=DAQmxSetBufInputBufSize(AItaskHandle, round(NIbufSize/everyN)*everyN) ; { Nouvelle taille }
    LeaveNI;
  end;

  if mxMode = DAQmx_Val_FiniteSamps
    then reliquat:=mxNbpt-(mxNbPt div EveryN)*EveryN
    else reliquat:=0;

  EnterNI;
  status:= DAQmxRegisterEveryNSamplesEvent(AItaskHandle,DAQmx_Val_Acquired_Into_Buffer,EveryN,0,@EveryNCallback,self);
                                                  { Définir la callback function EveryNSamples }

//  status:= DAQmxRegisterSignalEvent(AItaskHandle,DAQmx_Val_SampleClock,0,@SignalCallback,self);
//                        Avec cette fonction, le transfert est fait à chaque cycle d'horloge .
  LeaveNI;
  if StopError(112)  then exit;

  EnterNI;
  status:= DAQmxRegisterDoneEvent(AItaskHandle,0,@DoneCallback,self); { idem pour une fonction appelée en fin de tâche }
  LeaveNI;
  if StopError(113)  then exit;

  if AcqInf.Fstim then
  begin
    initPmainDac;
    PreloadDAC;
  end;

  if PhotonMode>0  then
  begin
    if not lancerDigiEvent then exit;
  end
  else
  if (DigiEventCh0>=0)  then
    if not lancerDigiEvent then exit;;

  if HasDigInputs then
  begin
    EnterNI;
    status:=DAQmxStartTask(DItaskHandle);   { lancer la tâche DI }
    LeaveNI;
    if StopError(114)  then exit;
  end;

  if AcqInf.Fstim then
  begin
    if nbdac>0 then
    begin
      EnterNI;
      status:=DAQmxStartTask(AOtaskHandle);   { lancer la tâche AO }
      LeaveNI;

      if StopError(115)  then exit;
    end;

    if nbDigi>0 then
    begin
      EnterNI;
      status:=DAQmxStartTask(DOtaskHandle);   { lancer la tâche DO }
      LeaveNI;
      if StopError(116)  then exit;
    end;
  end;


  EnterNI;
  status:=DAQmxStartTask(AItaskHandle);     { lancer la tâche AI en dernier}
  LeaveNI;
  if StopError(117)  then exit;

  if AcqInf.modeSynchro=MSanalogNI then FwaitInternalTrig:=true;
  finally
  if status<0 then DisplayErrorMsg;
  end;

  PhotonTime0:= PhotonPCLTime +timeGetTime/1000-PhotonSystemTime;
end;

procedure TNIboard.relancer;
begin
  affdebug('relancer',80);

  Fwaiting:=false;
  postMessage(formStm.Handle, Msg_NIboards,0,0);
  { Les fonctions EveryNcallback et DoneCallBack doivent être appelées depuis le thread qui appelle
    DAQmxStartTask, DAQmxClearTask, etc...
    Donc, on relance à partir du thread principal.
  }
end;

procedure TNIboard.relancerNI;
var
  i,j,k,GI2,GI2x:integer;
  i1:integer;
begin
  affdebug('RELANCERNI',80);

  if AcqInf.Fstim then
    begin
      inc(baseIndex,EpSize*nbChOut);
    end;

  FreeTaskHandles;
  FreeBuffers;
  lancer;


  Fwaiting:=false;
end;

procedure TNIboard.FreeATaskHandle(var handle:TtaskHandle; numError: integer);
begin
  if  Handle<>0 then
  begin
    EnterNI;
    status:=DAQmxStopTask(Handle);  // No error
    LeaveNI;
    EnterNI;
    status:=DAQmxClearTask(Handle); // No Error
    LeaveNI;
    if status=0 then Handle:=0;
  end;
end;


procedure TNIboard.FreeTaskHandles;
begin
  FreeAtaskHandle(AItaskHandle, 301);
  FreeAtaskHandle(DItaskHandle, 303);
  FreeAtaskHandle(AOtaskHandle, 305);
  FreeAtaskHandle(DOtaskHandle, 307);

  FreeAtaskHandle(DigEvtaskHandle0, 309);
  FreeAtaskHandle(DigEvtaskHandle1, 311);
  FreeAtaskHandle(DigEvtaskHandle2, 312);

  
end;

procedure TNIboard.FreeBuffers;
begin
  freemem(AIbuffer);
  AIbuffer:=nil;

  freemem(DIbuffer);
  DIbuffer:=nil;

  freemem(AObuffer);
  AObuffer:=nil;

  freemem(DObuffer);
  DObuffer:=nil;

  freemem(DigEvBuffer);
  DigEvBuffer:=nil;

  freemem(DigEvBuffer2);
  DigEvBuffer2:=nil;
end;

procedure TNIboard.terminer;
begin
  FreeTaskHandles;
  FreeBuffers;
  Frun:=false;

  if assigned(TCPIPserver) then TCPIPserver.Fprivate:=false;

//  if assigned(vecDebug) then vecDebug.show(nil);
end;

function TNIboard.getCount: integer;
begin
  result:=PreadBuffer;
end;

function TNIboard.getCount2: integer;
begin
  result:=-1;
end;



function TNIboard.ADCcount(dev: integer): integer;
begin
  result:=16;
end;

function TNIboard.bitInCount(dev: integer): integer;
begin
  result:=8;
end;

function TNIboard.bitOutCount(dev: integer): integer;
begin
  result:=8;
end;

function TNIboard.channelRange: boolean;
begin
  result:=false;
end;

function TNIboard.CheckParams: boolean;
begin
  result:=true;
end;

procedure TNIboard.CopySample(i: integer);
begin
  inherited
end;



function TNIboard.DACcount(dev: integer): integer;
begin
  result:=2;
end;

function TNIboard.dacFormat: TdacFormat;
begin
  result:=DACF1322;
end;

function TNIboard.dataFormat: TdataFormat;
begin
  result:=F16bits;
end;


function TNIboard.deviceCount: integer;
begin
  result:=1;
end;

function TNIboard.DigiInCount(dev: integer): integer;
begin
  result:=1;
end;

function TNIboard.DigiOutCount(dev: integer): integer;
begin
  result:=1;
end;




function TNIboard.gainLabel: AnsiString;
begin
  result:='';
end;


function TNIboard.getMaxADC: integer;
begin
  result:=32767;
end;

function TNIboard.getMinADC: integer;
begin
  result:=-32768;
end;

procedure TNIboard.GetOptions;
begin
  NIopt.execution(self);
end;

procedure TNIboard.GetPeriods(PeriodU: float; nbADC, nbDI, nbDAC,
  nbDO: integer; var periodIn, periodOut: float);
var
  i:integer;
  mxrate:double;
  mxMode:integer;
  mxNbPt:integer;
  stOut,stChan:AnsiString;

  rateAI, rateAO:double;

procedure GetRates;
begin

  if nbDac>0 then
  begin
    EnterNI;
    status:= DAQmxGetSampClkRate(AOtaskHandle,@rateAO);
    LeaveNI;
    if status=0 then periodOut:=1000/rateAO;
  end
  else
  if nbDO>0 then
  begin
    EnterNI;
    status:= DAQmxGetSampClkRate(DOtaskHandle,@rateAO);
    LeaveNI;
    if status=0 then periodOut:=1000/rateAO;
  end;

  EnterNI;
  status:= DAQmxGetSampClkRate(AItaskHandle,@rateAI);
  LeaveNI;
  if status=0 then periodIN:=1000/rateAI;
end;

begin
  {if (AItaskHandle<>0) or (DItaskHandle<>0) or (AOtaskHandle<>0) then}
  if Frun then
  begin
    periodIN:=FperiodIn;
    periodOut:=FperiodOut;   {Si l'acquisition est déjà programmée }
    Exit;
  end;

  TRY
  periodIN:=1;
  periodOut:=1;

  mxrate:=round(1000/periodU);

  mxMode:= DAQmx_Val_ContSamps;
  mxNbpt:=1000;

  if nbDAC>0 then
  begin
    stOut:='';
    for i:=0 to nbDac-1 do
    begin
      if stOut<>'' then stOut:=stOut+',';
      stOut:=stOut+devName+'/ao'+Istr(i);
    end;

    EnterNI;
    status:= DAQmxCreateTask('AO', @AOtaskHandle);
    LeaveNI;

    EnterNI;
    status:= DAQmxCreateAOVoltageChan(AOtaskHandle,Pansichar(stOut),'',-10.0,10.0,DAQmx_Val_Volts,Nil);
    LeaveNI;

    EnterNI;
    status:= DAQmxCfgSampClkTiming(AOtaskHandle,Pansichar('/'+DevName+'/ai/SampleClock'),mxrate,DAQmx_Val_Rising,DAQmx_Val_ContSamps,1000);
    LeaveNI;
  end
  else
  if nbDO>0 then
  begin
    stOut:=devName+'/port'+Istr(0)+'/line0';  { stOut est la liste des canaux logiques utilisés }

    EnterNI;
    status:= DAQmxCreateTask('DO',@DOtaskHandle); { La tâche }
    LeaveNI;

    EnterNI;
    status:= DAQmxCreateDOChan(DOtaskHandle, Pansichar(stOut),'',DAQmx_Val_ChanForAllLines);
    LeaveNI;

    EnterNI;
    status:= DAQmxCfgSampClkTiming(DOtaskHandle,Pansichar('/'+DevName+'/ai/SampleClock'),mxrate,DAQmx_Val_Rising,DAQmx_Val_ContSamps,1000);
    LeaveNI;
  end;


  stChan:=devName+'/ai0';
  for i:=1 to nbADC-1   do
    stchan:= stChan+','+devName+'/ai'+Istr(i);

  EnterNI;
  status:= DAQmxCreateTask('AI', @AItaskHandle);
  LeaveNI;

  EnterNI;
  status:= DAQmxCreateAIVoltageChan(AItaskHandle,Pansichar(stChan),'',SingleDiff,-10.0,10.0,DAQmx_Val_Volts,Nil);
  LeaveNI;

  EnterNI;
  status:= DAQmxCfgSampClkTiming(AItaskHandle,'',mxrate,DAQmx_Val_Rising, mxMode, mxNbPt );
  LeaveNI;

  GetRates;
  FINALLY
  FreeTaskHandles;

  FperiodIN:=periodIn;
  FperiodOut:=periodOut;

  END;

end;


function TNIboard.getValue(Device, tpIn, physNum: integer;
  var value: smallint): boolean;
begin

end;

function TNIboard.inADC(n: integer): smallint;
begin

end;

function TNIboard.inDIO(dev,port:integer): integer;
begin
  result:=0;
end;

procedure TNIboard.initcfgOptions(conf: TblocConf);
begin
  with conf do
  begin
    setvarconf('DigInputs',DigInputs,sizeof(DigInputs));
    setvarconf('FuseTagStart',FuseTagStart,sizeof(FuseTagStart));
    setvarconf('SingleDiff',SingleDiff,sizeof(SingleDiff));
  end;
end;                                                                          



function TNIboard.MultiGain: boolean;
begin
  result:=false;
end;

function TNIboard.nbGain: integer;
begin
  result:=1;
end;

function TNIboard.nbVoieAcq(n: integer): integer;
begin
  setHasDigInputs;
  result:=n + ord(HasDigInputs);
end;


procedure TNIboard.outdac(num, j: word);
begin
  inherited;

end;

function TNIboard.outDIO(dev,port,value: integer): integer;
begin

end;

function TNIboard.PeriodeElem: float;
begin
  result:=0.1;
end;

function TNIboard.PeriodeMini: float;
begin
  result:=1;
end;

function TNIboard.RAngeString: AnsiString;
begin
  result:='-10 Volts / +10 Volts';
end;


procedure TNIboard.restartAfterWait;
begin
  inherited;

end;

procedure TNIboard.setDoAcq(var procInt: ProcedureOfObject);
begin
  ProcInt:=nil;
end;

procedure TNIboard.setProcessData;
begin
  with acqInf do
  begin
    if continu then ProcessData:=DoContinuous
    else
      case modeSynchro of
        MSimmediat, MSinterne:
           if not WaitMode
             then ProcessData:=doInterne
             else ProcessData:=doNumPlus;
                                                                              
        MSnumPlus, MSnumMoins, MSclavier, MSanalogNI: ProcessData:=doNumPlus;

        MSanalogAbs:
          ProcessData:=DoAnalogAbs;

        else ProcessData:=DoNothing;
      end;
  end;
end;



function TNIboard.setValue(Device, tpout, physNum,
  value: integer): boolean;
begin

end;

procedure TNIboard.setVSoptions;
begin
  inherited;

end;

function TNIboard.TagCount: integer;
begin
  result:=8;
end;

function TNIboard.TagMode: TtagMode;
begin
  setHasDigInputs;
  if HasDigInputs
    then result:=tmITC
    else result:=tmNone;
end;

function TNIboard.tagShift: integer;
begin
  result:=0;
end;


procedure TNIboard.DisplayErrorMsg;
begin
  if LastErrorStatus<>0 then  messageCentral(stError);
end;

function TNIboard.IsWaiting: boolean;
begin
  result:=FWaiting;
end;

function TNIboard.OutData(i0, nb: int64): boolean;
var
  i,j:integer;
  sampsPerChanWritten:integer;
begin
  if status<0 then exit;

  if nbdac>0 then
  begin
    reallocmem(AObuffer,nb*nbDac*sizeof(double));

    for i:=0 to nbDac-1 do
    begin
      for j:=0 to nb-1 do AObuffer^[nb*i+j]:= Pstimbuf[i,i0+j] *10/32768;
      {move(Pstimbuf[i,i0],AObuffer^[nb*i],nb*2);}
      Vhold[i]:=Pstimbuf[i,i0+nb-1];
    end;

    EnterNI;
    status:= DAQmxWriteAnalogF64(AOtaskHandle, nb,false, 1, DAQmx_Val_GroupByChannel,
             @AObuffer^[0],  @sampsPerChanWritten, nil);
    LeaveNI;
    if stopError(601) then exit;;
  end;

  if (status=0) and (nbDigi>0) then
  begin
    EnterNI;
    status:= DAQmxWriteDigitalU16 (DOtaskHandle, nb,false, 1, DAQmx_Val_GroupByChannel,
             @Pstimbuf[nbDac,i0],  @sampsPerChanWritten, nil);
    LeaveNI;
    if stopError(602) then exit;
    Vhold[nbDac]:=Pstimbuf[nbDac,i0+nb-1];
  end;

  {if Not FlagSingleStim then} inc(cntStim,Nb*nbChOut);

  result:=not flagStop;
end;

{ OutDataHold sort nb points avec les valeurs courantes de Vhold }
function TNIboard.OutDataHold(nb: int64):boolean;
var
  i,j:integer;
  sampsPerChanWritten:integer;
begin
  if status<0 then exit;

  if nbdac>0 then
  begin
    reallocmem(AObuffer,nb*nbDac*sizeof(double));

    for i:=0 to nbDac-1 do
      for j:=0 to nb-1 do AObuffer^[nb*i+j]:=Vhold[i]*10/32768;

    EnterNI;
    status:= DAQmxWriteAnalogF64 (AOtaskHandle, nb,false, DAQmx_Val_WaitInfinitely, DAQmx_Val_GroupByChannel,
             @AObuffer^[0],  @sampsPerChanWritten, nil);
    LeaveNI;
    if stopError(701) then exit;
  end;

  if (status=0) and (nbDigi>0) then
  begin
    reallocmem(DObuffer,nb*2);
    for j:=0 to nb-1 do DObuffer^[j]:=Vhold[nbDac];

    EnterNI;
    status:= DAQmxWriteDigitalU16 (DOtaskHandle, nb,false, DAQmx_Val_WaitInfinitely, DAQmx_Val_GroupByChannel,
             @DOBuffer^[0],  @sampsPerChanWritten, nil);
    LeaveNI;
    if stopError(702) then exit;
  end;

  if status<0 then flagStop:=true;

  result:=not flagStop;
end;


procedure TNIboard.OutPoints(nb: int64);
var
  ep,epS,Iisi,IfinEp,IfinIsi:int64;
  nbE:int64;
  Ifin:int64;
  i0:int64;
begin
  i0:=nbDataOut;
  if nb<=0 then exit;

  Ifin:=i0+nb;

  repeat
    ep:=  i0 div IsiSize;         { Ep absolu }
    epS:= ep mod StoredEp;        { Ep relatif dans les stored Ep }
    Iisi:= i0 mod IsiSize;        { Index dans Isi }
    IfinEp:= ep*IsiSize+ EpSize;  { index absolu de la fin de l'épisode }
    IfinIsi:= (ep+1)*IsiSize;     { index absolu de la fin de l'isi }

    if i0<IfinEp then
    begin
      if i0+nb<=IfinEp
        then nbE:=nb
        else nbE:=IfinEp-i0;

      if i0+nbE>Ifin then nbE:=Ifin-i0;

      outData(EpS*EpSize+Iisi,nbE);
      inc(i0,nbE);
    end
    else
    if i0<IfinIsi then
    begin
      if i0+nb<=IfinIsi
        then nbE:=nb
        else nbE:=IfinIsi-i0;

      if i0+nbE>Ifin then nbE:=Ifin-i0;

      outDataHold(nbE);
      inc(i0,nbE);
    end;
  until i0>=Ifin;

  inc(nbDataOut,nb);

end;

procedure TNIboard.PreloadDac;
var
  nb:int64;
  numEp:integer;
begin
  if not AcqInf.Fstim  then exit;

  if nbchOut>0 then
  begin
    numEp:=baseIndex div nbchOut div EpSize;
    nbdataOut:=numEp*IsiSize;
  end
  else nbdataOut:=IsiSize;

  if not FstimUpdate
    then nb:=EpSize
    else nb:=IsiSize*storedEp;


  if nbdac>0 then
  begin
    EnterNI;
    status:=DAQmxSetBufOutputBufSize(AOtaskHandle, nb) ;
    LeaveNI;
    StopError(801);
  end;

  if nbDigi>0 then
  begin
    EnterNI;
    status:=DAQmxSetBufOutputBufSize(DOtaskHandle, nb) ;
    LeaveNI;
    StopError(802);
  end;

  outPoints(nb);

  affdebug('  Preload nb='+Istr(nb)+'  BaseIndex='+Istr(BaseIndex),80);
end;


function getNIerrorString: string;
var
  errBuf:array[0..2047] of Ansichar;
begin
  fillchar(errBuf,sizeof(errBuf),0);
  EnterNI;
  DAQmxGetExtendedErrorInfo(errBuf,2048);
  LeaveNI;
  result:= PAnsiChar(@errBuf);
end;

function TNIboard.StopError(n: integer):boolean;
begin
  DefaultStep:=n;
  result:=(status<0);
  if result and (LastErrorStatus=0) then
  begin
    statusStep:=n;
    LastErrorStatus:=status;
    FlagStop:=true;

    if status<>-1
      then stError:= 'Step='+ Istr(StatusStep)+crlf+getNIerrorString
      else stError:= 'Step='+ Istr(StatusStep);
  end;
end;

function TNIboard.StopError:boolean;
begin
  inc(DefaultStep);
  result:=StopError(DefaultStep);
end;

procedure TNIboard.SetHasDigInputs;
var
  i:integer;
begin
  HasDigInputs:=false;
  if FuseTagStart then
  for i:=0 to 7 do
    if DigInputs[i] then HasDigInputs:=true;
end;

procedure TNIboard.DoNothing;
begin

end;

procedure TNIboard.doNumPlus;
var
  i,j,k,GI2,GI2x:integer;
  i1:integer;
  t:longWord;
begin
  if Fwaiting then exit;

  GI2:=getcount-1;

  for i:=GI1+1 to GI2 do
  begin
    if i=0 then AcqPCtime:=GetTickCount;
    nextSample;
    storeWsample;

    if i=nextSeq-1 then
      begin
        GI1:=-1;
        GI2:=0;
        PreadBuffer:=0;

        GI1x:=-1;
        if assigned(PCLbuf) then ProcessPCLEvent1(0,i)
        else
        if DigiEventCh0>=0 then ProcessDigiEvent1(0,i);


        Fwaiting:=true;
        exit;
      end;
  end;

  if assigned(PCLbuf) then ProcessPCLEvent1(0,GI2)
  else
  if DigiEventCh0>=0 then ProcessDigiEvent1(0,GI2);

  GI1:=GI2;
end;


procedure TNIboard.DoAnalogAbs;
var
  j:integer;
  i:integer;
begin
  GI2:=getCount-1;
  for i:=GI1+1 to GI2 do
  begin
    nextSample;
    if not Ftrig then
      begin
        if (i mod nbvoie=VoieSync-1) then
          begin
            if (i>nbAv) and
               ( (wSampleR[0]>=seuilP) and (oldw1<seuilP)
                 OR
                 (wSampleR[0]<=seuilM) and (oldw1>seuilM)
               ) then
              begin
                TrigDate:=i div nbvoie*nbvoie;
                Ftrig:=true;
                for j:=trigDate-nbAv to i do copySample(j);

                if assigned(PCLbuf) then ProcessPCLEvent1(trigDate-nbAv,i)
                else
                if DigiEventCh0>=0 then ProcessDigiEvent1(trigDate-nbAv,i);

              end;
            oldw1:=wSampleR[0];
          end
      end
    else
      begin
        if (i-trigDate>=nbAp) then
        begin
          Ftrig:=false;
          if assigned(PCLbuf)  and (i-trigDate=nbAp) then StorePCLEvent(-1,0)
          else
          if (DigiEventCh0>=0) and (i-trigDate=nbAp) then StoreDigiEvent(-1);

        end
        else
        begin
          storeWSample;
          if assigned(PCLbuf) then ProcessPCLEvent1(trigDate-nbAv,i)
          else
          if DigiEventCh0>=0 then ProcessDigiEvent1(trigDate-nbAv,i);
          
        end;
        if (i mod nbvoie=VoieSync-1) then oldw1:=wSampleR[0];
      end;
  end;
  GI1:=GI2;

end;

procedure TNIboard.StoreDigiEvent(ttt: double);
begin
//  affdebug('storeDigiEvent GIdig='+Istr(GIdig)+'    '+Istr(n),101);
  DigEvtBuf.StoreLong( round(ttt*1000000));
end;

procedure TNIboard.ProcessDigiEvent(it:integer);
var
  tt:double;
  i:integer;
  w:double;
begin
  tt:=(it div nbvoie)*FperiodIn/1000;       { temps absolu en osecondes }

  w:= DigBuffer^[GIdig mod DigBufferSize].t /PCLclockFrequency;
  while (GIdig<PdigBuffer) and (w< tt) do
  begin
    storeDigiEvent(w);
    inc(GIdig);
    w:= DigBuffer^[GIdig mod DigBufferSize].t /PCLclockFrequency;
  end;
end;

procedure TNIboard.ProcessDigiEvent1(it1, it2: integer);  { it1 est le début de l'épisode }
var
  tt1,tt2:double;
  i:integer;
  w:double;
begin
  tt1:= (it1 div nbvoie)*FperiodIn/1000;       { temps absolu en secondes }
  tt2:= (it2 div nbvoie)*FperiodIn/1000;       { temps absolu en secondes }


  w:= DigBuffer^[GIdig mod DigBufferSize].t /PCLclockFrequency ;
  while (GIdig<PdigBuffer) and (w< tt2) do
  begin
    if (w>= tt1) and (w< tt2)  then storeDigiEvent(w-tt1);
    inc(GIdig);
    w:= DigBuffer^[GIdig mod DigBufferSize].t /PCLclockFrequency;
  end;

end;

procedure TNIboard.StorePCLEvent(tt:double; xy: integer);
var
  R,theta:double;
  x,y:integer;
Const
  last: double=0;

  Ymask = 1 shl 10 -1;             // Y sur les dix premiers bits
  Xmask = Ymask shl 10;            // X sur les 10 suivants

begin
  // Pour tester, x et y sont fabriqués

  {$IFDEF PCLTEST}
    R:= 100/(abs(tt-last)+1)*random;
    last:=tt;
    while R>200 do R:=R*0.9;
    theta:=random*2*pi;
    x:=round(R*cos(theta)+200);
    y:=round(R*sin(theta)+200);

  {$ELSE}
    x:= (xy and Xmask) shr 10;
    y:= xy and Ymask;

  {$ENDIF}

  PCLBuf.StoreRec(tt,x,y);
end;

procedure TNIboard.ProcessPCLEvent(it:integer);
var
  tt:double;
  i:integer;
  w:double;
  x,y:integer;
  rec: TXYTrecord;
begin
  tt:=(it div nbvoie)*FperiodIn/1000;       { temps absolu en secondes }

  rec:= DigBuffer^[GIdig mod DigBufferSize];
  w:= rec.t;

  while (GIdig<PdigBuffer) and (rec.t< tt) do
  begin
    storePCLEvent(rec.t,rec.xy);
    inc(GIdig);
    rec:= DigBuffer^[GIdig mod DigBufferSize];
  end;
end;

procedure TNIboard.ProcessPCLEvent1(it1, it2: integer);  { it1 est le début de l'épisode }
var
  tt1,tt2:double;
  i:integer;
  rec: TXYTrecord;
  x,y:integer;
begin
  tt1:= (it1 div nbvoie)*FperiodIn/1000;       { temps absolu en secondes }
  tt2:= (it2 div nbvoie)*FperiodIn/1000;       { temps absolu en secondes }

  if PhotonMode=2 then ReceiveTCPIP1(tt1,tt2)
  else
  begin
    rec:=DigBuffer^[GIdig mod DigBufferSize];
    while (GIdig<PdigBuffer) and (rec.t< tt2) do
    begin
      if (rec.t>= tt1) and (rec.t< tt2)  then storePCLevent(rec.t-tt1,rec.xy);
      inc(GIdig);
      rec:=DigBuffer^[GIdig mod DigBufferSize];
    end;
  end;  
end;


procedure TNIboard.DoContinuous;
var
  i:integer;
begin
  GI2:=getCount-1;

  for i:=GI1+1 to GI2 do
  begin
    nextSample;
    storeWsample;
  end;
  if PhotonMode=1 then ProcessPCLEvent(GI2)
  else
  if PhotonMode=2 then receiveTCPIP
  else
  if DigiEventCh0>=0 then ProcessDigiEvent(GI2);

  GI1:=GI2;
end;

procedure TNIboard.doInterne;
var
  i,k:integer;
  istart,istart2:integer;
begin
  GI2:=getCount-1;

  for i:=GI1+1 to GI2 do
  begin
    k:=i mod isiSize1;
    nextSample;
    if (k>=0) and (k<EpSize1) then storeWsample;
  end;

  if assigned(PCLbuf) and (PhotonMode=1) then
  begin
    istart:=((GI1+1) div isiSize1)*isiSize1;
    for i:=GI1+1 to GI2 do
    begin
      k:=i mod isiSize1;

      if k=0 then istart:=i
      else
      if (k=EpSize1-1) then
      begin
        ProcessPCLEvent1(istart,i);
        StorePCLEvent(-1,0);
        istart:=-1;
      end
      else
      if k>=EpSize1 then istart:=-1;
    end;
    if istart>=0 then ProcessPCLEvent1(istart,GI2 );
  end
  else
  if assigned(PCLbuf) and (PhotonMode=2) then
  begin
    istart:=((GI1+1) div isiSize1)*isiSize1;
    istart2:=   (GI2 div isiSize1)*isiSize1;

    ProcessPCLEvent1(istart,istart+ EpSize1 );
    if istart2<>istart then
    begin
      StorePCLEvent(-1,0);
      affdebug('store0 '+ Istr(istart+ EpSize1),81);
      ProcessPCLEvent1(istart2,istart2+EpSize1 );
    end
    else
    if GI2=Istart+IsiSize1-1 then
    begin
      StorePCLEvent(-1,0);
      affdebug('store0',81)
    end;
  end
  else
  if DigiEventCh0>=0 then
  begin
    istart:=((GI1+1) div isiSize1)*isiSize1;
    for i:=GI1+1 to GI2 do
    begin
      k:=i mod isiSize1;

      if k=0 then istart:=i
      else
      if (k=EpSize1-1) then
      begin

        ProcessDigiEvent1(istart,i);
        StoreDigiEvent(-1);
        istart:=-1;
      end
      else
      if k>=EpSize1 then istart:=-1;
    end;
    if istart>=0 then ProcessDigiEvent1(istart,GI2 );
  end;



  GI1:=GI2;
  {
  ProcessPCL:
    lire les buffers compteur et XY
    if (tt>=TimeSeq) and (tt<=TimeSeq+DureeSeq)
      appeler PCLbuf.storeRec(tt-TimeSeq,X,Y);
    tt: réel en secondes, origine début épisode.
    On range en négatif le temps absolu du début de l'épisode
    au début de chaque épisode .

  }
end;

function TNIboard.IsWaitingTrig: boolean;
begin
  result:= FwaitInternalTrig;
end;

function TNIboard.getDetLine(n:integer): AnsiString;
begin
  result:=LongToHexa(DIbuffer^[n]);
end;

procedure TNIboard.TestChangeDetect;
var
  nsamples:integer;
  Nread, Nread1:integer;
  viewer: TListGViewer;
  taskHandle0, taskHandle1: TtaskHandle;
  data,data1:Ptabword;
  i:integer;
  Nwritten:integer;
begin
  nsamples:=1000000;
  getmem(data,nsamples*2);
  getmem(data1,nsamples*2);

  { Génération d'un signal d'horloge avec ctr1 }
  EnterNI;
  status:=DAQmxCreateTask('Test1',@taskHandle1);
  LeaveNI;stopError(1);

  EnterNI;
  DAQmxSetCOPulseTerm(taskHandle1, '/Dev2/ctr1', '/Dev2/port0/line1');    { Fixe la sortie de ctr1 sur port0/line1 au lieu de PFI13 }
  LeaveNI;stopError;                                                      { doit être appelé en premier }


  EnterNI;               // Signal à 10 Hz
  status:=DAQmxCreateCOPulseChanFreq(taskHandle1,'Dev2/ctr1','',DAQmx_Val_Hz,DAQmx_Val_Low, 0 ,10 ,0.50);
  LeaveNI; stopError;


  EnterNI;
  status:=DAQmxCfgImplicitTiming(taskHandle1,DAQmx_Val_ContSamps,1000);
  LeaveNI;stopError;


  EnterNI;
  status:=DAQmxStartTask(taskHandle1);
  LeaveNI;stopError;

  {****************************************************************************************}

  (*
  EnterNI;
  status:= DAQmxCreateTask('', @AItaskHandle);     { Créer la tâche  AI }
  LeaveNI; StopError;

  EnterNI;
  status:= DAQmxCreateAIVoltageChan(AItaskHandle,'Dev2/ai0','',SingleDiff,-10.0,10.0,DAQmx_Val_Volts,Nil); { Les canaux }
  LeaveNI; StopError;

  EnterNI;
  status:= DAQmxCfgSampClkTiming(AItaskHandle,'',100,DAQmx_Val_Rising, DAQmx_Val_ContSamps, 1000 );            { L'horloge est interne }
  LeaveNI;
  StopError;

  EnterNI;
  status:= DAQmxStartTask(AItaskHandle);
  LeaveNI; StopError;

  {******************}

  EnterNI;
  status:= DAQmxCreateTask('',@DOtaskHandle); { La tâche DO}
  LeaveNI;
  StopError;

  EnterNI;
  status:= DAQmxCreateDOChan(DOtaskHandle,'Dev2/port0/line4:7' ,'',DAQmx_Val_ChanForAllLines);
  LeaveNI;
  StopError;

  EnterNI;
  status:= DAQmxCfgSampClkTiming(DOtaskHandle,'/Dev2/ai/SampleClock',10000,DAQmx_Val_Rising,DAQmx_Val_ContSamps,1000);
  LeaveNI;
  StopError;

  EnterNI;
  status:= DAQmxWriteDigitalU16 (DOtaskHandle, Nsamples,false, 1, DAQmx_Val_GroupByChannel,
             @data1[0],  @NWritten, nil);
  LeaveNI;
  StopError;


  EnterNI;
  status:= DAQmxStartTask(DOtaskHandle);
  LeaveNI; StopError;

  *)
  {****************************************************************************************}
  EnterNI;
  status:= DAQmxCreateTask('Test0',@taskHandle0); { La tâche Detection changements  sur Port0}
  LeaveNI; StopError;

  EnterNI;         {Acquisition des lignes synchronisées (P0) 8 lignes sur 6251, 16 sur 6229 ou 6259 ou 6353 }
  status:= DAQmxCreateDIChan(taskHandle0, 'Dev2/port0/line0:3','',DAQmx_Val_ChanForAllLines);
  LeaveNI; StopError;

  EnterNI;         { On indique sur quelles lignes on détecte les changements }
  status:= DAQmxCfgChangeDetectionTiming(taskHandle0,'Dev2/port0/line1','',DAQmx_Val_ContSamps,1000);
  LeaveNI; StopError;

  EnterNI;         { C'est tout }
  status:= DAQmxStartTask(taskHandle0);
  LeaveNI; StopError;

  delay(1000);

  EnterNI;
  status:= DAQmxReadDigitalU16 (taskHandle0, -1, DAQmx_Val_WaitInfinitely, DAQmx_Val_GroupByChannel, @data[0], nSamples, @Nread, nil);
  LeaveNI; StopError;

  EnterNI;
//  status:= DAQmxReadDigitalU16 (DItaskHandle, -1, DAQmx_Val_WaitInfinitely, DAQmx_Val_GroupByChannel, @data1[0], nSamples, @Nread1, nil);
  LeaveNI; StopError;


  FreeAtaskHandle(taskHandle1,101);
  FreeAtaskHandle(taskHandle0,102);
  (*
  FreeAtaskHandle(DOtaskHandle,103);
  FreeAtaskHandle(AItaskHandle,104);
  *)
  DisplayErrorMsg;
  messageCentral('samps='+Istr(Nread)+'   samps='+Istr(Nread1));

  viewer:= TListGViewer.create(nil);
  with viewer.ListBox1 do
  begin
    style:=lbStandard;
    items.clear;
    items.Add('Detections='+Istr(Nread));
    for i:=1 to 10 do items.Add(Istr(data^[i-1]));

    items.Add('Detections1='+Istr(Nread1));
    for i:=1 to 10 do items.Add(Istr(data1^[i-1]));
  end;
  viewer.ShowModal;
  viewer.free;

  freemem(data);
  freemem(data1);
end;


procedure TNIboard.TestDetectEvent;
var
  data:PtabLongword;
  NbRead:integer;
  viewer: TListGViewer;
  i,max:integer;
const
  taskHandle0: TtaskHandle=0;
  taskHandle1: TtaskHandle=0;

begin
  {***************************** Programmation de ctr1 *****************************}
  { Génère un signal d'horloge }
  EnterNI;
  status:=DAQmxCreateTask('Test1',@taskHandle1);
  LeaveNI;stopError(1);


  EnterNI;               // Horloge à 1 MHz
  status:=DAQmxCreateCOPulseChanFreq(taskHandle1,'Dev2/ctr1','',DAQmx_Val_Hz,DAQmx_Val_Low, 0 ,1000000 ,0.50);
  LeaveNI; stopError;

  EnterNI;
  DAQmxSetCOPulseTerm(taskHandle1, '/Dev2/ctr1', '/Dev2/pfi8');    { Fixe la sortie de ctr1 sur PFI8 au lieu de PFI13 }
  LeaveNI;stopError;                                               { doit être appelé après DAQmxCreateCOPulseChanFreq }

  EnterNI;
  status:=DAQmxCfgImplicitTiming(taskHandle1,DAQmx_Val_ContSamps,1000);
  LeaveNI;stopError;


  EnterNI;
  status:=DAQmxStartTask(taskHandle1);
  LeaveNI;stopError;


  {******************************** Programmation de ctr0 *************************}

  EnterNI;
  status:= DAQmxCreateTask('Test0',@taskHandle0);
  LeaveNI; stopError;

  EnterNI;
  status:=DAQmxCreateCICountEdgesChan(taskHandle0,'Dev2/ctr0','',DAQmx_Val_Rising,0,DAQmx_Val_CountUp);
  LeaveNI; stopError;

  EnterNI;
  status:=DAQmxSetCICountEdgesTerm(taskHandle0,'/Dev2/ctr0','/Dev2/PFI8');      { Fixe l'horloge de ctr0 }
  LeaveNI; stopError;                                                           { Doit être placé après DAQmxCreateCICountEdgesChan !!! }

  EnterNI;
  status:=DAQmxCfgSampClkTiming(taskHandle0,'/Dev2/PFI9',1000000 ,DAQmx_Val_Rising,DAQmx_Val_ContSamps,1000000);
                   // PFI9 est l'entrée strobe  ==> OK
                   // 1000000 samples/sec max
                   // 1000000 samples in buffer
  LeaveNI; stopError;

  EnterNI;
  status:=DAQmxStartTask(taskHandle0);
  LeaveNI; stopError;

  Delay(1000);

  getmem(data,10000);
  EnterNI;
  status:=DAQmxReadCounterU32(taskHandle0,-1,10.0,@data^[0],1000,@NbRead,Nil);
  LeaveNI;  stopError;

  FreeAtaskHandle(taskHandle0,1);
  FreeAtaskHandle(taskHandle1,1);


  DisplayErrorMsg;

  viewer:= TListGViewer.create(nil);
  max:=10 ;
  if NbRead<max then max:=NbRead;
  with viewer.ListBox1 do
  begin
    style:=lbStandard;
    items.clear;
    items.Add('Detections='+Istr(NbRead));
    for i:=1 to max do items.Add(Istr(data^[i-1]));
  end;
  viewer.ShowModal;
  viewer.free;

  freemem(data);
end;



procedure TNIboard.TestDetectAndChange;
var
  data,data1:PtabLongword;
  Nsamples:integer;
  NbRead,NbRead1:integer;

  viewer: TListGViewer;
  i,max:integer;
  st:AnsiString;
  tt:integer;
  st1,st2:string;
const
  taskHandle: array[0..2] of TtaskHandle=(0,0,0);

begin
  nsamples:=1000000;  //taille buffers

  getmem(data,nsamples*4);
  fillchar(data^,nsamples*4,0);

  getmem(data1,nsamples*4);
  fillchar(data1^,nsamples*4,0);

  {***************************** Programmation de ctr1 *****************************}
  { Génère un signal d'horloge }
  EnterNI;
  status:=DAQmxCreateTask('Test1',@taskHandle[1]);
  LeaveNI;stopError(1);


  EnterNI;               // Horloge à 1 MHz
  status:=DAQmxCreateCOPulseChanFreq(taskHandle[1],PansiChar(''+DevName+'/ctr1'),'',DAQmx_Val_Hz,DAQmx_Val_Low, 0 ,1000000 ,0.50);
  LeaveNI; stopError;



  EnterNI;
  st1:='/'+DevName+'/ctr1';
  st2:='/'+DevName+'/pfi8';
  DAQmxSetCOPulseTerm(taskHandle[1], PansiChar(st1), PansiChar(st2));    { Fixe la sortie de ctr1 sur PFI8 au lieu de PFI13 }
  LeaveNI;stopError;                                                 { doit être appelé après DAQmxCreateCOPulseChanFreq }

  EnterNI;
  status:=DAQmxCfgImplicitTiming(taskHandle[1],DAQmx_Val_ContSamps,100000);
  LeaveNI;stopError;

  {******************************** Programmation de ctr0 *************************}

  EnterNI;
  status:= DAQmxCreateTask('Test0',@taskHandle[0]);
  LeaveNI; stopError;

  EnterNI;
  st1:=DevName+'/ctr0';
  status:=DAQmxCreateCICountEdgesChan(taskHandle[0],@st1[1],'',DAQmx_Val_Rising,0,DAQmx_Val_CountUp);

  LeaveNI; stopError;

  EnterNI;
  status:=DAQmxSetCICountEdgesTerm(taskHandle[0],PansiChar('/'+DevName+'/ctr0'),PansiChar('/'+DevName+'/PFI8'));      { Fixe l'horloge de ctr0 }
  LeaveNI; stopError;                                                           { Doit être placé après DAQmxCreateCICountEdgesChan !!! }

  EnterNI;
  status:=DAQmxCfgSampClkTiming(taskHandle[0],PansiChar('/'+DevName+'/PFI9'),1000000 ,DAQmx_Val_Rising,DAQmx_Val_ContSamps,1000000);
                   // PFI9 est l'entrée strobe  ==> OK
                   // 1000000 samples/sec max
                   // 1000000 samples in buffer
  LeaveNI; stopError;


  {********************************  La tâche Change Detect  sur Port0 ************************************}
  EnterNI;
  status:= DAQmxCreateTask('Test2',@taskHandle[2]);
  LeaveNI; StopError;

  EnterNI;         {Acquisition des lignes synchronisées (P0) 8 lignes sur 6251, 16 sur 6229 ou 6259 ou 6353 }
  status:= DAQmxCreateDIChan(taskHandle[2], PansiChar(''+DevName+'/port0/line0:3'),'',DAQmx_Val_ChanForAllLines);
  LeaveNI; StopError;

  EnterNI;         { On indique sur quelles lignes on détecte les changements }
  status:= DAQmxCfgChangeDetectionTiming(taskHandle[2],{''+DevName+'/port0/line0'}PansiChar('/'+DevName+'/PFI9'),'',DAQmx_Val_ContSamps,1000000);
  LeaveNI; StopError;

  {********************************* Trigger *****************************************************************}
  for i:=0 to 1 do
  begin
    EnterNI;
    status:=DAQmxSetArmStartTrigType(taskHandle[i], DAQmx_Val_DigEdge);
    LeaveNI;stopError;

    EnterNI;
    status:=DAQmxSetDigEdgeArmStartTrigSrc(taskHandle[i],PansiChar('/'+DevName+'/PFI9'));
    LeaveNI;stopError;
  end;

  {********************************* Démarrer les tâches ***********************************************************}
  for i:=0 to 2 do
  begin
    EnterNI;
    status:= DAQmxStartTask(taskHandle[i]);
    LeaveNI; StopError;
  end;

 {************************************* Wait ************************************************************************}

//  messageCentral('Wait');
  delay(1000);

 {************************************* Relever les data ************************************************************}
  EnterNI;
  status:=DAQmxReadCounterU32(taskHandle[0],-1,DAQmx_Val_WaitInfinitely,@data1^[0],nSamples,@NbRead1,Nil);
  LeaveNI; StopError;

  EnterNI;
  status:= DAQmxReadDigitalU32 (taskHandle[2], -1, DAQmx_Val_WaitInfinitely, DAQmx_Val_GroupByChannel, @data[0], nSamples, @Nbread, nil);
  LeaveNI; StopError;

  for i:=0 to 2 do FreeAtaskHandle(taskHandle[i],1);

  DisplayErrorMsg;

  viewer:= TListGViewer.create(nil);

  if NbRead<Nbread1 then max:=NbRead1 else max:=Nbread;
  if max>2000 then max:=2000;

  with viewer.ListBox1 do
  begin
    style:=lbStandard;
    items.clear;
    items.Add('Det='+Istr(NbRead) + '    Det1='+Istr(NbRead1));
    for i:=1 to max do
    begin
      if i>1 then tt:=data1^[i-1]-data1^[i-2]
             else tt:=0;
      st:=Istr1(i,4)+'  '+Istr(data^[i-1])+'    '+Istr1(data1^[i-1],8)+'  '+ Istr1(tt,10);
      items.Add(st);
    end;
  end;
  viewer.ShowModal;
  viewer.free;

  freemem(data);
  freemem(data1);
end;



procedure TNIboard.TestDetectAndChange1;
var
  data, data1:PtabLongword;
  Nsamples:integer;
  NbRead,NbRead1:integer;

  viewer: TListGViewer;
  i,max:integer;
  st:AnsiString;
  tt:integer;
const
  taskHandle: array[0..2] of TtaskHandle=(0,0,0);

begin
  nsamples:=1000000;  //taille buffers

  getmem(data,nsamples*4);
  fillchar(data^,nsamples*4,0);

  getmem(data1,nsamples*4);
  fillchar(data1^,nsamples*4,0);

  {***************************** Programmation de ctr1 *****************************}


  { Génère un signal d'horloge }
  EnterNI;
  status:=DAQmxCreateTask('Test1',@taskHandle[1]);
  LeaveNI;stopError(1);


  EnterNI;               // Horloge à 1 MHz
  status:=DAQmxCreateCOPulseChanFreq(taskHandle[1],'/Dev2/ctr1','',DAQmx_Val_Hz,DAQmx_Val_Low, 0 ,1000000 ,0.50);
  LeaveNI; stopError;



  EnterNI;
  DAQmxSetCOPulseTerm(taskHandle[1], '/Dev2/ctr1', '/Dev2/pfi8');    { Fixe la sortie de ctr1 sur PFI8 au lieu de PFI13 }
  LeaveNI;stopError;                                               { doit être appelé après DAQmxCreateCOPulseChanFreq }

  EnterNI;
  status:=DAQmxCfgImplicitTiming(taskHandle[1],DAQmx_Val_ContSamps,100000);
  LeaveNI;stopError;

  {******************************** Programmation de ctr0 *************************}

  EnterNI;
  status:= DAQmxCreateTask('Test0',@taskHandle[0]);
  LeaveNI; stopError;

  EnterNI;
  status:=DAQmxCreateCICountEdgesChan(taskHandle[0],'/Dev2/ctr0','',DAQmx_Val_Rising,0,DAQmx_Val_CountUp);
  LeaveNI; stopError;

  EnterNI;
  status:=DAQmxSetCICountEdgesTerm(taskHandle[0],'/Dev2/ctr0','/Dev2/PFI8');      { Fixe l'horloge de ctr0 }
  LeaveNI; stopError;                                                           { Doit être placé après DAQmxCreateCICountEdgesChan !!! }

  EnterNI;
  status:=DAQmxCfgSampClkTiming(taskHandle[0],'/Dev2/PFI9',1000000 ,DAQmx_Val_Rising,DAQmx_Val_ContSamps,1000000);
                   // PFI9 est l'entrée strobe  ==> OK
                   // 1000000 samples/sec max
                   // 1000000 samples in buffer
  LeaveNI; stopError;


  {********************************  La tâche Change Detect  sur Port0 ************************************}
  EnterNI;
  status:= DAQmxCreateTask('Test2',@taskHandle[2]);
  LeaveNI; StopError;

  EnterNI;         {Acquisition des lignes synchronisées (P0) 8 lignes sur 6251, 16 sur 6229 ou 6259 ou 6353 }
  status:= DAQmxCreateDIChan(taskHandle[2], '/Dev2/port0/line0:3','',DAQmx_Val_ChanForAllLines);
  LeaveNI; StopError;

  EnterNI;         { On indique sur quelles lignes on détecte les changements }
  status:= DAQmxCfgChangeDetectionTiming(taskHandle[2],{'Dev2/port0/line0'}'/Dev2/PFI9','',DAQmx_Val_ContSamps,1000000);
  LeaveNI; StopError;

  {********************************* Trigger *****************************************************************}
  for i:=0 to 1 do
  begin
    EnterNI;
    status:=DAQmxSetArmStartTrigType(taskHandle[i], DAQmx_Val_DigEdge);
    LeaveNI;stopError;

    EnterNI;
    status:=DAQmxSetDigEdgeArmStartTrigSrc(taskHandle[i],'/Dev2/PFI9');
    LeaveNI;stopError;
  end;

  {********************************* Démarrer les tâches ***********************************************************}
  for i:=0 to 2 do
  begin
    EnterNI;
    status:= DAQmxStartTask(taskHandle[i]);
    LeaveNI; StopError;
  end;

 {************************************* Wait ************************************************************************}

//  messageCentral('Wait');
  delay(1000);

 {************************************* Relever les data ************************************************************}
  EnterNI;
  status:=DAQmxReadCounterU32(taskHandle[0],-1,DAQmx_Val_WaitInfinitely,@data1^[0],nSamples,@NbRead1,Nil);
  LeaveNI; StopError;

  EnterNI;
  status:= DAQmxReadDigitalU32 (taskHandle[2], -1, DAQmx_Val_WaitInfinitely, DAQmx_Val_GroupByChannel, @data[0], nSamples, @Nbread, nil);
  LeaveNI; StopError;

  for i:=0 to 2 do FreeAtaskHandle(taskHandle[i],1);

  DisplayErrorMsg;

  viewer:= TListGViewer.create(nil);

  if NbRead<Nbread1 then max:=NbRead1 else max:=Nbread;
  if max>2000 then max:=2000;

  with viewer.ListBox1 do
  begin
    style:=lbStandard;
    items.clear;
    items.Add('Det='+Istr(NbRead) + '    Det1='+Istr(NbRead1));
    for i:=1 to max do
    begin
      if i>1 then tt:=data1^[i-1]-data1^[i-2]
             else tt:=0;
      st:=Istr1(i,4)+'  '+Istr(data^[i-1])+'    '+Istr1(data1^[i-1],8)+'  '+ Istr1(tt,10);
      items.Add(st);
    end;
  end;
  viewer.ShowModal;
  viewer.free;

  freemem(data);
  freemem(data1);
end;



function TNIboard.CanAcqPhotons: boolean;
begin
  result:=true;  { = Board is PCI 6353 }
end;

procedure TNIboard.setDOStatic(v1, v2: boolean);
var
  buf: array[0..15] of boolean;
  sampsPerChanWritten: integer;
begin
  fillchar(buf,sizeof(buf),1);
  buf[0]:=v1;
  buf[1]:=v2;

  EnterNI;
  status:= DAQmxWriteDigitalLines (DOstaticHandle, 1,false, 1, DAQmx_Val_GroupByChannel,
           @buf,  @sampsPerChanWritten, nil);
  LeaveNI;
  if stopError(802) then exit;

end;

procedure TNIboard.ReceiveTCPIP;
var
  buffer: Tbuffer;
  i,N:integer;
  tb: PtabPCLrecord;
begin
  repeat
    buffer:=TCPIPserver.getBuffer;
    if assigned(buffer) then
    begin
      getmem(tb,buffer.dataSize);
      buffer.resetIndex;
      buffer.read(tb^,buffer.dataSize,AcqInf.TCPIPswapBytes);
      N:=buffer.DataSize div sizeof(TPCLrecord);

      for i:=0 to N-1 do
        with tb^[i] do PCLbuf.storeRec(time-PhotonTime0,x,y);

      freemem(tb);
      buffer.free;
    end;
  until buffer=nil;
end;

procedure TNIboard.ReceiveTCPIP1(tt1,tt2:float);
var
  buffer: Tbuffer;
  i,N:integer;
  tb: PtabPCLrecord;
  tt:double;
begin
  affdebug('ReceiveTCPIP '+Estr1(tt1,10,3)+Estr1(tt2,10,3),81);
  repeat
    buffer:=TCPIPserver.getBuffer;
    if assigned(buffer) then
    begin
      getmem(tb,buffer.dataSize);
      buffer.resetIndex;
      buffer.read(tb^,buffer.dataSize);
      N:=buffer.DataSize div sizeof(TPCLrecord);

      for i:=0 to N-1 do
        with tb^[i] do
        begin
          if AcqInf.TCPIPswapBytes then convert;
          tt:= time-PhotonTime0;
          if (tt>=tt1) and (tt<tt2)
            then PCLbuf.storeRec(tt-tt1,x,y,z);
          if i=0 then affdebug('tcpip1 tt='+Estr1(tt,10,3),81);
          if i=N-1 then affdebug('tcpip1 tt='+Estr1(tt,10,3),81);

        end;

      freemem(tb);
      buffer.free;
    end;
  until buffer=nil;
end;


function TNIboard.TestPhotonTime(PacketDuration:float):float;
var
  buffer: Tbuffer;
  i,N:integer;
  Arec1,Arec2: TPCLrecord;
  tt: longword;

begin
  if not assigned(TCPIPserver) then
  begin
    result:=0;
    exit;
  end;

  TCPIPserver.Fprivate:=true;
  repeat
    buffer:=TCPIPserver.getBuffer;
  until assigned(buffer) or TestEscape;
  TCPIPserver.Fprivate:=false;

  if assigned(buffer) and (buffer.DataSize>2*sizeof(TPCLrecord)+4) then
  begin
    buffer.DataPosition:=0;
    buffer.read(Arec1,sizeof(TPCLrecord));
    if AcqInf.TCPIPswapBytes then Arec1.convert;

    buffer.DataPosition:=buffer.DataSize-sizeof(TPCLrecord) -4;
    buffer.read(Arec2,sizeof(TPCLrecord));
    if AcqInf.TCPIPswapBytes then Arec2.convert;

    buffer.read(tt,sizeof(tt));
    PhotonSystemTime:=tt/1000;           // PC time in seconds
    PhotonPCLTime:=Arec2.time;           // Estimated PCL time

    buffer.free;

    result:=PacketDuration- (Arec2.time-Arec1.time)*1000;
  end
  else result:=0;

end;


initialization
Affdebug('Initialization NIbrd1',0);
initNIboards;

end.
