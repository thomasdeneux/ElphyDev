unit ITCbrd;

interface
{$IFDEF FPC} {$mode delphi} {$DEFINE AcqElphy2} {$A1} {$Z1} {$ENDIF}

uses windows,classes,
     util1,varconf1,
     debug0,
     stmdef,AcqBrd1,ITCmm,stimInf2,
     dataGeneFile,FdefDac2,
     Ncdef2,
     acqCom1,ITCopt1, AcqInterfaces,
     acqDef2,acqInf2
     ;



{ Driver des cartes ITC

  Quand deux PCI1600 sont disponibles,
    - on connecte trigOut de device0 à trigIn de Device1
    - le retard de la 2eme carte est compensé sur la première en ignorant
      quelques échantillons en entrées et en envoyant qq échantillons en sortie

    - le retard est de l'ordre de 205 microsecondes

    - on connecte aussi world clock output de la première carte PCI1600 à
      world clock input de la seconde carte au moyen d'un cable plat 10 conducteur.
      Il se trouve que les indications concernant ces connecteurs sont inversées:
      input est en réalité output et réciproquement. Ceci permet d'utiliser la
      même horloge pour les deux systèmes.

  L'entrée trigger est toujours trigIN sur la première carte.

}
Const
  ITC18USB_ID=5;


Const

   Bit0  = $1;
   Bit1  = $2;
   Bit2  = $4;
   Bit3  = $8;
   Bit4  = $10;
   Bit5  = $20;
   Bit6  = $40;
   Bit7  = $80;
   Bit8  = $100;
   Bit9  = $200;
   Bit10 = $400;
   Bit11 = $800;
   Bit12 = $1000;
   Bit13 = $2000;
   Bit14 = $4000;
   Bit15 = $8000;

const
  maxChITC=32;

