unit cyberKbrd2;

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
     util1,varconf1,Gdos, MemoForm,
     debug0,
     stmdef,AcqBrd1,stimInf2,
     dataGeneFile,FdefDac2,
     Ncdef2,
     acqCom1, AcqInterfaces,
     acqDef2,acqInf2,
     cyberKbrd1, cyberK4,
     stmNI;



type
  TCyberK10interface = class(TCyberKinterface)


 protected
   FsimCyberK:boolean;

 public
    CentralDir: AnsiString;
    CbDevChCount: integer;

    constructor create(var st1:driverString);override;
    destructor destroy;override;

    procedure init;override;
    procedure lancer;override;
    procedure terminer;override;

    procedure GetOptions;override;


    procedure setDoAcq(var procInt:ProcedureOfObject);override;

    procedure initcfgOptions(conf:TblocConf);override;

    function getSampleIndex:integer;override;

    function cbErrorString(n:integer):AnsiString;override;
    function setDout(num:integer;w:boolean):integer;override;

    procedure CbSdkDebug;
  end;

function DisplayChanInfo(var chanInfo: cbPKT_CHANINFO ): AnsiString;

implementation

uses CyberKsimBrd1, cyberKOptions;


procedure initCyberK10Boards;
begin
  registerBoard('CyberK 3.10+',pointer(TCyberK10interface));
end;

{ TCyberK10interface }

constructor TCyberK10interface.create(var st1: driverString);
begin
  inherited;

  cbDevChCount:=128;
  // vérifier la présence de cbsdk.dll
end;

destructor TCyberK10interface.destroy;
begin
  // ne pas utiliser CBisOpen
  inherited;
end;

function TCyberK10interface.cbErrorString(n:integer):AnsiString;
begin
  case n of
    CBSDKRESULT_WARNCONVERT :          result:= 'If file conversion is needed';
    CBSDKRESULT_WARNCLOSED :           result:= 'Library is already closed';
    CBSDKRESULT_WARNOPEN :             result:= 'Library is already opened';
    CBSDKRESULT_SUCCESS :              result:= 'Successful operation';
    CBSDKRESULT_NOTIMPLEMENTED :       result:= 'Not implemented';
    CBSDKRESULT_UNKNOWN :              result:= 'Unknown error';
    CBSDKRESULT_INVALIDPARAM :         result:= 'Invalid parameter';
    CBSDKRESULT_CLOSED :               result:= 'Interface is closed cannot do this operation';
    CBSDKRESULT_OPEN :                 result:= 'Interface is open cannot do this operation';
    CBSDKRESULT_NULLPTR :              result:= 'Null pointer';
    CBSDKRESULT_ERROPENCENTRAL :       result:= 'Unable to open Central interface';
    CBSDKRESULT_ERROPENUDP :           result:= 'Unable to open UDP interface (might happen if default)';
    CBSDKRESULT_ERROPENUDPPORT :       result:= 'Unable to open UDP port';
    CBSDKRESULT_ERRMEMORYTRIAL :       result:= ' Unable to allocate RAM for trial cache data';
    CBSDKRESULT_ERROPENUDPTHREAD :     result:= ' Unable to open UDP timer thread';
    CBSDKRESULT_ERROPENCENTRALTHREAD:  result:= ' Unable to open Central communication thread';
    CBSDKRESULT_INVALIDCHANNEL :       result:= ' Invalid channel number';
    CBSDKRESULT_INVALIDCOMMENT :       result:= ' Comment too long or invalid';
    CBSDKRESULT_INVALIDFILENAME :      result:= ' Filename too long or invalid';
    CBSDKRESULT_INVALIDCALLBACKTYPE :  result:= ' Invalid callback type';
    CBSDKRESULT_CALLBACKREGFAILED :    result:= ' Callback register/unregister failed';
    CBSDKRESULT_ERRCONFIG :            result:= ' Trying to run an unconfigured method';
    CBSDKRESULT_INVALIDTRACKABLE :     result:= ' Invalid trackable id; or trackable not present';
    CBSDKRESULT_INVALIDVIDEOSRC :      result:= ' Invalid video source id; or video source not present';
    CBSDKRESULT_ERROPENFILE :          result:= ' Cannot open file';
    CBSDKRESULT_ERRFORMATFILE :        result:= ' Wrong file format';
    CBSDKRESULT_OPTERRUDP :            result:= ' Socket option error (possibly permission issue)';
    CBSDKRESULT_MEMERRUDP :            result:= ' Socket memory assignment error';
    CBSDKRESULT_INVALIDINST :          result:= ' Invalid range or instrument address';
    CBSDKRESULT_ERRMEMORY :            result:= ' library memory allocation error';
    CBSDKRESULT_ERRINIT :              result:= ' Library initialization error';
    CBSDKRESULT_TIMEOUT :              result:= ' Conection timeout error';
    CBSDKRESULT_BUSY :                 result:= ' Resource is busy';
    CBSDKRESULT_ERROFFLINE :           result:= ' Instrument is offline';

    else result:='';
  end;
