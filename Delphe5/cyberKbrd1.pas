unit cyberKbrd1;

interface
{$IFDEF FPC} {$mode delphi} {$DEFINE AcqElphy2} {$A1} {$Z1} {$ENDIF}

(*
      Frequency = 30000  Hz
      ChanCount = 156
      BankCount = 10
      groupcount= 8

      Channels  1 - 32   Front End A               32
      Channels 33 - 64   Front End B               32
      Channels 65 - 96   Front End C               32
      Channels 97 - 128  Front End D               32

      Channels 129 - 144 Analog inputs             16
      Channels 145 - 148 Analog outputs             4

      Channels 149 - 150 AUDIO outputs              2

      Channel  151   16 bits digital input          1

      Channel  152  RS-232 Serial I/O Module        1

      Channels  153 - 156 Single Bit Digital Output 4

      GROUPS:

        1: Not Available  period = 60
        2: 1 kS/s         period = 30
        3: 2 kS/s         period = 15
        4: 10 kS/s        period =  3
        5: 30 kS/s        period =  1
        6: 30 kS/s        period =  1
        7: 30 kS/s        period =  1
        8: 30 kS/s        period =  1


      On relie Dout4 à Din15
      Dout4 est une BNC sur le front panel
      Les Din sont sur le connecteur 37 broches du front panel
      Rangée du haut
        1 Data strobe
        2 Din0
        ...
        17 Din15
        18 EOP
        19 SYN
      Rangée du bas 20 à 37 = Ground

      En mode continu, ou seq immédiat-interne , on envoie un pulse sur Dout4,
      ce pulse est envoyé sur Din15
      En mod seq-trigger numérique, le pulse est envoyé sur Din0


*)


uses windows,classes,math,sysutils,
     util1,varconf1,Gdos,
     debug0,
     stmdef,AcqBrd1,stimInf2,
     dataGeneFile,FdefDac2,
     Ncdef2,
     acqCom1, AcqInterfaces,
     acqDef2,acqInf2,
     cyberK2,
     stmObj,stmNI;


var
  FlagCyberKexists: boolean;
  TestCentralSim: boolean;
var
  NItest: TNIinterface;

type
  TCyberKinterface = class(TacqInterface)
  protected
    status:integer;
    Fwaiting:boolean;
    nextSeq:integer;

    StatusStep:integer;
    LastErrorStatus:integer;
    stError:AnsiString;

    HasDigInputs:boolean;  {toujours True }

    GroupNbCh: array[2..5] of integer;           // groupe 5 ajouté le 19-03-2015
    GroupToCh: array[2..5] of array of integer;  // id


    nbElec: integer;
    nbvAcq:integer;
    nbvAna:integer;
    nbvSpk:integer;
    QKS:array[1..255] of integer;

    IsON:boolean;
    TimeInit:integer;
    IsiK,nbptK:integer;

    TimeSeq:integer;
    NbSeq:integer;

    mskSync:word;
    FwaitNumTrig:boolean;
    FwaitStateUp:boolean;

    ffLog:TfileStream;
    LastDin:word;

    refGroup, cntDispInc: integer;

    CBisOpen: boolean;

    TestTime:integer;

    procedure ProcessPacketNumplus(p:PcbPKT_GENERIC);
    procedure doNumPlus;

    procedure ProcessPacketContinuous(p:PcbPKT_GENERIC);
    procedure doContinuous;

    procedure ProcessPacketInterne(p:PcbPKT_GENERIC);
    procedure doInterne;


    procedure relancer;override;
    procedure restartAfterWait;override;

    procedure ResetError;
    function StopError(n:integer):boolean;overload;
    procedure setStopError(st:AnsiString);
    function CheckCb(stat,n:integer):boolean;


    procedure DoNothing;
    function QKStoGroup(n:integer):integer;
    function GetAnalogCh(physNum1: integer):integer;

    procedure storeSample(ch:integer;w:smallint;time:integer);
    procedure storeSpike(p:pointer;ch:integer;time:integer;att:byte);           { ch= 1 à 32; att= unité }

    function setDout(num:integer;w:boolean):integer;override;

 protected
   FsimCyberK:boolean;

    procedure CyberDelay(ms:integer);virtual;
 public

    constructor create(var st1:driverString);override;
    destructor destroy;override;

    procedure init;override;
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

    procedure InstallQKS;override;
    function FixedPeriod:boolean; override;
    function getFixedPeriod:float; override;
    function ElphyFormatOnly:boolean;override;

    function DxuSpk:float; override;

    function UnitXspk:AnsiString; override;

    function getSampleIndex:integer;override;
    function nbVoieSpk:integer;override;

    procedure storeOtherPacket(p:pointer);
    procedure ConvertLog;

    function cbErrorString(n:integer):AnsiString;virtual;
  end;



