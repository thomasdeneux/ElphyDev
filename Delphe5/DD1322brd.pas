unit DD1322brd;

interface
{$IFDEF FPC} {$mode delphi} {$DEFINE AcqElphy2} {$A1} {$Z1} {$ENDIF}

uses windows,sysutils,classes,
     util1,debug0,varconf1,
     stmDef,
     AcqInterfaces, AxDD132x2,AcqBrd1,DDopt1,
     DataGeneFile,
     acqCom1,
     acqDef2,AcqInf2,stimInf2
     ;



{ La 1322 utilise la même horloge pour l'ADC et la DAC.

  Les sorties logiques se comportent comme une voie analogique supplémentaire.

  Si l'on acquiert sur 5 voies et si on stimule sur 2 dac + les sorties logiques, on
  a la chronologie suivante:

  1 2 3 4 5 1 2 3 4 5 1 2 3 4 5 ..... pour les entrées
  1 2 3 1 2 3 1 2 3 1 2 3 1 2 3 ..... pour les sorties

  Si la période globale est 1ms
    - la période par Adc est 5 ms
    - la période par Dac est 3 ms


  BUFFER DE SORTIE:
  Le comportement du système en sortie est assez curieux:
  Dés le lancement de l'acquisition, les échantillons du buffer sont avalés
  immédiatement, du moins lorsque la taille du buffer est inférieure à 300000 points.
  Ensuite, les points sont avalés régulièrement selon la vitesse d'échantillonnage.
  Il faut donc que la routine d'interruption remplace rapidement les échantillons
  manquants, sinon une erreur se produira pour des séquences longues.

}


const
  maxBuffers=1;
  maxDacBuffers=1;

type
  TDD1322interface=class(TacqInterface)
    protected
      DDnbvoie:integer;

      nbptBuf:integer;
      buf:PtabEntier;

      DacNbptBuf:integer;
      DacBuf:PtabEntier;

      nextSeq:integer;

      buffers:array[1..maxBuffers] of TdataBuffer;
      DacBuffers:array[1..maxDacBuffers] of TdataBuffer;

      Gadc:double;
      OFFadc:integer;

      Gdac:array[0..1] of double;
      OFFdac:array[0..1] of integer;

      Fwaiting:boolean;

      function getCount:integer;override;
      function getCount2:integer;override;

      procedure doNumPlus;
      procedure doNumPlusStim;
      procedure nextSample;override;


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

      function GcalibAdc(n:integer):float;override;        {n= numéro physique. commence à zéro}
      function GcalibDac(n:integer):float;override;
      function OffcalibAdc(n:integer):integer;override;
      function OffcalibDac(n:integer):integer;override;

      procedure setVSoptions;override;

      function isWaiting:boolean; override;
      procedure relancer;override;

      procedure DisplayInfo;
      procedure CopyCalibrationData;
      procedure Calibrate;

      function ADCcount(dev:integer):integer;override;     { nb ADC par device }
      function DACcount(dev:integer):integer;override;     { nb DAC par device }

      function DigiOutCount(dev:integer):integer;override; { nb Digi Out par device }
      function DigiInCount(dev:integer):integer;override;  { nb Digi In par device }

      function bitInCount(dev:integer):integer;override;   { nb bits par entrée digi }
      function bitOutCount(dev:integer):integer;override;  { nb bits par sortie digi }

      function deviceCount:integer;override;

      procedure GetPeriods(PeriodU:float;nbADC,nbDI,nbDAC,nbDO:integer;var periodIN,periodOut:float);override; {ms}
      function setValue(Device,tpOut,physNum,value:integer):boolean;override;
      function getValue(Device,tpIn,physNum:integer;var value:smallint):boolean;override;

    end;



implementation