end;


procedure TCyberK10interface.CbSdkDebug;
var
  con: cbSdkConnection;
  chanInfo: cbPKT_CHANINFO;
  st: AnsiString;
begin
  if not InitCbSdkdll(CentralDir) then exit;

  InitcbSdkConnection(con);
  cbSdkOpen(0, CBSDKCONNECTION_DEFAULT, con);

  cbSdkGetChannelConfig(0, 1, chaninfo);
  st:=DisplayChanInfo(chanInfo);
  DisplayViewText(st);

  cbSdkClose(0);
end;

procedure TCyberK10interface.init;
var
  i,j:integer;
  group1,length1:longword;
  list1: array[0..1023] of longword;  //  version 3.10
  list2: array[0..1023] of word ;     //  version 3.11

  st:AnsiString;
  len,pretrig,sysfreq:longword;
  Filter:array[0..300] of longword;
  bb: array[0..300] of boolean;

  res: cbSdkResult;
  con: cbSdkConnection;
  conType: cbSdkConnectionType;
  instType: cbSdkInstrumentType;
  chanInfo: cbPKT_CHANINFO;
  t0:longword;
  OldGroup,NewGroup: integer;
  LastNum,LastVal:integer;
  g,s:longword;

  stDebug: AnsiString;

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
  if not InitCbSdkdll(CentralDir) then
  begin
    setStopError('CyberK dll not initialized');
    exit;
  end;

  InitcbSdkConnection(con);
  
  res:= cbSdkOpen(0, CBSDKCONNECTION_DEFAULT, con);
  if not ( (res=0) or (res=CBSDKRESULT_WARNOPEN) ) then
  begin
    checkCB(res, 101);
    exit;
  end;

  if not checkCB(cbSdkSetSpikeConfig(0, AcqInf.CyberWaveLen,AcqInf.PretrigWave),102) then exit;
  t0:=getTickCount;
  repeat
    res:=cbSdkGetSysConfig(0,Len,Pretrig,sysfreq);
  until (len=AcqInf.CyberWaveLen) and (Pretrig=AcqInf.PretrigWave) OR (getTickCount>t0+1000);


  if (AcqInf.CyberWaveLen<>Len) OR (Pretrig<>AcqInf.PretrigWave) then
  begin
    messageCentral('Unable to set Wavelen='+Istr(AcqInf.CyberWaveLen)+' and Pretrig= '+Istr(AcqInf.PretrigWave));
  end
  else
  if (res=0) and (len>=32) and (len<=128) and (pretrig>=0) and (pretrig<=128) then
  begin
    AcqInf.CyberWaveLen:=Len;
    AcqInf.PretrigWave:=pretrig;
  end;


  fillchar(bb,sizeof(bb),0);

  with AcqInf do
  for i:=1 to Qnbvoie do
    if ChannelType[i]=TI_analog then
    begin
      if not checkCB(cbSdkGetChannelConfig(0, QvoieAcq[i], chaninfo),106) then exit;

      if i=1 then stDebug:= DisplayChanInfo(chanInfo);

      g:= chanInfo.smpgroup;
      s:= chanInfo.spkopts AND 1;
      chanInfo.smpgroup:= QKStoGroup(QKS[i]);
      //chanInfo.smpfilter:= 10;
      //chanInfo.ainpopts:= cbAINP_REFELEC_LFPSPK  + cbAINP_OFFSET_CORRECT;
      //chanInfo.refelecchan:=1;

      //if QvoieAcq[i]<=nbvSpk
      //  then chanInfo.spkopts:= chanInfo.spkopts OR 1
      //  else chanInfo.spkopts:= chanInfo.spkopts AND $FFFFFFFE;

      if (g<>chanInfo.smpgroup) {or (s<>chanInfo.spkopts AND 1)} then
        if not checkCB(cbSdkSetChannelConfig(0, QvoieAcq[i], chaninfo),107) then exit;

      bb[QvoieAcq[i]]:=true;
      LastNum:= QvoieAcq[i];
      LastVal:= chanInfo.smpgroup;
    end;

  for i:= 1 to CbDevChCount + 16  do
    if not bb[i] then
    begin
      if not checkCB(cbSdkGetChannelConfig(0, i, chaninfo),1000+i) then exit;
      g:= chanInfo.smpgroup;
      s:= chanInfo.spkopts AND 1;


      chanInfo.smpgroup:= 0;
      //if i<=nbvSpk
      //  then chanInfo.spkopts:= chanInfo.spkopts OR 1
      //  else chanInfo.spkopts:= chanInfo.spkopts AND $FFFFFFFE;

      //if (g<>chanInfo.smpgroup) {or (s<>chanInfo.spkopts AND 1)} then
      if not checkCB(cbSdkSetChannelConfig(0, i, chaninfo),109) then exit;
      LastNum:=i;
      LastVal:= 0;
    end;

  // Attendre que le dernier canal programmé soit pris en compte
  t0:=getTickCount;
  repeat
    cbSdkGetChannelConfig(0, lastNum, chaninfo);
  until (chanInfo.smpgroup= LastVal) or (getTickCount>t0+1000);

  //Faire un changement sur lastval
  oldGroup:= chanInfo.smpgroup;
  if oldGroup=0 then NewGroup:=2 else NewGroup:=0;
  chanInfo.smpgroup:= NewGroup;
  cbSdkSetChannelConfig(0, LastNum, chaninfo);

  //Attendre la prise en compte
  t0:=getTickCount;
  repeat
    cbSdkGetChannelConfig(0, LastNum, chaninfo);
  until (chanInfo.smpgroup=NewGroup) or (getTickCount>t0+1000);

  //Revenir en arrière
  chanInfo.smpgroup:= OldGroup;
  cbSdkSetChannelConfig(0, LastNum, chaninfo);

  t0:=getTickCount;
  repeat
    cbSdkGetChannelConfig(0, LastNum, chaninfo);
  until (chanInfo.smpgroup=OldGroup) or (getTickCount>t0+1000);
    //Attendre la prise en compte


  cbSdkGetChannelConfig(0, 1, chaninfo);
  stDebug:= stDebug + crlf +DisplayChanInfo(chanInfo);
 // DisplayViewText(stDebug);


  {Avant de lire les infos groupe, il faut attendre que les modif précédentes soient effectives
   A vérifier
  }

  refGroup:=0;
  for i:=2 to 5 do
  begin
    length1:=1000;
    case cbLibVersion of
      310: begin
             if not CheckCb( cbSdkGetSampleGroupList( 0,1, i, length1, list1[0] ), 110 ) then exit;

             setLength(GroupToCh[i],length1);
             GroupNbCh[i]:=length1;
             for j:=0 to length1-1 do GroupToCh[i][j]:=GetAnalogCh(list1[j]);
           end;
      311: begin
             if not CheckCb( cbSdkGetSampleGroupList( 0,1, i, length1, list2[0] ), 110 ) then exit;

             setLength(GroupToCh[i],length1);
             GroupNbCh[i]:=length1;
             for j:=0 to length1-1 do GroupToCh[i][j]:=GetAnalogCh(list2[j]);
           end;

    end;
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

  {Programmer les entrées digitales }
  if not checkCB(cbSdkGetChannelConfig(0, cbDevChCount+23, chaninfo),112) then exit;
  chanInfo.dinpOpts:= cbDINP_16BIT + cbDINP_ANYBIT;
  if not checkCB(cbSdkSetChannelConfig(0, cbDevChCount+23, chaninfo),113) then exit;

  {valider les sorties digitales}
  // rien à configurer ?

  delay(1000);                 // delai à vérifier


  IsiK:=AcqInf.IsiPts div nbVacq;
  nbptK:=AcqInf.Qnbpt;