implementation

uses CyberKsimBrd1;


function TCyberKinterface.cbErrorString(n:integer):AnsiString;
begin
  case n of
    cbRESULT_NOLIBRARY          : result:= 'The library was not properly initialized';
    cbRESULT_NOCENTRALAPP       : result:= 'Unable to access the central application';
    cbRESULT_LIBINITERROR       : result:= 'Error attempting to initialize library error';
    cbRESULT_MEMORYUNAVAIL      : result:= 'Not enough memory available to complete the operation';
    cbRESULT_INVALIDADDRESS     : result:= 'Invalid Processor or Bank address';
    cbRESULT_INVALIDCHANNEL     : result:= 'Invalid channel ID passed to function';
    cbRESULT_INVALIDFUNCTION    : result:= 'Channel exists, but requested function is not available';
    cbRESULT_NOINTERNALCHAN     : result:= 'No internal channels available to connect hardware stream';
    cbRESULT_HARDWAREOFFLINE    : result:= 'Hardware is offline or unavailable';
    cbRESULT_DATASTREAMING      : result:= 'Hardware is streaming data and cannot be configured';
    cbRESULT_NONEWDATA          : result:= 'There is no new data to be read in';
    cbRESULT_DATALOST           : result:= 'The Central App incoming data buffer has wrapped';
    cbRESULT_INVALIDNTRODE      : result:= 'Invalid NTrode number passed to function';

    else result:='';
  end;
end;


procedure initCyberKBoards;
begin
  if initCyberKdll('CyberK.dll') then
  begin
    registerBoard('CyberK',pointer(TCyberKinterface));
    FlagCyberKexists:=true;
  end;
  if initCyberKdll('CyberK37.dll') then
  begin
    registerBoard('CyberK 3.7',pointer(TCyberKinterface));
    FlagCyberKexists:=true;
  end;

  initCyberKsimBoards;
end;

{ TCyberKinterface }

constructor TCyberKinterface.create(var st1: driverString);
begin
  inherited;

  if st1='CyberK' then initCyberKdll('CyberK.dll');
  if st1='CyberK 3.7' then  initCyberKdll('CyberK37.dll');

  FmultiMainBuf:=TRUE;
  HasDigInputs:=true;
end;

destructor TCyberKinterface.destroy;
begin
  FmultiMainBuf:=false;
  if CBisOpen then CBclose;
  inherited;
end;


function TCyberKinterface.QKStoGroup(n:integer):integer;
begin
  if n=1 then result:=5  // ajouté le 19-03-2015
  else
  if n=3 then result:=4   { 10 kHz }          { n is the downsampling factor }
  else                                        { the function returns the group number }
  if n=15 then result:=3  { 2 kHz }
  else result:=2;         { 1 kHz }
end;

function TCyberKinterface.GetAnalogCh(physNum1: integer): integer;
var
  i:integer;
begin
  with AcqInf do
  for i:=1 to Qnbvoie do
  if (QvoieAcq[i]=PhysNum1) and (ChannelType[i]=TI_analog) then
  begin
    result:=i;
    exit;
  end;
  result:=-1;
end;

procedure TCyberKinterface.init;
var
  i,j:integer;
  group1,length1:integer;
  list1:array[0..255] of integer;
  label1:array[0..255] of char;
  period1:integer;
  st:AnsiString;
  lastAna,nt:integer;
  gr,fil:longword;
  len,pretrig,sysfreq:longword;
  Filter:array[0..150] of longword;
  Agroup:array[0..150] of longword;
  bb: array[0..150] of boolean;
  cnt: integer;
  res: integer;
  nbChanTot: integer;