type
  TinfoITCChannel=record
                    PhysNum:byte;
                    isDigi:boolean;
                    Numbuf: smallint;
                  end;

  TinfoDev= record
              nbIn,nbOut:integer;
              infoIn: array of TinfoITCChannel;
              infoOut:array of TinfoITCChannel;
            end;

  TITCinterface = class(TacqInterface)
  private
      {FifoBuf:array of array of array of smallint;}
      infoDev:array[0..1] of TinfoDev;

      bufIn:array of array of smallint;
      nbBufIn:integer;
      nbBufInTot:integer;
      BufInSize:integer;

      nbCount,Iadc:integer;

      InChannels,OutChannels: array of array of ITCChannelInfo;
      ITCdataIn:array of array of ITCChannelDataEx;
      ITCdataOut:array of array of ITCChannelDataEx;


      Vhold:array[0..1,0..100] of smallint;   { premier indice=device, second=numéro output absolu }
                                              { ainsi, en changeant de config, le Vhold est toujours correct }

      HoldBuf:array of array of array of smallint;

      pstimBuf: TFbuffer;
      StoredEp:integer;
      EpSize:integer;
      EpSize1:integer;
      HoldSize:integer;
      IsiSize:integer;

      nbDataOut:int64;
      nbChOut:integer;
      oldNbOut:integer;

      DeviceType,DeviceNumber:array[0..1] of integer;
      DeviceHandle:array[0..1] of Thandle;
      HWfunc: array[0..1] of HWfunction;

      Dual1600:boolean;            { True si deux 1600 utilisées }

      nbDelay1600:integer;         { Délai en nb d'échantillons  }

      deviceInfo:array[0..1] of GlobalDeviceInfo;
      DVersion,KVersion,HVersion:array[0..1] of VersionInfo;

      chTrig:integer;
      FsyncState:boolean;
      SyncMask:word;

      Fwaiting:boolean;
      FlagNum:boolean;
      FlagNumStim:boolean;
      FlagStim:boolean;

      FextraDigi0:boolean;
      bufDigi0:array of smallint;


      procedure InPoints(nb:integer);
      function getCount:integer;override;
      function getCount2:integer;override;
      procedure ManageDelay1600;

      procedure doContinuous;
      procedure doInterne;

      procedure doNumPlus;
      procedure doNumPlusStim;

      procedure DoAnalogAbs;
      procedure DoAnalogAbs1;

      procedure nextSample;override;
      procedure CopySample(i:integer);override;

      procedure relancer;override;
      procedure restartAfterWait;override;

      function OutData(i0,nb:integer):boolean;
      function OutDataHold(nb:integer):boolean;
      function OutDataDelay(nb:integer):boolean;

      function OutPossible:integer;
      Procedure OutPoints(i0,nb:int64);

      procedure PreloadDac;
      function isWaiting: boolean;override;

      procedure setChannels;

      procedure ITCMessage(numDev:integer;Status:integer;const stAd:AnsiString='');

      procedure saveBufIn;
      procedure VersionMessage(n:integer);
   public
      Delay1600:integer;           { Délai 2eme 1600 en microsecondes }

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

    end;

procedure TestITC;


implementation



function ITCerror(handle:Thandle;Status:integer):AnsiString;
var
  err:integer;
  st:AnsiString;
begin
  setLength(st,256);
  fillchar(st[1],256,' ');
  err:=ITC_GetStatusText(handle,Status,@st[1],256);

  if err<>0 then st:='';

  if pos(#0,st)>0
    then st:=copy(st,1,pos(#0,st)-1);
  result:=st;
end;

procedure TITCinterface.ITCMessage(numDev:integer;Status:integer;const stAd:AnsiString='');
begin
  messageCentral('ITC error device='+Istr(numDev)+' '+stAd +crlf+ITCerror(Devicehandle[numDev],Status));
end;

procedure TITCinterface.VersionMessage(n:integer);
var
  st:string;
begin
  with Dversion[n] do
     st:= Istr(Major)+'  '+Istr(Minor)+'  '+crlf+ tabToString(description,80)+crlf+tabToString(date,80) ;

  messageCentral(st);
end;

constructor TITCinterface.create(var st1:driverString);
var
  code:integer;
  st:AnsiString;
  i:integer;
  error:integer;
  nbTest:integer;
begin
  boardFileName:='ITC';

  Dual1600:=false;
  Delay1600:=205;

  st:=st1;
  delete(st,1,pos('#',st));
  val(st,deviceNumber[0],code);

  st:=st1;
  delete(st,pos('#',st)-1,100);


  {Mise en place de DeviceType et DeviceNumber }
  if st='ITC16' then deviceType[0]:=ITC16_ID
  else
  if st='ITC18' then deviceType[0]:=ITC18_ID
  else
  if st='ITC1600' then deviceType[0]:=ITC1600_ID
  else
  if st='DUAL ITC1600' then
  begin
    deviceType[0]:=ITC1600_ID;
    deviceType[1]:=ITC1600_ID;

    Dual1600:=true;
    deviceNumber[1]:=1;
  end
  else
  if st='ITC18USB' then deviceType[0]:=ITC18USB_ID;

  HWFunc[0].Mode := ITC1600_internal_CLOCK;
  HWFunc[1].Mode := ITC1600_intraBox_CLOCK;

  for i:=0 to ord(Dual1600) do
  begin
    nbTest:=0;
    repeat
      error:=ITC_OpenDevice(DeviceType[i],DeviceNumber[i], Smart_mode,DeviceHandle[i]);
      inc(nbTest);
    until (error=0) or (nbTest>20);

    if error=0 then
    begin
      error:=ITC_InitDevice(deviceHandle[i],HWfunc[i]);
      if error<>0 then ITCmessage(i,error,'InitDevice');

      error:=ITC_getDeviceInfo(deviceHandle[i],deviceInfo[i]);
      if error<>0 then ITCmessage(i,error,'GetDeviceInfo');
      error:=ITC_GetVersions(DeviceHandle[i], DVersion[i],KVersion[i],HVersion[i]);
      if error<>0 then ITCmessage(i,error,'GetVersions');


    end
    else ITCmessage(i,error,'OpenDevice');

  end;
end;

destructor TITCinterface.destroy;
var
  i:integer;
  error:integer;
begin
  for i:=0 to ord(Dual1600) do
  begin
    error:=ITC_CloseDevice(DeviceHandle[i]);
    if error<>0 then ITCmessage(i,error);
  end;
end;


procedure TITCinterface.init;
var
  dev,i:integer;

  st:AnsiString;
  error:integer;
  out0:integer;

begin
  //VersionMessage(0);
  flagStim:=AcqInf.Fstim and
            (AcqInf.ModeSynchro in [MSimmediat,MSinterne,MSnumPlus]);

  flagNum:=(AcqInf.ModeSynchro=MSnumPlus) and not AcqInf.Fstim;
  flagNumStim:=(AcqInf.ModeSynchro=MSnumPlus) and AcqInf.Fstim;

  pstimBuf:=paramStim.buffers;
  StoredEp:=paramStim.StoredEp;
  EpSize:=paramStim.EpSize;
  if EpSize=0 then EpSize:=10000;

  EpSize1:=EpSize*AcqInf.nbVoieAcq;

  if acqInf.continu then IsiSize:=EpSize
  else
  if (acqInf.ModeSynchro = MSnumPlus)
      or
     (acqInf.ModeSynchro in [MSimmediat,MSinterne]) and (acqInf.WaitMode)
    then IsiSize:=10000000
  else IsiSize:=AcqInf.IsiPts div AcqInf.nbVoieAcq;

  HoldSize:=IsiSize-EpSize;

  nbChOut:=length(pstimBuf);


  for dev:=0 to 1 do
  with infodev[dev] do                         { Reset InfoDev }
  begin
    nbIn:=0;
    nbOut:=0;
    setLength(infoIn,0);
    setLength(infoOut,0);
  end;

  with AcqInf do                               { Compter les INPUT sur chaque device}
  for i:=0 to QnbVoie-1 do
    if (channels[i].Qdevice <>0) and Dual1600
      then inc(infoDev[1].nbIn)
      else inc(infoDev[0].nbIn);

  if flagNum or FuseTagStart then inc(infoDev[0].nbIn);

  for dev:=0 to 1 do
  with infodev[dev] do
  begin
    setLength(infoIn,nbIn);                    { Ajuster la taille des InfoIN }
    nbIn:=0;
  end;

  with AcqInf do
  for i:=1 to QnbVoie do                       { remplir les infoIN }
  begin
    dev:=ord((channels[i-1].Qdevice <>0) and Dual1600);
    with infoDev[dev] do
    begin
      with infoIn[nbIn] do
      begin
        PhysNum:=channels[i-1].QvoieAcq;
        isDigi:=(channels[i-1].ChannelType  <>TI_analog);
        numBuf:=i-1;
      end;
      inc(nbIn);
    end;
  end;

  if flagNum or FuseTagStart then
    with infoDev[0] do
    begin
      with infoIn[nbIn] do
      begin
        PhysNum:=0;
        isDigi:=true;
        numBuf:=nbIn + InfoDev[1].nbIn;
      end;
      inc(nbIn);
    end;

  BufInSize:=50000;
  nbBufIn:=InfoDev[0].nbIn + InfoDev[1].nbIn;

  nbBufInTot:=nbBufIn;
  if flagNum  then
  begin
    if not FuseTagStart then dec(nbBufIn);
    chTrig:=nbBufInTot-1;
    FsyncState:=false;

    if (acqInf.voieSynchro>=0) and (acqInf.voieSynchro<=3)
      then SyncMask:=1 shl acqInf.voieSynchro
      else SyncMask:=1 shl 4;

  end;

  setLength(bufIn,nbBufInTot ,BufInSize);


  out0:=-1;
  if Flagstim then
  with paramStim do
  begin
    for i:=0 to ActiveChannels-1 do          {Compter les outPut sur chaque device }
    with bufferInfo[i]^ do
    begin
      if (Device<>0) and Dual1600
        then inc(infoDev[1].nbOut)
        else inc(infoDev[0].nbOut);

      if (device=0) and (tpOut=to_digiBit) and (physNum=0)
        then out0:=i;         { out0>=0 indique que le canal Outdigi0 est utilisé}


    end;

    {on ajoute le canal OutDigi0 si nécessaire }
    FextraDigi0:= (out0<0) and Dual1600;
    if FextraDigi0 then inc(infoDev[0].nbOut);

    for dev:=0 to 1 do
    with infodev[dev] do
    begin
      setLength(infoOut,nbOut);                    { Ajuster la taille des InfoOut }
      nbOut:=0;
    end;

    for i:=0 to ActiveChannels-1 do
    with bufferInfo[i]^ do                          { Remplir les infoOut }
    begin
      dev:=ord((Device<>0) and Dual1600);
      with infoDev[dev] do
      begin
        infoOut[nbOut].PhysNum:=PhysNum;
        infoOut[nbOut].isDigi:=(tpOut=to_digiBit);
        infoOut[nbOut].Numbuf :=i;
        inc(nbOut);
      end;
    end;

    if FextraDigi0 then                    {ajouter OutDigi0 si nécessaire}
      with infoDev[0] do
      begin
        infoOut[nbOut].PhysNum:=0;
        infoOut[nbOut].isDigi:=true;
        infoOut[nbOut].Numbuf :=-1;                {avec numéro buffer -1 }
        inc(nbOut);

        setLength(bufDigi0,EpSize);
        fillchar(bufDigi0[0],EpSize*2,0);
        for i:=0 to EpSize div 4-1 do BufDigi0[i]:=$FF;
      end
    else
    if Dual1600 and (out0>=0) then
      for i:=0 to EpSize div 2-1 do PstimBuf[out0,i]:=PstimBuf[out0,i] or $10;
  end
  else
  if Dual1600 and (infodev[1].nbIn>0) then
    with infoDev[0] do
    begin
      setLength(infoOut,1);                    { Ajuster la taille des InfoOut }
      infoOut[0].PhysNum:=0;
      infoOut[0].isDigi:=true;
      infoOut[0].Numbuf :=-1;                {avec numéro buffer -1 }
      nbOut:=1;

      setLength(bufDigi0,EpSize);
      fillchar(bufDigi0[0],EpSize*2,0);
      for i:=0 to EpSize div 4-1 do BufDigi0[i]:=$FF;
    end;

  setLength(HoldBuf,2);
  for dev:=0 to 1 do
    with infodev[dev] do
      setLength(HoldBuf[dev],nbOut);

  {Mise en place des structures ITCdataIn pour les entrées }
  setLength(ITCdataIn,2);
  for dev:=0 to ord(Dual1600) do
  with infoDev[dev] do
  begin
    setLength(ITCdataIn[dev],nbIn);
    fillchar(ITCdataIn[dev,0],sizeof(ITCchannelDataEx)*nbIn,0);

    for i:=0 to nbIn-1 do
    begin
      if InfoIn[i].isDigi
        then ITCdataIn[dev,i].ChannelType:=digital_input
        else ITCdataIn[dev,i].ChannelType:=D2H;

      ITCdataIn[dev,i].ChannelNumber:=InfoIn[i].PhysNum;
    end;
  end;

  {Mise en place des structures ITCdataOut pour les sorties }
  setLength(ITCdataOut,2);
  for dev:=0 to ord(Dual1600) do
  with infoDev[dev] do
  begin
    setLength(ITCdataOut[dev],nbOut);
    fillchar(ITCdataOut[dev,0],sizeof(ITCchannelDataEx)*nbOut,0);

    for i:=0 to nbOut-1 do
    begin
      if InfoOut[i].isDigi
        then ITCdataOut[dev,i].ChannelType:=digital_output
        else ITCdataOut[dev,i].ChannelType:=H2D;

      ITCdataOut[dev,i].ChannelNumber:=InfoOut[i].PhysNum;
    end;
  end;

    { Structures pour la programmation des canaux }
  setLength(InChannels,2);
  setLength(OutChannels,2);

  for dev:=0 to ord(Dual1600) do
  with infoDev[dev] do
  begin
    setLength(InChannels[dev],nbIn);
    fillchar(InChannels[dev,0],sizeof(ITCChannelInfo)*nbIn,0);      {Input channels}
    for i:=0 to nbIn-1  do
    with InChannels[dev,i] do
    begin
      if InfoIn[i].isDigi
        then ChannelType:=digital_input
        else ChannelType:=D2H;
      ChannelNumber:=InfoIn[i].PhysNum ;
      SamplingIntervalFlag:=US_scale or Use_time or Adjust_rate;
      SamplingRate:=AcqInf.periodeparvoieMS*1000;
    end;

    if Flagstim or Dual1600 then
    begin
      setLength(OutChannels[dev],nbOut);
      fillchar(OutChannels[dev,0],sizeof(ITCChannelInfo)*nbOut,0);  {output channels}

      for i:=0 to nbOut-1 do
      with OutChannels[dev,i] do
      begin
        if infoOut[i].isDigi
          then ChannelType:=Digital_output
          else ChannelType:=H2D;
        ChannelNumber:=infoOut[i].PhysNum;
        SamplingIntervalFlag:=US_scale or Use_time;
        SamplingRate:=AcqInf.periodeparvoieMS*1000;
      end;
    end;
  end;

  GI1:=-1;
  initPadc;
  cntStim:=0;

  nbdelay1600:=round(Delay1600/1000/acqInf.periodeParVoieMS);

  setChannels;

  nbvoie:=nbBufInTot;
end;

procedure TITCinterface.setChannels;
var
  dev,error:integer;
  i:integer;
begin
  {setLength(FifoBuf,2);}

  for dev:=0 to ord(Dual1600) do
  with infoDev[dev] do
  begin
    ITC_resetChannels(deviceHandle[dev]);                                  {resetChannels }
    {
    setLength(FifoBuf[dev],nbIn,131072);
    for i:=0 to nbIn-1 do
      begin
        inChannels[dev,i].FIFONumberOfPoints:=65536;
        inChannels[dev,i].FIFOPointer:=@FifoBuf[dev,i,0];
      end;
    }

    error:=ITC_setChannels(deviceHandle[dev],nbIn,InChannels[dev,0]);      {setChannels }
    if error<>0 then
    begin
      ITCmessage(dev,error);
      flagStop:=true;
      exit;
    end;

    if (Flagstim or Dual1600) and (nbOut>0) then
      begin
        error:=ITC_setChannels(deviceHandle[dev],nbOut,OutChannels[dev,0]);{setChannels }
        if error<>0 then
        begin
          ITCmessage(dev,error);
          flagStop:=true;
          exit;
        end;
      end;


    { Mettre à jour les canaux }
    error:=ITC_UpdateChannels(deviceHandle[dev]);                      {updateChannels}
    if error<>0 then
      begin
        ITCmessage(dev,error);
        flagStop:=true;
        exit;
      end;

  end;

  (*

  for dev:=0 to ord(Dual1600) do
  with infoDev[dev] do
  begin
    if nbIn>0 then
    begin
      {fillchar(InChannels[dev,0],sizeof(ITCChannelInfo)*nbIn,0);
      InChannels[dev,0].SamplingIntervalFlag:=0; }
      error:=ITC_getChannels(deviceHandle[dev],nbIn,InChannels[dev,0]);    {getChannels }
      if error<>0 then
      begin
        ITCmessage(dev,error);
        flagStop:=true;
        exit;
      end;
    end;

    if (Flagstim or Dual1600) and (nbOut>0) then
      begin
        error:=ITC_getChannels(deviceHandle[dev],nbOut,OutChannels[dev,0]);{getChannels }
        if error<>0 then
        begin
          ITCmessage(dev,error);
          flagStop:=true;
          exit;
        end;
      end;
  end;
  *)
end;

procedure TITCinterface.lancer;
var
  dev,i,n:integer;
  error:integer;

  info:ITCstartInfo;
begin
  restartOnTimer:= not AcqInf.continu and
                  (acqInf.ModeSynchro in [MSimmediat,MSinterne]) and
                  acqInf.waitMode;

  nbCount:=0;
  Iadc:=0;

  initPmainDac;
  PreloadDAC;

  AcqTime0:=GetTickCount;

  fillchar(info,sizeof(info),0);                 { Info pour ITC_start }
  with Info do
  begin
    ExternalTrigger:=bit0+bit3;
    OutputEnable:=longword(-1);
    StopOnOverflow:=longword(-1);
    StopOnUnderrun:=longword(-1);

    RunningOption:=longword(-1);
  end;
            {
            for ITC16/18: Bit 0: Enable trigger.
            for ITC1600:
            Bit 0:	Enable trigger.
            Bit 1:	Use trigger from PCI1600
            Bit 2:	Use timer trigger
            Bit 3:	Use Rack 0 TrigIn BNC
            Bit 4:	Use Rack 0 Digital Input 0 BNC
            Bit 5:	Use Rack 0 Digital Input 1 BNC
            Bit 6:	Use Rack 0 Digital Input 2 BNC
            Bit 7:	Use Rack 0 Digital Input 3 BNC
            Bit 8:	Use trigger from PCI1600, but with Rack Reload function, for better synch.
            }

  if Dual1600 then
  begin
    error:=ITC_start(deviceHandle[1], Info);
    if error<>0 then
      begin
        ITCmessage(1,error);
        flagStop:=true;
        exit;
      end;
  end;

  {lancer l'acquisition }
  if flagNumStim then
  begin
    case acqInf.voieSynchro of
      0: info.ExternalTrigger:=bit0+bit4;
      1: info.ExternalTrigger:=bit0+bit5;
      2: info.ExternalTrigger:=bit0+bit6;
      3: info.ExternalTrigger:=bit0+bit7;
      else info.ExternalTrigger:=bit0+bit3;
    end;
    error:=ITC_start(deviceHandle[0],info);
  end
  else error:=ITC_start(deviceHandle[0],ITCstartInfo((nil)^));
  if error<>0 then
    begin
      ITCmessage(0,error);
      flagStop:=true;
      exit;
    end;

  Fwaiting:=false;

  ManageDelay1600;

end;

procedure TITCinterface.ManageDelay1600;
var
  error:integer;
  buf:array[0..999] of smallint;
  nbdataIn:integer;
  i,x:integer;

begin
  if not Dual1600 or (nbDelay1600=0) then exit;

  repeat
  with infoDev[0] do
  begin
    error:=ITC_getDataAvailable(deviceHandle[0],nbIn,ITCdataIn[0,0]);
    if error<>0 then
    begin
      ITCmessage(0,error);
      flagStop:=true;
    end;

    nbdataIn:=maxEntierLong;
    for i:=0 to nbIn-1 do
    begin
      x:=ITCdataIn[0,i].value;
      if x<nbdataIn then nbdataIn:=x;
    end;
  end;
  until (nbdataIn>nbDelay1600) or flagStop or testEscape;

  with infoDev[0] do
  begin
    for i:=0 to nbIn-1 do
    begin
      ITCdataIn[0,i].value:=nbDelay1600;
      ITCdataIn[0,i].DataPointer:=@buf;
    end;

    Error:= ITC_ReadWriteFIFO(DeviceHandle[0], nbIn, ITCdataIn[0,0]);
    if error<>0 then
    begin
      ITCmessage(0,error);
      flagStop:=true;
    end;
  end;

end;

procedure TITCinterface.InPoints(nb:integer);
var
  dev,i:integer;
  n,nstart:integer;
  error:integer;
begin
  nStart:=(Iadc div nbBufIn) mod bufInSize;
  repeat
    n:=nb;
    if nstart+n>BufInSize then n:=BufInSize-nStart;
    for dev:=0 to ord(dual1600) do
    with infoDev[dev] do
    begin
      for i:=0 to nbIn-1 do
      begin
        ITCdataIn[dev,i].value:=n;
        ITCdataIn[dev,i].DataPointer:=@bufIn[infoIn[i].numBuf,nStart];
      end;

      Error:= ITC_ReadWriteFIFO(DeviceHandle[dev], nbIn, ITCdataIn[dev,0]);
      if error<>0 then ITCmessage(dev,error);
    end;
    nStart:=(nStart+n) mod BufInSize;
    dec(nb,n);
  until nb=0;
end;

function TITCinterface.getCount:integer;
var
  dev,i:integer;
  x,error:integer;
  nbdataIn:integer;
begin
  nbdataIn:=maxEntierLong;

  for dev:=0 to ord(dual1600) do
  with infoDev[dev] do
  begin
    error:=ITC_getDataAvailable(deviceHandle[dev],nbIn,ITCdataIn[dev,0]);
    if error<>0 then ITCmessage(dev,error);
    if nbin>0 then affdebug('count'+Istr(dev)+'='+Istr(ITCdataIn[dev,0].Value) ,21);
    for i:=0 to nbIn-1 do
    begin
      x:=ITCdataIn[dev,i].value;
      if x<nbdataIn then nbdataIn:=x;
    end;
  end;

  InPoints(nbdataIn);

  inc(nbCount,nbdataIn*nbBufin);
  result:=nbCount;

  affdebug('getCount='+Istr(nbCount),21);
end;

procedure TITCinterface.nextSample;
var
  n:integer;
begin
  if Iadc>=nbCount then exit;

  n:=Iadc mod nbBufIn;
  wsample[0]:=bufIn[n][(Iadc div nbBufIn) mod BufInSize];
  wsampleR[0]:=wsample[0];

  inc(Iadc);
end;


function TITCinterface.getCount2:integer;
begin
  result:=0;
end;

procedure TITCinterface.relancer;
begin
  if Flagstim then
    begin
      inc(baseIndex,nbptStim);
    end;

  setChannels;
  lancer;

  Fwaiting:=false;
end;


procedure TITCinterface.terminer;
var
  dev:integer;
  sparam:ITCstatus;
  error:integer;
begin
  for dev:=0 to ord(Dual1600) do
  begin
    error:=ITC_stop(deviceHandle[dev],nil);
    if error<>0 then ITCmessage(dev,error);
  end;

  (*
  for dev:=0 to ord(Dual1600) do
  repeat
    error:=ITC_GetState(DeviceHandle[dev],@sParam);
  until (error<>0) or (sparam.RunningMode and RUN_STATE=0) or testEscape;
  *)

   saveBufIn;  { pour debug }
  {
  setLength(bufIn,0);
  setLength(ITCdataIn,0);
  setLength(ITCdataOut,0);

  setLength(Vhold,0);
  setLength(HoldBuf,0);

  setLength(pstimBuf,0);
  }
  Fwaiting:=false;
end;

procedure TITCInterface.doContinuous;
var
  i:integer;
begin
  GI2:=getCount-1;

  for i:=GI1+1 to GI2 do
  begin
    nextSample;
    storeWsample;
  end;

  if withStim
    then outPoints(nbdataOut,(GI2-GI1) div nbvoie);

  GI1:=GI2;
end;

procedure TITCinterface.doInterne;
var
  i,k:integer;

begin
  GI2:=getCount-1;

  for i:=GI1+1 to GI2 do
  begin
    k:=i mod isi;
    nextSample;
    if (k>=0) and (k<nbpt) then storeWsample;
  end;

  if withStim
    then outPoints(nbdataOut,(GI2-GI1) div nbvoie);

  GI1:=GI2;
end;

{****************** Synchro mode numérique Plus sans stim *********************}

procedure TITCInterface.DoNumPlus;
var
  i,j:integer;
  ch:integer;
begin
  GI2:=getcount-1;

  for i:=GI1+1 to GI2 do
  begin
    nextSample;
    ch:=i mod nbBufIn;

    FsyncState:= bufIn[ChTrig][(i div nbBufIn) mod BufInSize] and SyncMask <>0;

    if not Ftrig then
      begin
        if (i>nbAv) and  not oldSyncNum and FsyncState then
          begin
            TrigDate:=i div nbBufIn*nbBufIn;
            Ftrig:=true;

            for j:=trigDate-nbAv to i do copySample(j);
           affdebug('trigDate= '+Istr(trigDate)+' i='+Istr(i),27);
          end;
        oldSyncNum:=FsyncState;
      end
    else
      begin
        if (i-trigDate>=nbAp) then
          begin
            Ftrig:=false;
            oldSyncNum:=true;
          end
        else
          begin
            storeWsample;
            oldSyncNum:=FsyncState;
          end;
      end;
  end;

  GI1:=GI2;

  affdebug(Istr(ChTrig)+' '+Istr(nbBufIn) +' '+Istr(nbBufInTot)+' '+Istr(BufInSize) ,27);
  affdebug(Istr(nbvoie)+' '+Istr(nbAv) +' '+Istr(nbAp)+' ',27);
  with infodev[0] do
  for i:=0 to nbIn-1 do
    affdebug('Numbuf['+Istr(i)+']= '+Istr(infoIn[i].numbuf),27);
end;

procedure TITCInterface.doNumPlusStim;
var
  i,j,k,GI2,GI2x:integer;
  i1:integer;
  t:longWord;
begin
  if Fwaiting then exit;

  GI2:=getcount-1;

  for i:=GI1+1 to GI2 do
  begin
    nextSample;
    storeWsample;

    if i=EpSize1-1 then
      begin
        GI1:=-1;
        GI2:=0;
        terminer;

        GI1x:=-1;

        Fwaiting:=true;
        exit;
      end;
  end;

  if withStim
    then outPoints(nbdataOut,(GI2-GI1) div nbvoie);

  GI1:=GI2;
end;

{****************** Synchro mode analogique absolu ***************************}
{l'ADC est en mode circulaire. On teste la voie synchro en permanence.
 La voie synchro doit faire partie des voies acquises. Sinon voir DoAnalogAbs1
}

procedure TITCinterface.DoAnalogAbs;
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
              end;
            oldw1:=wSampleR[0];
          end
      end
    else
      begin
        if (i-trigDate>=nbAp)
          then Ftrig:=false
          else storeWSample;
        if (i mod nbvoie=VoieSync-1) then oldw1:=wSampleR[0];
      end;
  end;
  GI1:=GI2;
end;


{****************** Synchro mode analogique absolu ***************************}
{l'ADC est en mode circulaire. On teste la voie synchro en permanence.
 La voie synchro ne fait pas partie des voies acquises. Sinon voir DoAnalogAbs
}

procedure TITCInterface.DoAnalogAbs1;
var
  i,j:integer;
  k,index,ideb:integer;
  x:boolean;
  tt:single;
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
               ((wSampleR[0]>=seuilP) and (oldw1<seuilP) OR (wSampleR[0]<=seuilM) and (oldw1>seuilM)) then
              begin
                TrigDate:=i div nbvoie*nbvoie;
                Ftrig:=true;
                for j:=trigDate-nbAv to i do
                  if j mod nbvoie<>nbvoie-1 then copySample(j);
              end;
            oldw1:=wSampleR[0];
          end
      end
    else
      begin
        if (i-trigDate>=nbAp) then Ftrig:=false
        else
          begin
            if (i mod nbvoie=VoieSync-1)
              then oldw1:=wSampleR[0]
              else storeWSample;
          end;
      end;

  end;

  GI1:=GI2;
end;




function TITCinterface.isWaiting: boolean;
begin
  result:=Fwaiting;
end;


function TITCinterface.dataFormat:TdataFormat;
begin
  result:=F16bits;
end;

function TITCinterface.DacFormat:TdacFormat;
begin
  result:=DacF1322;
end;




function TITCinterface.PeriodeElem:float;
begin
  result:=5;
end;

function TITCinterface.PeriodeMini:float;
begin
  result:=5;
end;

procedure TITCinterface.outdac(num,j:word);
begin
end;

function TITCinterface.outDIO(dev,port,value:integer): integer;
var
  ItcData: ITCChannelDataEx;
  error: integer;
begin
  fillchar(ItcData, sizeof(ItcData),0);
  ItcData.ChannelType := DIGITAL_OUTPUT;
  ItcData.ChannelNumber := port;

  Error := ITC_AsyncIO(DeviceHandle[dev], 1, ItcData);

end;


function TITCinterface.inADC(n:integer):smallint;
begin
end;

function TITCinterface.inDIO(dev,port:integer):integer;
var
  ItcData: ITCChannelDataEx;
  error: integer;
begin
  fillchar(ItcData, sizeof(ItcData),0);
  ItcData.ChannelType := DIGITAL_INPUT;
  ItcData.ChannelNumber := port;

  Error := ITC_AsyncIO(DeviceHandle[dev], 1, ItcData);

  if error=0
    then result:=ItcData.Value
    else result:=-1;
end;




procedure TITCinterface.copySample(i:integer);
var
  n:integer;
begin
  n:=i mod nbBufIn;
  wsample[0]:=bufIn[n][(i div nbBufIn) mod BufInSize];
  wsampleR[0]:=wsample[0];

  storeWsample;
end;


function TITCinterface.RangeString:AnsiString;
begin
  result:='-10 V to 10 V';
end;

function TITCinterface.MultiGain:boolean;
begin
  result:=false;
end;

function TITCinterface.GainLabel:AnsiString;
begin
  result:='Range';
end;

function TITCinterface.nbGain;
begin
  result:=1;
end;

function TITCinterface.channelRange:boolean;
begin
  result:=false;
end;

procedure TITCinterface.GetOptions;
begin
  ITCoptions.execution(self);
end;

procedure TITCinterface.setDoAcq(var procInt:ProcedureOfObject);
var
  modeSync:TmodeSync;
begin
  with acqInf do
  begin
    if continu
      then modeSync:=MSimmediat
      else modeSync:=modeSynchro;

    if continu then ProcInt:=DoContinuous
    else
      case modeSync of
        MSimmediat, MSinterne: if not WaitMode
                                 then ProcInt:=doInterne
                                 else ProcInt:=doNumPlusStim;

        MSnumPlus: if AcqInf.Fstim then ProcInt:=doNumPlusStim
                                   else ProcInt:=doNumPlus;
        MSanalogAbs:  ProcInt:=DoAnalogAbs;

        else ProcInt:=nil;
      end;
  end;

end;

procedure TITCinterface.initcfgOptions(conf:TblocConf);
begin
  with conf do
  begin
    setvarconf('UseTagStart',FUseTagStart,sizeof(FUseTagStart));
    setvarconf('Delay1600',Delay1600,sizeof(Delay1600));
  end;
end;

function TITCinterface.TagMode:TtagMode;
begin
  if FuseTagStart
    then result:=tmITC
    else result:=tmNone;
end;

function TITCinterface.tagShift:integer;
begin
  result:=0;
end;

function TITCinterface.TagCount: integer;
begin
  result:=5;
end;


procedure TITCinterface.restartAfterWait;
begin
end;

function TITCinterface.getMinADC:integer;
begin
  result:=-32768;
end;

function TITCinterface.getMaxADC:integer;
begin
  result:=32767;
end;


procedure initITCBoards;
var
  ITC16Nb:  longword;
  ITC18Nb:  longword;
  ITC1600Nb:longword;
  ITC00Nb:  longword;
  ITC18USBnb: longword;
  error: longword;

  i:integer;

begin
  if not initITClib then exit;

  Error := ITC_Devices (ITC16_ID, ITC16Nb);
  if Error <> 0 then ITC16Nb:=0;
  Error := ITC_Devices (ITC18_ID, ITC18Nb);
  if Error <> 0 then ITC18Nb:=0;
  Error := ITC_Devices (ITC1600_ID, ITC1600Nb);
  if Error <> 0 then ITC1600Nb:=0;
  Error := ITC_Devices (ITC18USB_ID, ITC18USBNb);
  if Error <> 0 then ITC18USBNb:=0;

  for i:=0 to ITC16nb-1 do
    registerBoard('ITC16 #'+Istr(i),pointer(TITCinterface));

  for i:=0 to ITC18nb-1 do
    registerBoard('ITC18 #'+Istr(i),pointer(TITCinterface));

  for i:=0 to ITC1600nb-1 do
    registerBoard('ITC1600 #'+Istr(i),pointer(TITCinterface));

  if ITC1600nb=2 then
    registerBoard('DUAL ITC1600 #0',pointer(TITCinterface));

  for i:=0 to ITC18USBnb-1 do
    registerBoard('ITC18USB #'+Istr(i),pointer(TITCinterface));

end;


var
  DevHandle: Thandle;

procedure TestITC;
var

  error:integer;
begin
  if not initITClib then exit;

  error:=ITC_OpenDevice(ITC1600_ID,0,Smart_Mode,devHandle);
  if error<>0 then messageCentral(ITCerror(DevHandle,error));

end;




{ OutData: i0 est l'indice de départ des data dans PstimBuf (0 à EpSize*StoredEp)
           nb est le nombre de points à envoyer }
function TITCinterface.OutData(i0, nb: integer):boolean;
var
  dev,i,error:integer;
  numB,numAbs:integer;
begin
  affDebug('outData '+Istr1(i0,10)+Istr1(nb,10),25);

  for dev:=0 to ord(dual1600) do
  with infoDev[dev] do
  begin
    for i:=0 to nbOut-1 do
    begin
      ITCdataOut[dev,i].Command := PRELOAD_FIFO_COMMAND_EX ;
      ITCdataOut[dev,i].value:=nb;
      with infoOut[i] do
      begin
        numB:=infoOut[i].Numbuf;
        numAbs:=physNum+DACcount(dev)*ord(isDigi);
      end;
      if numB>=0 then
      begin
        ITCdataOut[dev,i].DataPointer:=@Pstimbuf[numB,i0];
        Vhold[dev,numAbs]:=Pstimbuf[numB,i0+nb-1];
      end
      else
      begin
        ITCdataOut[dev,i].DataPointer:=@bufDigi0[0];
        Vhold[dev,numAbs]:=bufDigi0[(i0+nb-1) mod EpSize];
      end;
    end;

    Error:= ITC_ReadWriteFIFO(DeviceHandle[dev], nbOut, ITCdataOut[dev,0]);
    if error<>0 then
    begin
      ITCmessage(dev,error);
      flagStop:=true;
      break;
    end;
  end;

  inc(cntStim,Nb*nbChOut);

  result:=not flagStop;
end;

{ OutDataHold sort nb points avec les valeurs courantes de Vhold }
function TITCinterface.OutDataHold(nb: integer):boolean;
var
  dev,i,j,error:integer;
  w:smallint;
  numAbs:integer;
begin
  for dev:=0 to ord(dual1600) do
  with infoDev[dev] do
  begin
    for i:=0 to nbOut-1 do
    begin
      with infoOut[i] do
        numAbs:=physNum+DACcount(dev)*ord(isDigi);
      w:=Vhold[dev,numAbs];

      if length(HoldBuf[dev,i])<nb then  setLength(HoldBuf[dev,i],nb);
      for j:=0 to nb-1 do HoldBuf[dev,i][j]:=w;

      ITCdataOut[dev,i].Command := PRELOAD_FIFO_COMMAND_EX;
      ITCdataOut[dev,i].value:=nb;
      ITCdataOut[dev,i].DataPointer:=@HoldBuf[dev,i][0];
    end;

    Error:= ITC_ReadWriteFIFO(DeviceHandle[dev], nbOut, ITCdataOut[dev,0]);
    if error<>0 then
    begin
      ITCmessage(dev,error);
      flagStop:=true;
      break;
    end;
  end;

  result:=not flagStop;
end;

function TITCinterface.OutDataDelay(nb: integer):boolean;
var
  i,j,error:integer;
  w:smallint;
  numAbs:integer;
begin
  if not Dual1600 then exit;

  with infoDev[0] do
  begin
    for i:=0 to nbOut-1 do
    begin
      with infoOut[i] do
        numAbs:=physNum+DACcount(0)*ord(isDigi);
      w:=Vhold[0,numAbs];

      if length(HoldBuf[0,i])<nb then  setLength(HoldBuf[0,i],nb);
      for j:=0 to nb-1 do HoldBuf[0,i][j]:=w;

      ITCdataOut[0,i].Command := PRELOAD_FIFO_COMMAND_EX;
      ITCdataOut[0,i].value:=nb;
      ITCdataOut[0,i].DataPointer:=@HoldBuf[0,i][0];

      if infoOut[i].isDigi and (infoOut[i].physNum=0) then
        for j:=0 to nb-1 do HoldBuf[0,i][j]:=HoldBuf[0,i][j] or $10;
    end;

    Error:= ITC_ReadWriteFIFO(DeviceHandle[0], nbOut, ITCdataOut[0,0]);
    if error<>0 then
    begin
      ITCmessage(0,error);
      flagStop:=true;
    end;
  end;

  result:=not flagStop;
end;


function TITCinterface.OutPossible: integer;
var
  dev,i,error:integer;
  x:integer;
begin
  { Combien de points peut-on envoyer par voie ? }
  result:=maxEntierLong;
  for dev:=0 to ord(dual1600) do
  with infoDev[dev] do
  begin
    error:=ITC_getDataAvailable(deviceHandle[dev],nbOut,ITCdataOut[dev,0]);
    if error<>0 then ITCmessage(dev,error);

    for i:=0 to nbOut-1 do
    begin
      ITCdataOut[dev,i].Command := 0;
      x:=ITCdataOut[dev,i].value;
      if x<result then result:=x;
    end;
  end;
end;

{ OutPoints : i0 est l'index absolu de départ
              nb un nombre de points
              Ce nombre doit être inférieur à OutPossible
}
procedure TITCinterface.OutPoints(i0, nb: int64);
var
  ep,epS,Iisi,IfinEp,IfinIsi:int64;
  nbE:int64;
  Ifin:int64;
begin
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


procedure TITCinterface.PreloadDac;
var
  maxDataOut:int64;
  nb:int64;
  numEp:int64;
begin
  if not (FlagStim or Dual1600) then exit;
  OutDataDelay(nbDelay1600);

  {}
  oldNbOut:=0;
  maxdataOut:=OutPossible;

  if nbchOut>0 then
  begin
    numEp:=baseIndex div nbchOut div EpSize;
    nbdataOut:=numEp*IsiSize;
  end
  else nbdataOut:=IsiSize;

  nb:=IsiSize*storedEp;
  if nb>maxdataOut
    then nb:=maxdataOut;
  outPoints(nbDataOut ,nb);

  {cntStim:=cntStim-EpSize*nbChOut;}
  {paramStim.setOutPutValues(cntStim);}
end;

function TITCinterface.deviceCount: integer;
begin
  result:=1 + ord(dual1600);
end;

function TITCinterface.ADCcount(dev:integer): integer;
begin
  result:=deviceInfo[dev].NumberOfADCs;
end;

function TITCinterface.DACcount(dev:integer): integer;
begin
  result:=deviceInfo[dev].NumberOfDACs;
end;


function TITCinterface.DigiInCount(dev:integer): integer;
begin
  result:=deviceInfo[dev].NumberOfDIs;
end;

function TITCinterface.DigiOutCount(dev:integer): integer;
begin
  result:=deviceInfo[dev].NumberOfDOs;
end;

function TITCinterface.bitInCount(dev:integer): integer;
begin
  result:=16;
end;

function TITCinterface.bitOutCount(dev:integer): integer;
begin
  result:=16;
end;


function TITCinterface.CheckParams: boolean;
var
  i,dev:integer;
  error:integer;
  InChannels1,OutChannels1: array of array of ITCChannelInfo;
  st:AnsiString;
begin
  init;

  setLength(InChannels1,2);
  setLength(OutChannels1,2);

  for dev:=0 to ord(Dual1600) do
  with infoDev[dev] do
  begin
    ITC_resetChannels(deviceHandle[dev]);                              {resetChannels }

    error:=ITC_setChannels(deviceHandle[dev],nbIn,InChannels[dev,0]);      {setChannels }
    if error<>0 then
    begin
      ITCmessage(dev,error);
      exit;
    end;

    if (Flagstim or Dual1600) and (nbOut>0) then
      begin
        error:=ITC_setChannels(deviceHandle[dev],nbOut,OutChannels[dev,0]);{setChannels }
        if error<>0 then
        begin
          ITCmessage(dev,error);
          exit;
        end;
      end;


    { Mettre à jour les canaux }
    error:=ITC_UpdateChannels(deviceHandle[dev]);                      {updateChannels}
    if error<>0 then
      begin
        ITCmessage(dev,error);
        exit;
      end;

    setLength(InChannels1[dev],length(InChannels[dev]));
    move(InChannels[dev,0],InChannels1[dev,0],sizeof(ITCchannelInfo)*length(InChannels[dev]));

    setLength(OutChannels1[dev],length(OutChannels[dev]));
    move(OutChannels[dev,0],OutChannels1[dev,0],sizeof(ITCchannelInfo)*length(OutChannels[dev]));

    st:='';

    { Relire les valeurs effectives en entrée}
    if nbIn>0 then
    begin
      error:=ITC_GetChannels(deviceHandle[dev],nbin,InChannels1[dev,0]);
      if error<>0 then ITCmessage(dev,error);
    end;

    for i:=0 to nbin-1 do
      st:=st+ Estr(InChannels1[dev,i].samplingRate,3) +crlf;

    { Relire les valeurs effectives en sortie}
    if nbOut>0 then
    begin
      error:=ITC_GetChannels(deviceHandle[dev],nbOut,OutChannels1[dev,0]);
      if error<>0 then ITCmessage(dev,error);
    end;

    for i:=0 to nbout-1 do
      st:=st+ Estr(OutChannels1[dev,i].samplingRate,3) +crlf;

  end;

  messageCentral(st);
end;


function TITCinterface.nbVoieAcq(n: integer): integer;
begin
  result:=n+ord(FuseTagStart);
end;

procedure TITCinterface.saveBufIn;
var
  tb:array of smallint;
  n1,n2,i,j:integer;
begin
(*
  n1:=length(FifoBuf[0]);
  n2:=20000;
  setLength(tb,n1*n2);
  for i:=0 to n1-1 do
    move(Fifobuf[0,i,0],tb[i*n2],n2*2);
*)
(*
  n1:=length(bufIn);
  n2:=length(bufIn[0]);
  setLength(tb,n1*n2);
  for i:=0 to n1-1 do
    move(bufIn[i,0],tb[i*n2],n2*2);
*)

  {SaveArrayAsDac2File(debugPath+'BufIn.dat',tb[0],length(tb),g_smallint);}
end;

procedure TITCinterface.setVSoptions;
begin
  FuseTagStart:=true;
  acqInf.voieSynchro:=0;
end;

procedure TITCinterface.GetPeriods(PeriodU: float; nbADC, nbDI, nbDAC, nbDO: integer; var periodIn,periodOut: float);
var
  p:float;
begin
  if nbADC<1 then nbADC:=1;
  if nbADC>=3 then nbADC:=4;
  p:=periodU*1000/nbADC;                          { période globale en microsecondes}
  p:=round(p/periodeElem)*periodeElem;       { doit être un multiple de periodeElem }
  if p<periodeMini then p:=periodeMini;           { doit être supérieure à periodeMini }
  periodIn:=p*nbADC/1000;                         { période calculée en millisecondes }
  periodOut:=periodIn;
end;

function TITCinterface.setValue(Device, tpOut, physNum, value: integer):boolean;
var
  data:ITCchannelDataEx;
  error:integer;
begin
  result:=false;
  if (device<0) or (device>ord(dual1600)) then sortieErreur('Tstimulator.SetValue : bad device');

  fillchar(data,sizeof(data),0);
  case tpOut of
    0:   data.ChannelType:=H2D;
    1:   data.ChannelType:=Digital_Output;
    2:   data.ChannelType:=Aux_Output;
    else sortieErreur('Tstimulator.SetValue : bad output type');
  end;

  data.ChannelNumber:=physNum;
  data.Value:=value;

  error:=ITC_AsyncIO(deviceHandle[Device],1,data);
  result:=(error=0);
  if not result then sortieErreur(ITCerror(deviceHandle[device],error));
end;

function TITCinterface.getValue(Device, tpIn,physNum: integer;var value: smallint):boolean;
var
  data:ITCchannelDataEx;
  error:integer;
begin
  result:=false;
  if (device<0) or (device>ord(dual1600)) then sortieErreur('Tstimulator.SetValue : bad device');


  fillchar(data,sizeof(data),0);
  case tpIn of
    0:   data.ChannelType:=D2H;
    1:   data.ChannelType:=Digital_Input;
    2:   data.ChannelType:=Aux_Input;
    else sortieErreur('Tstimulator.getValue : bad input type');
  end;

  data.ChannelNumber:=physNum;

  error:=ITC_AsyncIO(deviceHandle[Device],1,data);
  result:=(error=0);
  if not result then sortieErreur(ITCerror(deviceHandle[device],error));

  value:=data.Value;
end;

Initialization
AffDebug('Initialization ITCbrd',0);

initITCboards;

end.