end;

procedure TCyberK10interface.terminer;
var
  res:integer;
begin
  ISON:=false;

  ffLog.Free;
  ffLog:=nil;

  checkCB(cbSdkUnRegisterCallback(0, CBSDKCALLBACK_ALL),401);
  cbSdkClose(0);
  // convertLog;

  //NItest.free;
end;


procedure ContCallBack (nInstance: UINT32; var type1: cbSdkPktType; pEventData:pointer; pCallbackData:pointer);cdecl;
begin
  with TCyberK10interface(pCallBackData) do
  if isON then ProcessPacketContinuous(pEventData);
end;

procedure InterneCallBack (nInstance: UINT32; var type1: cbSdkPktType; pEventData:pointer; pCallbackData:pointer);cdecl;
begin
  with TCyberK10interface(pCallBackData) do
  if isON then ProcessPacketInterne(pEventData);
end;

procedure NumCallBack (nInstance: UINT32; var type1: cbSdkPktType; pEventData:pointer; pCallbackData:pointer);cdecl;
begin
  with TCyberK10interface(pCallBackData) do
  if isON then ProcessPacketNumplus(pEventData);
end;




procedure TCyberK10interface.lancer;
var
  i:integer;
  w:word;
begin
  TestTime:= getTickCount;
  
  TimeInit:=0;
  TimeSeq:=-1;
  NbSeq:=0;
  cntDisp:= -1;        // était à 0 avant le 18 mai 2015 ==> écriture d'un 0 sur le premier point de v1

  if AcqInf.continu then checkCB(cbSdkRegisterCallback(0,CBSDKCALLBACK_ALL, ContCallBack, self),301)
  else
  case AcqInf.ModeSynchro of
    MSinterne,MSimmediat: checkCB(cbSdkRegisterCallback(0,CBSDKCALLBACK_ALL, InterneCallBack, self),301);
    MSnumPlus,MSnumMoins: checkCB(cbSdkRegisterCallback(0,CBSDKCALLBACK_ALL, NumCallBack, self),301);
  end;

  FwaitNumTrig:=true;
  FwaitStateUp:=false;

  isON:=true;
  if acqInf.continu or (acqInf.ModeSynchro in [MSimmediat,MSinterne]) then
  begin
    mskSync:=$8000;  {Test du bit15 } // Avant 28-01-14 ,  mskSync:=$C000;  bit15 et bit14 à 1 . Pourquoi ?

    SetDout(4,false);   { On sort une impulsion de 1 ms sur la sortie Digitale 4 }
    CyberDelay(1);
    SetDout(4,true);
    CyberDelay(1);
    SetDout(4,false);
    {
    CyberDelay(1);
    SetDout(4,true);
    CyberDelay(1);
    SetDout(4,false);
    }
  end
  else
  if not acqInf.continu and (acqInf.ModeSynchro in [ MSnumPlus,MSnumMoins ]) then
  begin
    mskSync:=1;  {Test du bit0 }
  end;

  
  //NItest:= TNIinterface.create;
  //NItest.devName:='/Dev1';


  