begin
  Fwaiting:=false;
  ResetError;

  {Copier les variables utiles de AcqInf}
  nbElec:=acqInf.CyberElecCount;
  nbvAcq:=acqInf.nbvoieAcq;
  nbvAna:=acqInf.Qnbvoie;
  for i:=1 to AcqInf.Qnbvoie do
     QKS[i]:=AcqInf.QKS[i];
  QKS[AcqInf.Qnbvoie+1]:=1;

  nbvSpk:=nbVoieSpk;

  if not FsimCyberK then
  if not InitCyberKdll then
  begin
    setStopError('CyberK dll not initialized');
    exit;
  end;

  if not CBisOpen then
    begin
    cnt:=0;
    repeat
      status:=CBopen;
      if status<>0 then
      begin
        delay(20);
        inc(cnt);
        CBclose;
      end;
    until (status=0) or (cnt>10);
    if status<>0 then
      if not CheckCb( CBopen,101 ) then exit;
    CBisOpen:=true;
  end;

  checkCB(cbMakePacketReadingBeginNow,121);


  res:=cbSetSpikeLength(AcqInf.CyberWaveLen,AcqInf.PretrigWave);
  cnt:=0;
  repeat
    delay(2);
    res:=cbGetSpikeLength(@Len,@Pretrig,@sysFreq);
    inc(cnt);
  until (AcqInf.CyberWaveLen=Len) or (cnt>10);

  if (AcqInf.CyberWaveLen<>Len) then
  begin
    messageCentral('Unable to set Wavelen='+Istr(AcqInf.CyberWaveLen));
  end
  else
  if (res=0) and (len>=32) and (len<=128) and (pretrig>=0) and (pretrig<=128) then
  begin
    AcqInf.CyberWaveLen:=Len;
    AcqInf.PretrigWave:=pretrig;
  end;
  {messageCentral('Len='+Istr(len)+'  Pretrig='+Istr(pretrig));}
  { On suppose pour l'instant que toutes les voies sont analogiques
    QKS contient les bons facteurs de sous échantillonnage ( 3, 15 ou 30 )
    ces facteurs imposent le cyberGroupe, respectivement 4, 3 ou 2

    Il n'y a pas deux physNum identiques.
  }

  fillchar(Agroup,sizeof(Agroup),0);
  {Récupérer les valeurs de filtre}
  for i:=1 to 128 do
    cbGetAinpSampling( i, @filter[i], @Agroup[i]);    // pas de vérification
  for i:=129 to 144 do
    cbGetAinpSampling( i,@filter[i], @Agroup[i]);     // pas de vérification

  { Désactiver toutes les voies en gardant les filtres

  for i:=1 to 128 do
    cbSetAinpSampling( i, filter[i], 0) ;          // pas de vérification
  for i:=129 to 144 do
    cbSetAinpSampling( i, filter[i], 0);           // pas de vérification
  }

  { Programmer les voies }

  fillchar(bb,sizeof(bb),0);
  with AcqInf do
  for i:=1 to Qnbvoie do
  if ChannelType[i]=TI_analog then
  begin
     if Agroup[QvoieAcq[i]]<>QKStoGroup(QKS[i]) then
       if not CheckCb(cbSetAinpSampling( QvoieAcq[i], filter[QvoieAcq[i]], QKStoGroup(QKS[i])) ,104) then exit;
     lastAna:=i;
     bb[QvoieAcq[i]]:=true;
  end;

  for i:=1 to 128 do
  if not bb[i] and (Agroup[i]<>0) then
    cbSetAinpSampling( i, filter[i], 0);


  for i:=129 to 144 do
  if not bb[i] and (Agroup[i]<>0) then
    cbSetAinpSampling( i, filter[i], 0);



  {Avant de lire les infos groupe, il faut attendre que les modif précédentes soient effectives }
  gr:=1000;
  if nbvana>0 then
  repeat
     if not CheckCb(cbGetAinpSampling( AcqInf.QvoieAcq[lastAna], @fil, @gr) ,104) then exit;;
  until gr=QKStoGroup(QKS[lastAna]);

  refGroup:=0;
  for i:=2 to 5 do  // max=5 2015
  begin
    {if not CheckCb( cbGetSampleGroupInfo(  1, i, @label1,  @period1,  @length1) ,106 ) then exit;}
    if not CheckCb( cbGetSampleGroupList( 1, i, @length1, @list1[0] ), 107 ) then exit;

    setLength(GroupToCh[i],length1);
    GroupNbCh[i]:=length1;
    for j:=0 to length1-1 do GroupToCh[i][j]:=GetAnalogCh(list1[j]);

    if (refGroup=0) and (GroupNbCh[i]>0) then
    begin
      refGroup:=i;
      case i of
        2: cntDispInc:= 30;
        3: cntDispInc:= 10;
        4: cntDispInc:= 3;
        5: cntDispInc:= 1;
      end;
    end;
  end;


  {messageCentral('nt='+Istr(nt)+' '+Istr(QKS[1])+' '+Istr(QKS[2])+' '+Istr(QKS[3]) );}

  {Programmer les entrées digitales }
  if not CheckCB( cbSetDinpOptions( 151, cbDINP_16BIT + cbDINP_ANYBIT, 0 ),108) then exit;

  {Pour 32 électrodes, attendre 200 ms sinon des données seront perdues !! }

  delay(1000);                 // delai correspondant à 128 électrodes
  {delay(250*nbELEC div 32);}

  IsiK:=AcqInf.IsiPts div nbVacq;
  nbptK:=AcqInf.Qnbpt;