var
  hDD1322:integer;   {le handle de l'unique device considéré }
  info:TDD132X_info; {et la structure d'info}

  FuseTag:boolean;
  CalibrationData:TDD132X_CalibrationData;
  CalibrationError:integer;

const
  nbptBuf0=100000;
  nbptBufDac0=100000;

constructor TDD1322Interface.create(var st1:driverString);
var
  i:integer;
begin
  boardFileName:='DD1322';

  buf := allocmem(nbptBuf0*2);
  DacBuf := allocmem (nbptBufDac0*2);
  nbPtBuf:=nbptBuf0;
  DacNbPtBuf:=nbptBufDac0;

  for i:=1 to maxBuffers do
  with buffers[i] do
  begin
    uNumSamples:=nbptBuf0 div maxBuffers;  // Number of samples in this buffer.
    uFlags:=0;                 // Flags discribing the data buffer.
    pnData:=@buf^[nbptBuf0 div maxBuffers*(i-1)];    // The buffer containing the data.
    psDataFlags:=nil;          // Flags split out from the data buffer.
    if i<maxBuffers
      then pNextBuffer:=@buffers[i+1]  // Next buffer in the list.
      else pNextBuffer:=@buffers[1];

    if i=1
      then pPrevBuffer:=@buffers[maxBuffers]  // Previous buffer in the list.
      else pPrevBuffer:=@buffers[i-1];
  end;

  for i:=1 to maxDacBuffers do
  with DacBuffers[i] do
  begin
    uNumSamples:=nbptBufDac0 div maxDacBuffers;  // Number of samples in this buffer.
    uFlags:=0;                 // Flags discribing the data buffer.
    pnData:=@dacbuf^[nbptBufDac0 div maxDacBuffers*(i-1)];  // The buffer containing the data.
    psDataFlags:=nil;          // Flags split out from the data buffer.
    if i<maxDacBuffers
      then pNextBuffer:=@DacBuffers[i+1]  // Next buffer in the list.
      else pNextBuffer:=@DacBuffers[1];

    if i=1
      then pPrevBuffer:=@DacBuffers[maxDacBuffers]  // Previous buffer in the list.
      else pPrevBuffer:=@DacBuffers[i-1];
  end;

  
  if CalibrationError=0 then CopyCalibrationData
  else
  begin
    Gadc:=1;
    OFFadc:=0;

    OFFdac[0]:= 0;
    Gdac[0]:=   1;
    OFFdac[1]:= 0;
    Gdac[1]:=   1;
  end;

  FnbptDacDMA:=DacNbptBuf;

end;



destructor TDD1322Interface.destroy;
begin
  if assigned(buf) then Freemem(buf);
  if assigned(DacBuf) then Freemem(dacBuf);
end;




procedure TDD1322Interface.init;
var
  ULstat:integer;
  revLevel:single;
begin
  baseIndex:=0;
  nbvoie:=AcqInf.nbVoieAcq;

  tabDma1:=buf;
  tabDma2:=dacBuf;
  nbpt0DMA:=nbptBuf;
  FnbptDacDMA:=DacNbptBuf;

  initPadc;

  nextSeq:=AcqInf.Qnbpt1;
  GI1:=-1;
  GI1x:=-1;

  cntStim:=0;
  cntStoreDac:=0;
  initPdac;
  loadDmaDAC;

  FuseTag:=FUseTagStart;
  Fwaiting:=false;
end;



procedure TDD1322Interface.lancer;
var
  protocol:TDD132X_Protocol;

  i:integer;
  res:boolean;
  error:integer;
begin
  Ptab0:=buf;
  PtabFin:=@buf^[nbpt0DMA];
  Ptab:=Ptab0;

  restartOnTimer:=false;
  AcqTime0:=GetTickCount;
  fillchar(protocol,sizeof(protocol),0);
  with protocol do
  begin
    ulength:=sizeof(protocol);
    uChunksPerSecond:=20;

    dsampleInterval:=acqInf.periodeUS;
    {messageCentral('sampleInt='+Estr(dsampleInterval,3));}

    if not AcqInf.continu and
       (acqInf.ModeSynchro = MSinterne) and acqInf.waitMode then
      begin
        dwFlags:=DD132X_PROTOCOL_STOPONTC;
        uTerminalCount:=AcqInf.Qnbpt1;
        restartOnTimer:=true;
      end
    else
    if not AcqInf.continu and
       (acqInf.ModeSynchro in [MSimmediat,MSinterne]) and
       (acqInf.maxEpCount>0) then
      begin
        dwFlags:=DD132X_PROTOCOL_STOPONTC;
        if acqInf.maxEpCount=1
          then uTerminalCount:=AcqInf.Qnbpt1
          else uTerminalCount:=AcqInf.IsiPts*acqInf.maxEpCount+1;
      end
    else
    if AcqInf.continu and (AcqInf.maxDuration>0) then
      begin
        dwFlags:=DD132X_PROTOCOL_STOPONTC;
        uTerminalCount:=AcqInf.MaxAdcSamples+1;
      end
    else
      begin
        dwFlags:=0;
        uTerminalCount:=0;
      end;

    if acqInf.ModeSynchro in [MSnumPlus,MSnumMoins] then
      begin
        if not acqInf.Fstim and FuseTagStart
          then etriggering:=DD132X_StartImmediately
          else etriggering:=DD132X_externalStart;
      end
    else etriggering:=DD132X_StartImmediately;

    if FuseTagStart
      then eAIDataBits:=DD132X_Bit0Tag_Bit1ExtStart;

    uAIChannels:=AcqInf.nbVoieAcq;

    for i:=1 to AcqInf.nbvoieAcq do anAIChannels[i]:=AcqInf.QvoieAcq[i];

    pAIbuffers:=@buffers;
    uAIbuffers:=maxBuffers;

    if AcqInf.Fstim then
      begin
        uAOChannels:=paramStim.ActiveChannels;
        for i:=1 to paramStim.ActiveChannels do anAOChannels[i]:=i-1;
        if paramStim.nbDigi>0
          then anAOChannels[uAOChannels]:= DD132X_PROTOCOL_DIGITALOUTPUT;
        pAObuffers:=@DacBuffers;
        uAObuffers:=maxDacBuffers;
      end;
  end;

  if hDD1322=0 then
    begin
      messageCentral('Error hDD1322=0');
      flagStop:=true;
      exit;
    end;

  res:=DD132X_SetProtocol(hDD1322,Protocol,error);
  if not res then
    begin
      messageCentral('Error SetProtocol '+Bstr(res)+' '+Istr(error));
      flagStop:=true;
      exit;
    end;


  res:=DD132X_StartAcquisition(HDD1322,error);
  if not res then
    begin
      messageCentral('Error StartAcq '+Bstr(res)+' '+Istr(error));
      flagStop:=true;
      exit;
    end;

end;

procedure TDD1322Interface.relancer;
var
  i,j,k,GI2,GI2x:integer;
  i1:integer;
begin
  if AcqInf.Fstim then
    begin
      inc(baseIndex,nbptStim);
      cntStoreDac:=0;
      loadDmaDac;
    end;
  lancer;

  GI2x:=getCount2;
  for i1:=GI1x+1 to GI2x do
    begin
      j:=cntStoreDac mod nbdac;
      if (cntStoreDac>=0) and (cntStoreDac<nbptStim)
        then Jhold1[j]:=nextSampleDac;
      storeDac(Jhold1[j]);
    end;

  AffDebug('Immediate CntStoreDac='+Istr(cntStoreDac)+
           ' GI1x+1='+Istr(GI1X+1)+' count2='+Istr(GI2X),0);
  GI1x:=GI2x;

  Fwaiting:=false;
end;



procedure TDD1322Interface.terminer;
var
  res:boolean;
  error:integer;
begin
  res:=DD132X_StopAcquisition(HDD1322, error);
  {if not res then
    begin
      messageCentral('Error StopAcq '+Bstr(res)+' '+Istr(error));
      flagStop:=true;
      exit;
    end;
   }
  repeat until not DD132X_IsAcquiring(HDD1322 );
  Fwaiting:=false;

  resetPmainDac;
end;


function TDD1322Interface.dataFormat:TdataFormat;
begin
  if FuseTagStart
    then result:=Fdigi1322
    else result:=F16bits;
end;

function TDD1322Interface.DacFormat:TdacFormat;
begin
  result:=DacF1322;
end;


function TDD1322Interface.getCount:integer;
var
  sampleCount:int64;
  error:integer;
  res:boolean;
begin
  res:=DD132X_GetAcquisitionPosition(HDD1322,SampleCount,error);
  result:=sampleCount;
end;

                                    
function TDD1322Interface.getCount2:integer;
var
  sampleCount:int64;
  error:integer;
  res:boolean;
begin
  res:=DD132X_GetNumSamplesOutput(HDD1322,SampleCount,error);
  result:=sampleCount-1;
  count2:=result;
end;


function TDD1322Interface.PeriodeElem:float;
begin
  result:={info.uClockResolution/1000} 1 ;  { 1 microseconde imposé }
end;

function TDD1322Interface.PeriodeMini:float;
begin
  result:=info.uClockResolution/1000*info.uMinClockTicks;
end;


procedure TDD1322Interface.outdac(num,j:word);
var
  error:integer;
begin
  DD132X_PutAOValue(HDD1322,num,j,error);
end;

function TDD1322Interface.outDIO(dev,port,value: integer): integer;
var
  error:integer;
begin
  DD132X_PutDOValues(HDD1322,value,error);

end;

function TDD1322Interface.inADC(n:integer):smallint;
begin
end;

function TDD1322Interface.inDIO(dev,port:integer):integer;
var
  dwValues:DWORD;
  error:integer;
  res:BOOL;
begin
  res:=DD132X_GetDIValues(HDD1322,dwValues,error);
  result:=dwValues;
end;



procedure TDD1322Interface.nextSample;assembler;
asm
     push  esi
     mov   esi,Ptab
     xor   eax,eax
     mov   ax,[esi]              {lire un point}

     add   esi,2
     cmp   esi,Ptabfin           {incrémenter Ptab}
     jl    @@1                   {mais si la fin est atteinte}
     mov   esi,Ptab0             {ranger l'adresse de début}
@@1: mov   Ptab,esi

     mov   word ptr wsample,ax

     cmp   FuseTag,0
     je    @@2
     sar   ax,2

@@2: mov   word ptr wsampleR,ax

@fin:pop   esi
end;

{****************** Synchro mode numérique Plus sans stim *********************}
{Avec FuseTagStart, l'ADC est en mode circulaire. On teste la voie start en permanence.
 Le tag est sur bit0 et le start est sur bit1
 La stimulation n'est pas possible dans ce mode
}

procedure TDD1322Interface.DoNumPlus;
var
  i,j:integer;
begin
  GI2:=getcount-1;

  for i:=GI1+1 to GI2 do
  begin
    nextSample;
    if not Ftrig then
      begin
        if (i>nbAv) and  not oldSyncNum and (wsample[0] and 2<>0) then
          begin
            TrigDate:=i div nbvoie*nbvoie;
            Ftrig:=true;
            for j:=trigDate-nbAv to i do copySample(j);
          end;
        oldSyncNum:=wsample[0] and 2<>0;
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
            oldSyncNum:=wsample[0] and 2<>0;
          end;
      end;
  end;

  GI1:=GI2;

end;


{Attention: doNumPlusStim est aussi appelée sans stim si not FuseTagStart
}
procedure TDD1322Interface.doNumPlusStim;
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

    if i=nextSeq-1 then
      begin
        GI1:=-1;
        GI2:=0;
        terminer;

        GI1x:=-1;

        Fwaiting:=true;
        exit;
      end;
  end;

  GI1:=GI2;

  if acqInf.Fstim then
  begin
    GI2x:=getCount2;
    for i:=GI1x+1 to GI2x do
      begin
        j:=cntStoreDac mod nbdac;
        if (cntStoreDac>=0) and (cntStoreDac<nbptStim)
          then Jhold1[j]:=nextSampleDac;
        storeDac(Jhold1[j]);
      end;

    AffDebug('CntStoreDac='+Istr(cntStoreDac)+' GI1x+1='+Istr(GI1X+1)+' count2='+Istr(GI2X),0);
    GI1x:=GI2x;

  end;
end;

function TDD1322Interface.RangeString:AnsiString;
begin
  result:='-10 volts to +10 volts';
end;

function TDD1322Interface.MultiGain:boolean;
begin
  result:=false;
end;

function TDD1322Interface.GainLabel:AnsiString;
begin
  result:='Range';
end;

function TDD1322Interface.nbGain;
begin
  result:=1;
end;

function TDD1322Interface.channelRange:boolean;
begin
  result:=false;
end;

procedure TDD1322Interface.GetOptions;
begin
  DD1322options.execution(self);
  {messageCentral('PeriodeMini='+Estr(periodeMini,3)+crlf+
                 'PeriodeElem='+Estr(periodeElem,3)     ); }
end;

procedure TDD1322Interface.setDoAcq(var procInt:ProcedureOfObject);
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
        MSimmediat, MSinterne:
           if not WaitMode
             then ProcInt:=doInterne
             else ProcInt:=doNumPlusStim;

        MSnumPlus, MSnumMoins:
          if not Fstim then
            begin
              if FuseTagStart
                then ProcInt:=doNumPlus
                else ProcInt:=doNumPlusStim;
            end
          else ProcInt:=doNumPlusStim;

        MSanalogAbs:
          if voieSync>Qnbvoie then
            begin
              ProcInt:=DoAnalogAbs1;
            end
          else ProcInt:=DoAnalogAbs;

        else ProcInt:=nil;
      end;
  end;
end;


procedure TDD1322Interface.initcfgOptions(conf:TblocConf);
begin
  with conf do
  begin
    setvarconf('UseTagStart',FUseTagStart,sizeof(FUseTagStart));
  end;
end;

function TDD1322Interface.TagMode:TtagMode;
begin
  if FuseTagStart
    then result:=tmDigidata
    else result:=tmNone;
end;

function TDD1322Interface.tagShift:integer;
begin
  if FuseTagStart
    then result:=2
    else result:=0;
end;

function TDD1322Interface.TagCount:integer;
begin
  if FuseTagStart
    then result:=2
    else result:=0;
end;

function TDD1322Interface.getMinADC:integer;
begin
  if FuseTagStart
    then result:=-8192
    else result:=-32768;
end;

function TDD1322Interface.getMaxADC:integer;
begin
  if FuseTagStart
    then result:=8191
    else result:=32767;
end;

function TDD1322interface.GcalibAdc(n: integer): float;
begin
  result:=Gadc;
end;

function TDD1322interface.GcalibDac(n: integer): float;
begin
  result:=Gdac[n];
end;

function TDD1322interface.OffcalibAdc(n: integer): integer;
begin
  if FuseTagStart
    then result:=OFFadc div 4
    else result:=OFFadc;
end;

function TDD1322interface.OffcalibDac(n: integer): integer;
begin
  result:=OFFdac[n];
end;



procedure TDD1322interface.Calibrate;
begin
  DD132X_Calibrate(hDD1322,CalibrationData,Calibrationerror);

  if CalibrationError<>0
    then messageCentral('Unable to calibrate Digidata 1322 ')
  else
  begin
    CopyCalibrationData;
    DisplayInfo;
  end;
end;

procedure TDD1322interface.CopyCalibrationData;
begin
  with CalibrationData do
  begin
    Gadc:=dADCGainRatio;
    OFFadc:=nADCOffset;

    OFFdac[0]:= anDACOffset[1];
    Gdac[0]:=   adDACGainRatio[1];
    OFFdac[1]:= anDACOffset[2];
    Gdac[1]:=   adDACGainRatio[2];
  end;
end;


procedure TDD1322interface.displayInfo;
begin
  with info,CalibrationData do
  messageCentral('byAdaptor='+Istr(byAdaptor)+CRLF+
                 'byTarget='+Istr(byTarget)+CRLF+
                 'byImageType='+Istr(byImageType)+CRLF+
                 'byResetType='+Istr(byResetType)+CRLF+
                 'szManufacturer='+tabToString(szManufacturer,16)+CRLF+
                 'szName='+tabToString(szName,32)+CRLF+
                 'szProductVersion='+tabToString(szProductVersion,16)+CRLF+
                 'szFirmwareVersion='+tabToString(szFirmwareVersion,16)+CRLF+
                 'uInputBufferSize='+Istr(uInputBufferSize)+CRLF+
                 'uOutputBufferSize='+Istr(uOutputBufferSize)+CRLF+
                 'uSerialNumber='+Istr(uSerialNumber)+CRLF+
                 'uClockResolution='+Istr(uClockResolution)+CRLF+
                 'uMinClockTicks='+Istr(uMinClockTicks)+CRLF+
                 'uMaxClockTicks='+Istr(uMaxClockTicks)+CRLF+
                 '         -Calibration data:'+CRLF+
                 'dADCGainRatio='+Estr(dADCGainRatio,6)+CRLF+
                 'nADCOffset='+Istr(nADCOffset)+CRLF+
                 'anDACOffset0='+Istr(anDACOffset[1])+CRLF+
                 'adDACGainRatio0='+Estr(adDACGainRatio[1],6)+CRLF+
                 'anDACOffset1='+Istr(anDACOffset[2])+CRLF+
                 'adDACGainRatio1='+Estr(adDACGainRatio[2],6)
                 );
end;


var
  error:integer;


procedure TDD1322interface.setVSoptions;
begin
  FuseTagStart:=true;

end;

function TDD1322interface.isWaiting: boolean;
begin
  result:=Fwaiting;
end;

function TDD1322interface.deviceCount: integer;
begin
  result:=1;
end;

function TDD1322interface.ADCcount(dev:integer): integer;
begin
  result:=16;
end;

function TDD1322interface.DACcount(dev:integer): integer;
begin
  result:=2;
end;


function TDD1322interface.DigiInCount(dev:integer): integer;
begin
  result:=0;
end;

function TDD1322interface.DigiOutCount(dev:integer): integer;
begin
  result:=1;
end;

function TDD1322interface.bitInCount(dev:integer): integer;
begin
  result:=2;
end;

function TDD1322interface.bitOUTCount(dev:integer): integer;
begin
  result:=16;
end;


procedure TDD1322interface.GetPeriods(PeriodU: float; nbADC, nbDI, nbDAC,
  nbDO: integer; var periodIN, periodOut: float);
var
  p:float;
begin
  if nbADC<1 then nbADC:=1;
  {periodU est la période par canal souhaitée}
  p:=periodU*1000/nbADC;                { période globale en microsecondes}
  p:=round(p/periodeElem)*periodeElem;  { doit être un multiple de periodeElem }
  if p<periodeMini then p:=periodeMini; { doit être supérieure à periodeMini }
  periodIN:=p*nbADC/1000;               { période calculée en millisecondes }
  periodOut:=p*(nbDAC+nbDO)/1000;
end;


function TDD1322interface.getValue(Device, tpIn, physNum: integer; var value: smallint): boolean;
begin

end;

function TDD1322interface.setValue(Device, tpOut, physNum, value: integer): boolean;
var
  error:integer;
begin
   case tpOut of
     0: if (physNum=0) or (physNum=1) then DD132X_PutAOValue(HDD1322,PhysNum,value,error);
     1: DD132X_PutDOValues(HDD1322,value,error);
   end;
end;

procedure init1322;
var
  Version: TOSVersionInfo;
  error:integer;
  res:Dword;

begin
  version.dwOSVersionInfoSize:=sizeof(version);
  getVersionEx(Version);

  if (version.dwPlatformId<>VER_PLATFORM_WIN32_NT) or not initDD132xlib then
  begin
    {messageCentral('initDD132xlib = false');}
    exit;
  end;

  initDD132x_Info(info);

  res:=DD132x_findDevices(info,1,error);  {renvoie toujours 0 !}
  if {(info.uSerialNumber=0) or} (info.uClockResolution=0) then
  begin
    {messageCentral('(info.uSerialNumber=0) or (info.uClockResolution=0)');}
    exit;
  end;

  hDD1322 := DD132X_OpenDevice(Info.byAdaptor, Info.byTarget, error);
  if (error<>0) or (hDD1322=0) then
  begin
    {messageCentral('OpenDevice=false    error='+Istr(error));}
    exit;
  end;

  RegisterBoard(tabToString(info.szName,32),pointer(TDD1322interface));

  {Calibration de la carte}

  fillchar(CalibrationData,sizeof(CalibrationData),0);
  CalibrationData.uLength:=sizeof(CalibrationData);

  DD132X_GetCalibrationData(hDD1322,CalibrationData,CalibrationError);
  { Si les data sont correctes, on les garde sinon on essaie de calibrer }
  if (CalibrationError<>0) or (CalibrationData.dADCGainRatio=0) or (CalibrationData.adDACGainRatio[1]=0) or (CalibrationData.adDACGainRatio[2]=0) then
  begin
    DD132X_Calibrate(hDD1322,CalibrationData,CalibrationError);
    if CalibrationError<>0 then  messageCentral('Unable to get DD1322 calibration data ');
  end;

end;


Initialization
AffDebug('Initialization DD1322brd',0);
{$IFNDEF WIN64}
Init1322;
{$ENDIF}

finalization


if hDD1322<>0 then DD132X_CloseDevice(hDD1322,error);

end.