//  ffLog:=TfileStream.Create(Appdata+'CyberLog.msg',fmCreate);
end;


procedure TCyberK10interface.GetOptions;
begin
  CyberKOpt.execute(self);
end;


procedure TCyberK10interface.setDoAcq(var procInt: ProcedureOfObject);
begin
  ProcInt:= DoNothing;
end;

type
  TsimplePacket=record
                  time: UINT32;
                  chid: UINT16;
                  type1: UINT8;
                end;
  PsimplePacket=^TsimplePacket;



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


function TCyberK10interface.getSampleIndex: integer;
begin
  result:=cntDisp;
end;


procedure TCyberK10interface.initcfgOptions(conf: TblocConf);
begin
  with conf do
  begin
    setStringconf('CentralDir',CentralDir);
    setvarconf('DevChCount',cbDevChCount,sizeof(cbDevChCount));
  end;
end;

function TCyberK10interface.setDout(num: integer; w: boolean): integer;
begin
  if assigned(cbSdkSetDigitalOutput)
    then result:= cbSdkSetDigitalOutput(0, cbDevChCount+24+num, ord(w)*$FFFF);
end;


function DisplayChanInfo(var chanInfo: cbPKT_CHANINFO ): AnsiString;
var
  st: AnsiString;
begin
  st:= '';
  with chanInfo do
  begin
    st:= st + 'time = ' + Istr(time) + crlf;
    st:= st + 'chid = ' + Istr(chid) + crlf;
    st:= st + 'type1 = ' + Istr(type1) + crlf;
    st:= st + 'dlen = ' + Istr(dlen) +crlf;

    st:= st + 'chan = ' + Istr(chan) +crlf;
    st:= st + 'proc = ' + Istr(proc) +crlf;
    st:= st + 'bank = ' + Istr(bank) +crlf;
    st:= st + 'term = ' + Istr(term) +crlf;
    st:= st + 'chancaps = ' + Istr(chancaps) +crlf;
    st:= st + 'doutcaps = ' + Istr(doutcaps) +crlf;
    st:= st + 'dinpcaps = ' + Istr(dinpcaps) +crlf;
    st:= st + 'aoutcaps = ' + Istr(aoutcaps) +crlf;
    st:= st + 'ainpcaps = ' + Istr(ainpcaps) +crlf;
    st:= st + 'spkcaps = ' + Istr(spkcaps) +crlf;