end;

procedure TCyberKinterface.terminer;
var
  res:integer;
begin
  ISON:=false;
  //checkCb( CBclose , 200 );
  ffLog.Free;
  ffLog:=nil;

  // convertLog;
end;

procedure TCyberKinterface.lancer;
var
  i:integer;
  w:word;

begin
  TimeInit:=0;
  TimeSeq:=-1;
  NbSeq:=0;
  cntDisp:=-1;  // était à 0 avant le 18 mai 2015 ==> écriture d'un 0 sur le premier point de v1

  cbMakePacketReadingBeginNow;

  if acqInf.continu or (acqInf.ModeSynchro in [MSimmediat,MSinterne]) then
  begin
    mskSync:=$8000;  {Test du bit15 } // Avant 28-01-14 ,  mskSync:=$C000;  bit15 et bit14 à 1 . Pourquoi ?

    SetDout(4,false);   { On sort une impulsion de 1 ms sur la sortie Digitale 4 }
    CyberDelay(5);
    SetDout(4,true);
    CyberDelay(5);
    SetDout(4,false);
  end
  else
  if not acqInf.continu and (acqInf.ModeSynchro in [ MSnumPlus,MSnumMoins ]) then
  begin
    mskSync:=1;  {Test du bit0 }
  end;

  FwaitNumTrig:=true;
  FwaitStateUp:=false;

  isON:=true;
//  ffLog:=TfileStream.Create(Appdata+'CyberLog.msg',fmCreate);
end;

procedure TCyberKinterface.relancer;
begin
  FwaitNumTrig:=true;
  FwaitStateUp:=false;
end;


function TCyberKinterface.ADCcount(dev: integer): integer;
begin
  result:=128;  { les numéros vont de 1 à 32 et de 129 à 144  }
end;

function TCyberKinterface.bitInCount(dev: integer): integer;
begin
  result:=16;
end;

function TCyberKinterface.bitOutCount(dev: integer): integer;
begin
  result:=8;
end;

function TCyberKinterface.channelRange: boolean;
begin
  result:=false;
end;

function TCyberKinterface.CheckParams: boolean;
begin
  result:=true;
end;


function TCyberKinterface.DACcount(dev: integer): integer;
begin
  result:=0;
end;

function TCyberKinterface.dacFormat: TdacFormat;
begin
  result:=DACF1322;
end;

function TCyberKinterface.dataFormat: TdataFormat;
begin
  result:=F16bits;
end;


function TCyberKinterface.deviceCount: integer;
begin
  result:=1;
end;

function TCyberKinterface.DigiInCount(dev: integer): integer;
begin
  result:=1;
end;

function TCyberKinterface.DigiOutCount(dev: integer): integer;
begin
  result:=1;
end;




function TCyberKinterface.gainLabel: AnsiString;
begin
  result:='';
end;


function TCyberKinterface.getMaxADC: integer;
begin
  result:=32767;
end;

function TCyberKinterface.getMinADC: integer;
begin
  result:=-32768;
end;

procedure TCyberKinterface.GetOptions;
begin

end;

procedure TCyberKinterface.GetPeriods(PeriodU: float; nbADC, nbDI, nbDAC,
  nbDO: integer; var periodIn, periodOut: float);

begin
  periodIn:=1/30;
  periodOut:=1/30;
end;


function TCyberKinterface.getValue(Device, tpIn, physNum: integer;
  var value: smallint): boolean;
begin

end;

function TCyberKinterface.inADC(n: integer): smallint;
begin

end;

function TCyberKinterface.inDIO(dev,port:integer): integer;
begin
  result:=0;
end;

procedure TCyberKinterface.initcfgOptions(conf: TblocConf);
begin
  with conf do
  begin
  end;
end;



function TCyberKinterface.MultiGain: boolean;
begin
  result:=false;
end;

function TCyberKinterface.nbGain: integer;
begin
  result:=1;
end;

function TCyberKinterface.nbVoieAcq(n: integer): integer;
begin
  result:=n;
end;


procedure TCyberKinterface.outdac(num, j: word);
begin
  inherited;

end;

function TCyberKinterface.outDIO(dev,port,value: integer): integer;
begin

end;

function TCyberKinterface.PeriodeElem: float;
begin
  result:=1;
end;

function TCyberKinterface.PeriodeMini: float;
begin
  result:=0;
end;

function TCyberKinterface.RAngeString: AnsiString;
begin
  result:='';
end;


procedure TCyberKinterface.restartAfterWait;
begin
  inherited;

end;

procedure TCyberKinterface.setDoAcq(var procInt: ProcedureOfObject);
begin
  if AcqInf.continu then ProcInt:=DoContinuous
  else
  case AcqInf.ModeSynchro of
    MSinterne,MSimmediat: ProcInt:=doInterne;
    MSnumPlus,MSnumMoins: ProcInt:=doNumPlus;
  end;
end;


function TCyberKinterface.setValue(Device, tpout, physNum,
  value: integer): boolean;
begin

end;

procedure TCyberKinterface.setVSoptions;
begin
  FuseTagStart:=true;
end;

function TCyberKinterface.TagCount: integer;
begin
  result:=16;
end;

function TCyberKinterface.TagMode: TtagMode;
begin
  if HasDigInputs
    then result:=tmCyberK
    else result:=tmNone;
end;

function TCyberKinterface.tagShift: integer;
begin
  result:=0;
end;


procedure TCyberKinterface.DisplayErrorMsg;
begin
  if LastErrorStatus<>0 then  messageCentral(stError);
end;

function TCyberKinterface.IsWaiting: boolean;
begin
  result:=FWaiting;
end;

function TCyberKinterface.StopError(n: integer):boolean;
begin
  result:=(status<>0);

  if result and (LastErrorStatus=0) then
  begin
    statusStep:=n;
    LastErrorStatus:=status;
    FlagStopPanic:=true;

    stError:='Step='+Istr(StatusStep)+' Status='+Istr(status)+crlf +cbErrorString(status);;
  end;
end;

procedure TCyberKinterface.setStopError(st: AnsiString);
begin
  statusStep:=1000;
  LastErrorStatus:=1000;
  FlagStopPanic:=true;

  stError:=st;
end;

procedure TCyberKinterface.ResetError;
begin
  LastErrorStatus:=0;
  stError:='';
end;


function TCyberKinterface.CheckCb(stat, n: integer): boolean;
begin
  status:=stat;
  result:=not StopError(n);
end;


procedure TCyberKinterface.DoNothing;
begin

end;

procedure TCyberKinterface.ProcessPacketNumplus(p:PcbPKT_GENERIC);
var
  pS:PtabEntier;
  i,k,group:integer;
  ch:integer;
  time1,NewTimeSeq, ElphyTime:integer;
  ok:boolean;
  w:word;
begin
  if not isON then exit;

  if not assigned(p) then exit;

  if FwaitNumTrig and (Fwaiting or (NbSeq=0) ) then
  begin
    if (p^.chid=151) then
    begin
      w:=PcbPKT_DINP(p)^.data[0];
      ok:= (w and MskSync<>0);

      if ok then
      begin
        TimeSeq:=p^.time;
        MultiCyberTagBuf.SetInitDins(p^.data[0]);

        inc(NbSeq);
        for i:=1 to nbVspk do storeSpike(nil,i,-timeSeq-1,0); { valeur négative en début de séquence }

        FwaitNumTrig:=false;
        Fwaiting:=false;

        AcqCybTime:=TimeSeq/30000;
        AcqPCtime:=GetTickCount;
      end;
    end
    else
    if TestCentralSim and (p^.chid = 0) and (p^.type1>=1) and (p^.type1<=5) and (getTickCount-testTime>10) then           { Analog Data type1=num groupe   max=5 le 19 mars 2015  }
    begin
      ok:=true;                             // On considère que le premier échantillon ana est le top synchro

      TimeSeq:=p^.time;
      MultiCyberTagBuf.SetInitDins(3);

      inc(NbSeq);
      for i:=1 to nbVspk do storeSpike(nil,i,-timeSeq-1,0); { valeur négative en début de séquence }

      FwaitNumTrig:=false;
      Fwaiting:=false;

      AcqCybTime:=TimeSeq/30000;
      AcqPCtime:=GetTickCount;

    end;               // Fin test CentralSim

  end;

  { Si un seul flag est en place, on ne fait rien }
  if not Fwaiting and not FwaitNumTrig then
  with p^ do
  begin
    time1:=time-timeSeq;

    if (time1>=0) and (time1<nbptK) then
    begin
      ElphyTime:=nbptK*(nbSeq-1)+time1;   { temps Elphy }

      if (chid=$8000) and (type1=0) then      { System Heartbeat Packet (sent every 10ms) }
      begin
        MultiCyberTagBuf.SetLastDins(ElphyTime-60,time1);
        cntDisp:=ElphyTime -60;           { On donne 2 ms de répit }
        if cntDisp<0 then cntDisp:=-1;
      end
      else
      if (chid = 0) and (type1>=2) and (type1<=5) then           { Analog Data type1=num groupe  max=5 le 19-03-2015 }
      begin
        group:=type1;
        pS:=@p^.data;

        for i:=0 to GroupNbCh[group]-1 do storeSample(GroupToCh[group,i],pS^[i], ElphyTime);

        cntDisp:=Elphytime-60;
        if cntDisp<0 then cntDisp:=-1;
      end
      else
      if (chid >0) and (chid<=nbVspk) and (type1>=0) and (type1<=5) then           { Spike Data  type1=Unit}
      begin
        storeSpike(p,chid,time1,type1);   { on stocke le temps relatif }
      end
      else
      if chid=151 then
        begin
          MultiCyberTagBuf.storeDins(data[0],ElphyTime,time1);
          LastDin:=data[0];
          //Affdebug('StoreDins='+Istr1(Data[0],8)+'  t= '+Istr(ElphyTime),79);
        end;
    end
    else
    if time1>=nbptK then
    begin
      ElphyTime:=nbptK*nbSeq-1;