//       physcalin:    cbSCALING;      // physical channel scaling information
//       phyfiltin:    cbFILTDESC;      // physical channel filter definition
//       physcalout:   cbSCALING;     // physical channel scaling information
//       phyfiltout:   cbFILTDESC;     // physical channel filter definition
//       label1:       array[0..cbLEN_STR_LABEL-1] of AnsiChar;   // Label of the channel (null terminated if <16 characters)

    st:= st + 'userflags = ' + Istr(userflags) +crlf;

//       position:     array[0..3] of INT32;    // reserved for future position information
//       scalin:       cbSCALING;         // user-defined scaling information for AINP
//       scalout:      cbSCALING;        // user-defined scaling information for AOUT

    st:= st + 'doutopts = ' + Istr(doutopts) +crlf;
    st:= st + 'dinpopts = ' + Istr(dinpopts) +crlf;
    st:= st + 'aoutopts = ' + Istr(aoutopts) +crlf;
    st:= st + 'eopchar = ' + Istr(eopchar) +crlf;

//       union :       ChanInfo_Union;

    st:= st + 'trigtype = ' + Istr(trigtype) +crlf;
    st:= st + 'trigchan = ' + Istr(trigchan) +crlf;
    st:= st + 'trigval = ' + Istr(trigval) +crlf;
    st:= st + 'ainpopts = ' + Istr(ainpopts) +crlf;
    st:= st + 'lncrate = ' + Istr(lncrate) +crlf;
    st:= st + 'smpfilter = ' + Istr(smpfilter) +crlf;
    st:= st + 'smpgroup = ' + Istr(smpgroup) +crlf;
    st:= st + 'smpdispmin = ' + Istr(smpdispmin) +crlf;
    st:= st + 'smpdispmax = ' + Istr(smpdispmax) +crlf;
    st:= st + 'spkfilter = ' + Istr(spkfilter) +crlf;
    st:= st + 'spkdispmax = ' + Istr(spkdispmax) +crlf;
    st:= st + 'lncdispmax = ' + Istr(lncdispmax) +crlf;
    st:= st + 'spkopts = ' + Istr(spkopts) +crlf;
    st:= st + 'spkthrlevel = ' + Istr(spkthrlevel) +crlf;
    st:= st + 'spkthrlimit = ' + Istr(spkthrlimit) +crlf;
    st:= st + 'spkgroup = ' + Istr(spkgroup) +crlf;
    st:= st + 'amplrejpos = ' + Istr(amplrejpos) +crlf;
    st:= st + 'amplrejneg = ' + Istr(amplrejneg) +crlf;
    st:= st + 'refelecchan = ' + Istr(refelecchan) +crlf;

//       unitmapping:  array[0..cbMAXUNITS] of cbMANUALUNITMAPPING;            // manual unit mapping
//       spkhoops:     array[0..cbMAXUNITS,0..cbMAXHOOPS] of  cbHOOP;   // spike hoop sorting set
  end;

  result:= st;

end;

initialization
Affdebug('Initialization CyberKbrd1',0);
initCyberK10boards;
end.