//        MultiCyberTagBuf.setLastDins(ElphyTime+1,nbptK-1);
      Fwaiting:=true;
      cntDisp:=ElphyTime;
    end;
  end;

end;


procedure TCyberKinterface.doNumPlus;
var
  p:PcbPKT_GENERIC;
begin
  if not isON then exit;

  repeat
    p:=cbGetNextPacketPtr;
    if assigned(p) then ProcessPacketNumPlus(p);
  until (p=nil) or not isON ;

end;


type
  TsimplePacket=record
                  time: UINT32;
                  chid: UINT16;
                  type1: UINT8;
                end;
  PsimplePacket=^TsimplePacket;


procedure TCyberKinterface.ConvertLog;
var
  f1:TfileStream;
  f2:text;
  pp:TsimplePacket;
begin
  if fileExists(AppData+'CyberLog.msg') then
  try
  f1:=TfileStream.Create(AppData+'CyberLog.msg',fmOpenRead);
  assignFile(f2,AppData+'CyberLog.txt');
  rewrite(f2);
  while f1.Position<f1.Size do
  begin
    f1.Read(pp,sizeof(pp));
    writeln(f2,Istr1(pp.time,10)+' '+hexa(pp.chid)+' '+Hexa(pp.type1));
  end;
  closeFile(f2);
  f1.Free;
  except
  f1.Free;
  end;
end;




procedure TCyberKinterface.storeOtherPacket(p:pointer);
begin
  with PsimplePacket(p)^ do
  if assigned(ffLog) and not( ( chid=$8000) and (type1=0)
                               or
                              ( chid>0) and (chid<=32) and (type1=255)
                            )
    then ffLog.Write(PsimplePacket(p)^,sizeof(TsimplePacket));
end;

var
  Dtest: boolean;

procedure TCyberKinterface.ProcessPacketContinuous(p: PcbPKT_GENERIC);
var
  pS:PtabEntier;
  i,group:integer;
  ch:integer;
  w:word;
  ok1, ok2:boolean;
begin
  if not isON then exit;

  if not assigned(p) then exit;

  if FwaitNumTrig then
  begin
    ok1:=false;
    ok2:=false;
    if (p^.chid=151) then
    begin
      w:=PcbPKT_DINP(p)^.data[0];
      ok1:= (w and MskSync<>0);               // Détection de digital input
    end
    else
    if (p^.chid = 0) and (p^.type1>=2) and (p^.type1<=5) then           { Analog Data type1=num groupe   max=5 le 19 mars 2015  }
    begin
      ok2:=true;                             // Echantillon ana
    end;

    if ok1 or ok2 then
    begin
      Affdebug('TRIGGER  '+Istr(p^.time),79);
      TimeInit:=p^.time;
      TimeSeq:=p^.time;

      if ok1
        then MultiCyberTagBuf.SetInitDins(p^.data[0])
        else MultiCyberTagBuf.SetInitDins(0);

      inc(NbSeq);
      for i:=1 to nbVSpk do storeSpike(nil,i,-timeSeq-1,0);

      FwaitNumTrig:=false;

      AcqCybTime:=TimeSeq/30000;
      AcqPCtime:=GetTickCount;
    end;
  end;

  if not FwaitNumTrig then
  with p^ do
  if (chid=$8000) and (type1=0) then      { System Heartbeat Packet (sent every 10ms) }
  begin
    MultiCyberTagBuf.SetLastDins(time-timeInit,time-TimeInit);
    cntDisp:=time-timeInit -60;           { On donne 2 ms de répit }
    if cntDisp<0 then cntDisp:=-1;
  end
  else
  if (chid = 0) and (type1>=2) and (type1<=5) then           { Analog Data type1=num groupe  max=5 le 19 mars 2015}
  begin
    group:=type1;
    pS:=@p^.data;

    for i:=0 to GroupNbCh[group]-1 do storeSample(GroupToCh[group,i],pS^[i],time-TimeInit);
    //if group=refGroup then inc(cntDisp,cntDispInc);        Ne marche pas!

//      Affdebug('Store group='+Istr1(group,8)+'  t= '+Istr1(time-TimeInit,8) ,79);
//      cntDisp:=time-timeInit;           { On donne 2 ms de répit }
//      if cntDisp<0 then cntDisp:=-1;
  end
  else
  if (chid >0) and (chid<=nbVspk) and (type1>=0) and (type1<=5) then           { Spike Data  type1=Unit}
  begin
    storeSpike(p,chid,time-TimeInit,type1);
    (*
    // mesure du délai entre l'acquisition d'un spike et le traitement dans Elphy
    if (chid=5) and assigned(NItest) then
    begin
    //test 1 avec un counter-timer d'une carte NI
//      NItest.setCounter(0,false,0,0.0001,0.0001,false, 6);
//      NItest.start('');
    // test 2 avec une sortie digitale
      fonctionTNIinterface_DOut('Dev1/port1/line6',ord(Dtest)*$FFFF,typeUO(self));
      Dtest:=not Dtest;
    end;
    // les 2 tests donnent entre 12 et 20 ms de retard
    *)
  end
  else
  if chid=151 then
    begin
      MultiCyberTagBuf.storeDins(data[0],time-TimeInit,time-TimeInit);
      LastDin:=data[0];
    end
  else storeOtherPacket(p);

end;



procedure TCyberKinterface.DoContinuous;
var
  p:PcbPKT_GENERIC;
begin
  if not isON then exit;

  repeat
    p:=cbGetNextPacketPtr;
    if assigned(p) then ProcessPacketContinuous(p);
  until (p=nil)  or not isON ;
end;


procedure TCyberKinterface.ProcessPacketInterne(p: PcbPKT_GENERIC);
var
  pS:PtabEntier;
  i,k,group:integer;
  ch:integer;
  time1,NewTimeSeq, ElphyTime:integer;
  w:word;
  ok:boolean;
begin
  if not isON then exit;
  if not assigned(p) then exit;;

  if FwaitNumTrig then
  begin
    if (p^.chid=151) then
    begin
      {
      w:=PcbPKT_DINP(p)^.data[0];
      ok:= (w and MskSync<>0);

      if ok then
      begin
        TimeInit:=p^.time;
        TimeSeq:=-1;
        MultiCyberTagBuf.SetInitDins(p^.data[0]);
        NbSeq:=0;
        FwaitNumTrig:=false;

      end;
      }
      ok:=false;                                                            // MskSync= bit15
      w:=PcbPKT_DINP(p)^.data[0];
      if  not FwaitStateUp and (w and MskSync<>0) then FwaitStateUp:=true   // Front montant
      else
      if FwaitStateUp and (w and MskSync=0) then ok:=true;                  // Front descendant ==> start


      if ok then
      begin
        TimeInit:=p^.time;
        TimeSeq:=-1;
        MultiCyberTagBuf.SetInitDins(p^.data[0]);
        NbSeq:=0;
        FwaitNumTrig:=false;

      end;

    end

    else
    if TestCentralSim    // pour tester avec CentralSim
       and (p^.chid = 0) and (p^.type1>=2) and (p^.type1<=5) and (getTickCount-testTime>100) then           { Analog Data type1=num groupe   max=5 le 19 mars 2015  }
    begin
      ok:=true;                             // Echantillon ana
      TimeInit:=p^.time;
      TimeSeq:=-1;
      NbSeq:=0;
      FwaitNumTrig:=false;

      AffDebug('Test CentralSim time='+Istr(p^.time),101);
    end;               // Fin test CentralSim

  end;

  if not FwaitNumTrig then
  with p^ do
  begin
    time1:=time-timeInit;
    NewtimeSeq:= time1 div isiK *isiK;
    if NewTimeSeq<>TimeSeq then
    begin
      inc(nbSeq);
      TimeSeq:=NewTimeSeq;
      for i:=1 to nbVSpk do storeSpike(nil,i,-timeSeq-1,0);
      if nbSeq>1 then MultiCyberTagBuf.SetInitDins(LastDin);
      AcqCybTime:=p^.time/30000;
      AcqPCtime:=GetTickCount;
    end;

    k:=time1 mod isiK;


    if (k>=0) and (k<nbptK) then
    begin
      ElphyTime:=nbptK*(nbSeq-1)+time1-timeSeq;   { temps Elphy }

      if (chid=$8000) and (type1=0) then      { System Heartbeat Packet (sent every 10ms) }
      begin
        MultiCyberTagBuf.SetLastDins(ElphyTime-60,time1-timeSeq);
        cntDisp:=ElphyTime -60;           { On donne 2 ms de répit }
        if cntDisp<0 then cntDisp:=-1;
      end
      else

      if (chid = 0) and (type1>=2) and (type1<=5) then           { Analog Data type1=num groupe   max=5 le 19 mars 2015}
      begin
        group:=type1;
        pS:=@p^.data;

        for i:=0 to GroupNbCh[group]-1 do storeSample(GroupToCh[group,i],pS^[i], ElphyTime);

        cntDisp:=Elphytime-60;
        if cntDisp<0 then cntDisp:=-1;

        Affdebug('Analog time='+Istr(p^.time)+'  len='+Istr(p^.dlen) + '  Group= '+Istr(GroupNbCh[group]) ,101)
      end
      else
      if (chid >0) and (chid<=nbVspk) and (type1>=0) and (type1<=5) then           { Spike Data  type1=Unit}
      begin
        storeSpike(p,chid,time1-timeseq,type1);   { on stocke le temps relatif }
      end
      else
      if chid=151 then
      begin
        MultiCyberTagBuf.storeDins(data[0],ElphyTime,time1-timeSeq);
        LastDin:=data[0];
      end;

    end;
  end;

end;


procedure TCyberKinterface.DoInterne;
var
  p:PcbPKT_GENERIC;
begin
  if not isON then exit;

  repeat
    p:=cbGetNextPacketPtr;
    if assigned(p) then processPacketInterne(p);
  until (p=nil) or not isON ;
end;



procedure TCyberKinterface.storeSample(ch: integer; w: smallint;time:integer);
begin
  ch:=ch-1;
  if ch>=0 then MultiMainBuf[ch].StoreSmall(w);
end;

procedure TCyberKinterface.storeSpike(p:pointer;ch, time: integer;att:byte);
begin
  MultiEvtBuf[ch-1].storeSpike(p,time,att);
end;


function TCyberKinterface.FixedPeriod: boolean;
begin
  result:= true;
end;

function TCyberKinterface.getFixedPeriod: float;
begin
  result:= 1/30;
end;

procedure TCyberKinterface.InstallQKS;
var
  i:integer;
begin
  acqInf.periodeCont:=1/30;

  with AcqInf do
  for i:=1 to Qnbvoie do
  begin
    if QKS[i]<=3 then QKS[i]:=3
    else
    if QKS[i]<=15 then QKS[i]:=15
    else QKS[i]:=30;
  end;
end;

function TCyberKinterface.ElphyFormatOnly: boolean;
begin
  result:=true;
end;


function TCyberKinterface.DxuSpk: float;
begin
  result:=1000/30000;       { en millisecondes }
end;

function TCyberKinterface.setDout(num:integer;w:boolean):integer;
var
  packet:cbPKT_SET_DOUT;
begin
  {if FsimCyberK then exit;}

  with packet do
  begin
    time:=0;
    chid:=$8000;
    type1:= cbPKTTYPE_SET_DOUTSET;
    dlen:=1;
    chan:= 152+num;
    value:=ord(w)*$FFFF;
  end;

  if assigned(cbSendPacket)
    then result:= cbSendPacket(@packet);

end;

procedure MessageGeneric(p:Pgeneric);
var
  st:AnsiString;
  i:integer;
begin
  with p^ do
  begin
    st:='chid='+Istr(chid)+crlf+
        'type1='+hexa(type1)+crlf+
        'dlen='+Istr(dlen)+crlf;

    for i:=0 to 15 do
      st:=st+Istr(bb[i])+' ';
  end;
  messageCentral(st);
end;


function TCyberKinterface.getSampleIndex: integer;
begin
  result:=cntDisp;
end;

function TCyberKinterface.nbVoieSpk: integer;
begin
  result:=AcqInf.CyberElecCount
end;

function TCyberKinterface.UnitXspk: AnsiString;
begin
  result:='ms';
end;

procedure TCyberKinterface.CyberDelay(ms: integer);
begin
  delay(ms);
end;


initialization
Affdebug('Initialization CyberKbrd1',0);
initCyberKboards;
end.
