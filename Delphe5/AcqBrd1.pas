unit AcqBrd1;

interface
{$IFDEF FPC} {$mode delphi} {$DEFINE AcqElphy2} {$A1} {$Z1} {$ENDIF}

{ AcqBrd1 est le driver de la digidata 1200
  C'est aussi l'ancêtre des autres drivers
    voir DD1322brd
         CBbrd1
         DemoBrd1
         ITCbrd
}

uses windows,classes,sysutils,
     util1,varconf1,
     ParSystem,stmdef,

     {$IFNDEF WIN64}wdigi1, isabuf1 , {$ENDIF}
     debug0,
     DigiOpt0,
     DataGeneFile;

{ La digidata 1200 ne fonctionne que sous Window 95 ou 98

  Il faut installer le programme résidant Dmares au démarrage

  Pour cela, on modifie Autoexec.bat en ajoutant les lignes

  SET DAC2DIGI1200=TRUE
  C:\ELPHY\DMARES.EXE

  en supposant que Elphy et Dmares soient dans le répertoire c:\elphy

  Il faut que ces lignes soient après suffisamment de drivers DOS pour que l'addresse
  du buffer installé soit au dessus de $1000:0000 , soit au dessus des premiers 64K

}



type
  TdataFormat=(Fdigi1200,F12bits,Fdigi1322,F16bits);
  TdacFormat=(DacFdigi1200,DAcF12bits,DacF1322);


  TacqInterface=
    class
    private
      canalDMA1,canalDMA2:integer;         {canaux DMA: 5, 6 ou 7}

      oldStimCount:integer;

    protected
      boardFileName:AnsiString;

      tabDma1,tabDma2:PtabEntier;      {buffers Dma ADC et DAC}
      nbpt0Dma,FnbptDacDma:integer;    {leurs tailles}

      GI1,GI2,GI1x,GI2x:integer;


      nbSeqOK:integer;

      FwaitRestart:boolean; { en mode trig externe, signale que l'acq est en attente }
      FcanRestart:boolean;  { en mode trig externe, signale que l'acq peut repartir }
                            { ces flags sont associés à restart, restartAfterWait et canRestart}
                            { Ils ne sont utilisés que par cbBrd1 }


      procedure initPadc;
      procedure initPdac;
      procedure loadDmaDac;

      function getCount:integer;virtual;
      function getCount2:integer;virtual;

      procedure doContinuous;
      procedure doInterne;
      procedure doAnalogAbs;
      procedure doAnalogAbs1;
      procedure doNumPlus;
      procedure doNumPlusStim;


      procedure storeWsample;virtual;
      procedure nextSample;virtual;
      procedure CopySample(i:integer);virtual;

      procedure restartAfterWait;virtual;
      procedure restart;

    public
      FuseTagStart:boolean; { utilisé par DD1322 et ITC }
      TriggerInput:integer; { utilisé par ITC }



      constructor create(var st1:driverString);virtual;

      procedure init0;virtual;    { appelé avant initProcess0 et initProcess }
      procedure init;virtual;     { appelé après initProcess0 et initProcess }
      procedure lancer;virtual;

      procedure terminer;virtual;

      function dataFormat:TdataFormat;virtual;
      function DacFormat:TdacFormat;virtual;

      property nbptDacDma:integer read FnbptDacDma;


      function PeriodeElem:float;virtual;
      function PeriodeMini:float;virtual;

      function GcalibAdc(n:integer):float;virtual;
      function GcalibDac(n:integer):float;virtual;
      function OffcalibAdc(n:integer):integer;virtual;
      function OffcalibDac(n:integer):integer;virtual;



      procedure outdac(num,j:word);virtual;
      function outDIO(dev,port,value: integer):integer;virtual;
      function inADC(n:integer):smallint;virtual;
      function inDIO(dev,port:integer):integer;virtual;

      function RAngeString:AnsiString;virtual;
      function MultiGain:boolean;virtual;
      function GainLabel:AnsiString;virtual;
      function nbGain:integer;virtual;

      function channelRange:boolean;virtual;

      procedure setDoAcq(var procInt:ProcedureOfObject);virtual;

      procedure GetOptions;virtual;

      procedure initCfgOptions(conf:Tblocconf);virtual;
      procedure LoadOptions;
      procedure SaveOptions;

      function TagMode:TtagMode;virtual;
      function TagShift:integer;virtual;
      function TagCount:integer;virtual;


      function Special1(mask:word;delay:integer):word;virtual;
      procedure canRestart;

      function getMinADC:integer;virtual;
      function getMaxADC:integer;virtual;

      procedure setVSoptions;virtual;

      function isWaiting:boolean; virtual;
      procedure relancer;virtual;

      procedure saveDMA1asDac2File(st:AnsiString);
      procedure saveDMA2asDac2File(st:AnsiString);

      function ADCcount(dev:integer):integer;virtual;     { nb ADC par device  }
                                                          { les numéros ne sont pas forcément compris entre 0 et ADCcount-1
                                                            voir CyberK.pas }
      function DACcount(dev:integer):integer;virtual;     { nb DAC par device  }

      function DigiOutCount(dev:integer):integer;virtual; { nb Digi Out par device }
      function DigiInCount(dev:integer):integer;virtual;  { nb Digi In par device }

      function bitINCount(dev:integer):integer;virtual;   { nb bits par entrée digi }
      function bitOUTCount(dev:integer):integer;virtual;  { nb bits par sortie digi }

      function deviceCount:integer;virtual;

      function CheckParams:boolean;virtual;
      function nbVoieAcq(n:integer):integer;virtual;

      procedure GetPeriods(PeriodU:float;nbADC,nbDI,nbDAC,nbDO:integer;var periodIN,periodOut:float);virtual; {ms}
      function AgPeriod(PeriodU:float;nbADC,nbDI,nbDAC,nbDO:integer):float;virtual; {ms}

      procedure initGlobals;virtual;// appelé par TthreadInt.create

      function setValue(Device,tpOut,physNum,value:integer):boolean;virtual;
      function getValue(Device,tpIn,physNum:integer;var value:smallint):boolean;virtual;

      procedure storeDac(x:word);virtual;

      procedure DisplayErrorMsg;virtual;
      function getNrnSymbolNames(cat: integer): TstringList;virtual;
      function PhysicalOutputString:AnsiString;virtual;
      procedure GetPhysicalInfo(num:integer;var tp:ToutputType; var Outnum:integer;var BitNum:integer);virtual;

      procedure installQKS;virtual;                 { CyberK a une seule frequence d'échantillonnage}
      function FixedPeriod:boolean;virtual;         {       + une liste de facteurs de sous-échantillonage }
      function getFixedPeriod:float;virtual;
      function ElphyFormatOnly:boolean;virtual;

      function RTmode:boolean;virtual;

      function DxuSpk:float;virtual;
      function UnitXspk:AnsiString;virtual;


      function getSampleIndex:integer;virtual;
      function nbVoieSpk:integer;virtual;

      { BuildInfo ne fait rien sauf pour RTneuron }
      procedure BuildInfo(var conf:TblocConf;lecture:boolean);virtual;

      procedure ProgRestart;virtual; { Restart quand le trigger est msProgram }
      function IsWaitingTrig: boolean;virtual;
      procedure setThresholds;virtual;

      function CanAcqPhotons: boolean;virtual;
      procedure ShowRTconsole;virtual;
      function setDout(num: integer; w: boolean): integer;virtual;
    end;

  TinterfaceClass=class of TacqInterface;

var
  Board:TacqInterface;


implementation

uses acqCom1,
     acqDef2,acqInf2,stimInf2,
     FdefDac2;

constructor TacqInterface.create;
begin
  canalDMA1:=5;
  canalDMA2:=6;

  boardFileName:='DD1200';
end;

procedure TacqInterface.init0;
begin
end;

procedure TacqInterface.init;
begin
 {$IFNDEF WIN64}
  tabDma1:=tabDma1ISA;
  tabDma2:=tabDma2ISA;

  nbVoie:=AcqInf.nbVoieAcq;
  nbpt0DMA:=tailleTabDma1ISA div (2*2*nbVoie)* (2*nbvoie);
  FnbptDacDMA:=tailleTabDma2ISA div 2;

  wdigi1.init;

  GI1:=-1;
  initPadc;
  GI1x:=-1;

  cntStim:=0;
  cntStoreDac:=0;


  initPdac;
  loadDmaDAC;
{$ENDIF}
end;

procedure TacqInterface.initPadc;
var
  i,ofs:integer;
begin

  ofs:=0;
  with AcqInf do
  for i:=1 to nbvoieAcq do
  begin
    AgSampleSizes[i-1]:=SampleSize[i];
    AgOffsets[i-1]:=ofs;
    ofs:=ofs+SampleSize[i];
  end;
  AgTotSize:=ofs;

  Ptab0:=tabDMA1;
  PtabFin:=@tabDMA1^[nbpt0DMA];
  Ptab:=Ptab0;

  Pmain0:=mainBuf;
  intG(PmainFin):=intG(mainBuf) + mainBufSize;
  Pmain:=mainBuf;

  cntDisp:=-1;
  {messageCentral('initPadc MainBuf='+Istr(intG(mainBuf))+
                 'mainBufIndex0='+Istr(mainBufIndex0)  ); }



end;


procedure TacqInterface.initPdac;
begin
  PtabDac0:=tabDMA2;
  PtabDacFin:=@tabDMA2^[nbptDACDMA];
  PtabDac:=tabDMA2;

  initPmainDac;
end;

procedure TacqInterface.loadDmaDac;
var
  i,j,k,index:integer;
  isiStim1,nbptStim:integer;
  nbdac:integer;

begin
  if not acqInf.Fstim then exit;
  if not assigned(tabDma2) then exit;

  if (AcqInf.ModeSynchro in [MSinterne,MSimmediat]) and
      not (acqInf.waitmode)
    then isiStim1:=paramStim.IsiPts
    else isiStim1:=maxEntierLong;

  nbptStim:=paramStim.nbpt1;
  nbdac:=paramStim.ActiveChannels;

  initPdac;

  if acqInf.continu then
    for i:=0 to nbptDACDMA-1 do storeDac(nextSampleDac)
  else
    for i:=0 to nbptDACDMA-1 do
     begin
       j:=i mod nbdac;
       k:=i mod isiStim1;
       if (k>=0) and (k<nbptStim)
         then Jhold1[j]:=nextSampleDac;
       storeDac(Jhold1[j]);
     end;


  {for i:=0 to nbptDACDMA-1 do storeDac(random(16000)-8000);}
end;

procedure TacqInterface.lancer;
var
  i:integer;
  VoiesAcq,gains:T16bytes;
  pDac:float;
begin
 {$IFNDEF WIN64}
  with AcqInf do
  begin
    for i:=1 to nbvoieAcq do
    begin
      VoiesAcq[i]:=QvoieAcq[i];
      gains[i]:=Qgain[i];
    end;
    FwaitRestart:=false;

    if paramStim.ActiveChannels>0
      then pDac:=paramStim.periodeParDac*1000/paramStim.ActiveChannels
      else pDac:=0;
    wdigi1.lancer(periodeUS,pDac,
                  realTab1,realtab2,nbpt0DMA,NbptDacDma,
                  nbvoieAcq,canalDMA1,canalDMA2,
                  VoiesAcq,gains,
                  Fstim,Fstim and (paramStim.ActiveChannels=2),
                  (ModeSynchro=MSnumPlus) and Fstim and not continu
                  );
  end;
   {$ENDIF}
end;

procedure TacqInterface.terminer;
begin
{$IFNDEF WIN64}
  wdigi1.terminer;
{$ENDIF}
  resetPmainDac;
end;

function TacqInterface.getCount:integer;
begin
{$IFNDEF WIN64}
  result:=wdigi1.getCount;
{$ENDIF}
end;

function TacqInterface.getCount2:integer;
begin
  result:=trunc(GI2/Pfactor)-100;
end;


function TacqInterface.dataFormat:TdataFormat;
begin
  result:=Fdigi1200;
end;

function TacqInterface.DacFormat:TdacFormat;
begin
  result:=DacFdigi1200;
end;


function TacqInterface.PeriodeElem:float;
begin
  result:=0.25;
end;

function TacqInterface.PeriodeMini:float;
begin
  result:=3;
end;


procedure TacqInterface.outdac(num,j:word);
begin
{$IFNDEF WIN64}
  wdigi1.outDac(num,j);
{$ENDIF}
end;

function TacqInterface.outDIO(dev,port,value: integer): integer;
begin
{$IFNDEF WIN64}
  wdigi1.outDIO(value);
{$ENDIF}
end;

function TacqInterface.inADC(n:integer):smallint;
begin
{$IFNDEF WIN64}
  result:=wdigi1.inADC(n);
{$ENDIF}
end;

function TacqInterface.inDIO(dev,port:integer):integer;
begin
{$IFNDEF WIN64}
  result:=wdigi1.inDIO;
{$ENDIF}
end;


{ storeADC range l'échantillon x dans MainBuf et incrémente le pointeur de
  rangement
  StoreWsample fait la même chose avec Wsample
  La durée mesurée sur P4 à 3 Ghz est inférieure à 8 nanosecondes.

  La même procédure sans l'assembleur prend 27 nanosecondes
}

procedure TacqInterface.storeWsample;assembler;
asm
 {$IFNDEF WIN64}
     push  edi

     mov  ax,word ptr wsample

     mov   edi,Pmain             {destination}

     mov   [edi],ax              {ranger wsample dans mainBuf}

     add   edi,2
     cmp   edi,Pmainfin          {incrémenter Pmain}
     jl    @@2                   {mais si la fin est atteinte}
     mov   edi,Pmain0            {ranger l'adresse de début}

@@2: mov   Pmain,edi
     inc   cntDisp               {incrémenter cntDisp}

     pop   edi
{$ELSE}
     push  rdi

     mov  ax,word ptr wsample

     mov   rdi,Pmain             {destination}

     mov   [rdi],ax              {ranger wsample dans mainBuf}

     add   rdi,2
     cmp   rdi,Pmainfin          {incrémenter Pmain}
     jl    @@2                   {mais si la fin est atteinte}
     mov   rdi,Pmain0            {ranger l'adresse de début}

@@2: mov   Pmain,rdi
     inc   cntDisp               {incrémenter cntDisp}

     pop   rdi

{$ENDIF}
  {
  mainBuf^[cntDisp+1]:=x;
  inc(cntDisp);}
end;



{ NextSample travaille uniquement sur des variables globales.
Le fait de transformer la procédure en proc. virtuelle fait perdre environ
12% en temps.
}
procedure TacqInterface.nextSample;assembler;
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
     sar   ax,4
     mov   word ptr wsampleR,ax           {et l'échantillon décalé pour digidata}

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
     sar   ax,4
     mov   word ptr wsampleR,ax           {et l'échantillon décalé pour digidata}

@fin:pop   rsi
{$ENDIF}
end;

{ CopySample va chercher un point dans le buffer DMA afin de le copier dans MainBuf
  utilisé dans les modes pré-trigger.

  Pour les cartes CB, le point doit subir une conversion
  Pour les cartes ITC, la structure des buffers est plus compliquée
  D'où la surcharge pour CB et ITC
}


procedure TacqInterface.CopySample(i:integer);
begin
  wsample[0]:=tabDMA1^[i mod nbpt0DMA];
  storeWsample;
end;

{************************* Mode continu *************************************}
{En mode continu, l'ADC et le DAC fonctionnent en mode circulaire. }
procedure TacqInterface.doContinuous;
var
  i,nbv:integer;

begin
  GI2:=getCount-1;

  for i:=GI1+1 to GI2 do
  begin
    nextSample;
    storeWsample;
  end;
  GI1:=GI2;

  if withStim then
    begin
      GI2x:=getCount2;
      for i:=GI1x+1 to GI2x do storeDac(nextSampleDac);
      GI1x:=GI2x;
    end;

end;


{****************** Synchro mode interne *************************************}
{En mode interne, l'ADC et le DAC fonctionnent en mode circulaire.
 Le mode est gap free. Il est très proche du mode continu.
 Il y a quelques contraintes sur les périodes ADC et DAC.
}

procedure TacqInterface.doInterne;
var
  k,index,ideb:integer;
  i,j:integer;

const
  flag:boolean=false;

begin
  GI2:=getCount-1;

  for i:=GI1+1 to GI2 do
  begin
    k:=i mod isi;
    nextSample;
    if (k>=0) and (k<nbpt) then storeWsample;

    (*
    if (k=0) then                       {pour Tester la vitesse de transfert}
      begin
        board.outdac(0,5000*ord(flag));
        visualStim.FXcontrol.SetSyncLine(flag,flag);
        flag:=not flag;
      end;
     *)
  end;

  if withStim then
    begin
      GI2x:=getCount2;

      for i:=GI1x+1 to GI2x do
        begin
          j:=cntStoreDac mod nbdac;
          {ideb:=i+nbptDacDma-1;}
          k:={ideb} cntStoreDac mod isiStim;
          if (k>=0) and (k<nbptStim) then Jhold1[j]:=nextSampleDac;
          storeDac(Jhold1[j]);
        end;
    AffDebug('CntStoreDac='+Istr(cntStoreDac)+' GI1x+1='+Istr(GI1X+1)+' count2='+Istr(GI2X),15);
    {
    GI2x:=getCount2;
    for i:=GI1x+1 to GI2x do
      begin
        j:=cntStoreDac mod nbdac;
        if (cntStoreDac>=0) and (cntStoreDac<nbptStim)
          then Jhold1[j]:=nextSampleDac;
        storeDac(Jhold1[j]);
      end;
     }

      GI1x:=GI2x;
    end;

  GI1:=GI2;
end;


{****************** Synchro mode numérique Plus sans stim *********************}
{Ce mode ne peut fonctionner que sur DigiData1200}
{L'ADC est en mode circulaire. On teste la voie start en permanence.
 Le tag est sur bit0 et le start est sur bit1}

procedure TacqInterface.DoNumPlus;
var
  i,j:integer;
  x:word;
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

{****************** Synchro mode numérique Plus avec stim *********************}
{Ce mode ne peut fonctionner que sur DigiData1200}
{L'ADC est en mode circulaire. On teste la voie start en permanence comme
 précédemment. Il faut réarmer le DAC après chaque séquence. Il y a un risque de
 voir l'acquisition démarrer alors que le DAC n'est pas réarmé.
 Le tag est sur bit0 et le start est sur bit1}

procedure TacqInterface.DoNumPlusStim;
var
  i,j,k:integer;
  ideb:integer;
  ii:integer;
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

            {$IFNDEF WIN64}
            wdigi1.stopDac;
            {$ENDIF}

            inc(baseIndex,nbptStim);
            initPdac;
            loadDMADac;

            {$IFNDEF WIN64}
            wdigi1.rearmDac;
            {$ENDIF}

            GI1x:=-1;
            GI1:=getcount-1;
            for ii:=i+1 to GI1 do nextSample;
            trigdate:=maxEntierLong;

            exit;
          end
        else
          begin
            storeWsample;
            oldSyncNum:=wsample[0] and 2<>0;
          end;
      end;
  end;
  GI1:=GI2;

  GI2x:=trunc((GI2-trigDate)/Pfactor)-1;

  for j:=GI1x+1 to GI2x do
    begin
      k:=nbdac;
      ideb:=j+nbptDacDma-1;
      if (ideb>=0) and (ideb<nbptStim) then Jhold1[k]:=nextSampleDac;
      storeDac(Jhold1[k]);
    end;
  if GI2x>GI1x then GI1x:=GI2x;
end;



{****************** Synchro mode analogique absolu ***************************}
{l'ADC est en mode circulaire. On teste la voie synchro en permanence.
 La voie synchro doit faire partie des voies acquises. Sinon voir DoAnalogAbs1
}

procedure TacqInterface.DoAnalogAbs;
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

procedure TacqInterface.DoAnalogAbs1;
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


function TacqInterface.RAngeString:AnsiString;
begin
  result:='1|2|4|8';
end;

function TacqInterface.MultiGain:boolean;
begin
  result:=true;
end;

function TacqInterface.GainLabel:AnsiString;
begin
  result:='Gain';
end;

function TacqInterface.nbGain;
begin
  result:=4;
end;

function TacqInterface.channelRange:boolean;
begin
  result:=false;
end;

procedure TacqInterface.setDoAcq(var procInt:ProcedureOfObject);
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
        MSinterne,MSimmediat: ProcInt:=doInterne;
        MSnumPlus:
          if not Fstim
            then ProcInt:=doNumPlus
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

procedure TacqInterface.GetOptions;
begin
  DigiOptions.execution(canalDma1,canalDma2);
end;

procedure TacqInterface.relancer;
begin
  GI1:=-1;

  Ptab0:=tabDMA1;
  PtabFin:=@tabDMA1^[nbpt0DMA];
  Ptab:=Ptab0;

  if acqInf.Fstim then
  begin
    GI1x:=-1;
    initPdac;
    loadDmaDAC;
  end;

  lancer;
end;


procedure TacqInterface.LoadOptions;
var
  conf:TblocConf;
begin
  conf:=TblocConf.create('BrdOpt');

  initCfgOptions(conf);

  conf.loadFromFile(AppData + BoardFileName+'.OPT');
  conf.free;
end;


procedure TacqInterface.SaveOptions;
var
  conf:TblocConf;
begin
  conf:=TblocConf.create('BrdOpt');

  initCfgOptions(conf);

  conf.SaveToFile( AppData + BoardFileName+'.OPT');
  conf.free;
end;


procedure TacqInterface.initcfgOptions(conf:TblocConf);
begin
  with conf do
  begin
    setvarconf('Dma1',canalDMA1,sizeof(canalDma1));
    setvarconf('Dma2',canalDMA2,sizeof(canalDma2));
  end;
end;

function TacqInterface.TagShift:integer;
begin
  result:=4;
end;

function TacqInterface.TagMode:TtagMode;
begin
  result:=tmDigiData;
end;

function TacqInterface.TagCount:integer;
begin
  result:=2;
end;

procedure TacqInterface.restart;
begin
  if FwaitRestart then RestartAfterWait;
  FwaitRestart:=false;
  FcanRestart:=false;
end;

procedure TacqInterface.CanRestart;
begin
  FcanRestart:=true;
end;

procedure TacqInterface.RestartAfterWait;
begin
end;

function TacqInterface.Special1(mask:word;delay:integer):word;
begin
  result:=0;
end;

function TacqInterface.getMinADC:integer;
begin
  result:=-2048;
end;

function TacqInterface.getMaxADC:integer;
begin
  result:=2047;
end;



function TacqInterface.GcalibAdc(n: integer): float;
begin
  result:=1;
end;

function TacqInterface.GcalibDac(n: integer): float;
begin
  result:=1;
end;

function TacqInterface.OffcalibAdc(n: integer): integer;
begin
  result:=0;
end;

function TacqInterface.OffcalibDac(n: integer): integer;
begin
  result:=0;
end;

procedure TacqInterface.setVSoptions;
begin

end;


function TacqInterface.isWaiting: boolean;
begin
  result:=false;
end;

procedure TacqInterface.saveDMA1asDac2File(st: AnsiString);
begin
  SaveArrayAsDac2File(st,tabDma1^,nbpt0Dma,G_smallint);
end;

procedure TacqInterface.saveDMA2asDac2File(st: AnsiString);
begin
  SaveArrayAsDac2File(st,tabDma2^,FnbptDacDma,G_smallint);
end;


function TacqInterface.deviceCount: integer;
begin
  result:=1;
end;

function TacqInterface.ADCcount(dev:integer): integer;
begin
  result:=16;
end;

function TacqInterface.DACcount(dev:integer): integer;
begin
  result:=0;
end;


function TacqInterface.DigiInCount(dev:integer): integer;
begin
  result:=0;
end;

function TacqInterface.DigiOutCount(dev:integer): integer;
begin
  result:=0;
end;


function TacqInterface.bitINCount(dev:integer): integer;
begin
  result:=16;
end;

function TacqInterface.bitOUTCount(dev:integer): integer;
begin
  result:=16;
end;




function TacqInterface.CheckParams: boolean;
begin
  result:=true;
end;


function TacqInterface.nbVoieAcq(n:integer): integer;
begin
  result:=n;
end;

procedure TacqInterface.GetPeriods(PeriodU:float;nbADC,nbDI,nbDAC,nbDO:integer;var periodIN,periodOut:float);
var
  p:float;
begin
  if nbADC<1 then nbADC:=1;
  if nbDac<1 then nbDac:=1;

  {periodU est la période par canal souhaitée}
  p:=periodU*1000/nbADC;                { période globale en microsecondes}
  p:=round(p/periodeElem)*periodeElem;  { doit être un multiple de periodeElem }
  if p<periodeMini then p:=periodeMini; { doit être supérieure à periodeMini }
  periodIN:=p*nbADC/1000;               { période calculée en millisecondes }
  periodOut:=p*nbDAC/1000;
end;

function TacqInterface.AgPeriod(PeriodU: float; nbADC, nbDI, nbDAC,nbDO: integer): float;
var
  pIn,pOut:float;
begin
  {valable pour la DD1200 et la DD1322}
  {periodU est la période par canal souhaitée, nbDI=0 }

  getPeriods(PeriodU,nbADC,nbDI,nbDAC,nbDO,pIn,pOut);

  result:= ppcm(nbAdc+nbDI,nbDac+nbDO) * pIn/(nbADC+nbDI) ;
end;

procedure TacqInterface.initGlobals;
var
  pDac:float;
begin
  with acqinf do
  begin
    isi:=isiPts;
    if Fstim then isiStim:=paramStim.isiPts;

    withStim:=Fstim;

    Ftrig:=false;
    Farmed:=true;

    trigDate:=100000;


    voieSync:=voieSynchro;
    seuilP:=seuilPlusPts;
    seuilM:=seuilMoinsPts;
    IntervalT:=IntervalTest;

    nbvoie:=nbvoieAcq;
    nbpt:=Qnbpt*nbvoie;
    nbAv:=QnbAv*nbvoie;
    nbAp:=nbpt-nbAv;

    nbptStim:=paramStim.nbpt1;

    pDac:=paramStim.periodeParDac*1000;
    if paramStim.ActiveChannels>0 then pDac:=pDac/paramStim.ActiveChannels;
    Pfactor:=pDac/acqInf.periodeUS;

    nbdac:=paramStim.ActiveChannels;

    IntTime:=0;
    IntTimeMax:=0;

    nbInt:=0;
  end;
end;

function TacqInterface.setValue(Device,  tpOut, physNum, value: integer):boolean;
begin

end;

function TacqInterface.getValue(Device,  tpIn,physNum: integer;var value: smallint):boolean;
begin

end;

procedure TacqInterface.storeDac(x:word);assembler;
asm
 {$IFNDEF WIN64}
@@1: push  edi
     mov   edi,PtabDac          {destination}
     mov   [edi],x              {ranger dans Buffer}

     add   edi,2
     cmp   edi,PtabDacfin        {incrémenter }
     jl    @@2                   {mais si la fin est atteinte}
     mov   edi,PtabDac0          {ranger l'adresse de début}

@@2: mov   PtabDac,edi
     pop   edi

     inc cntStoreDac;
  {$ELSE}
@@1: push  rdi
     mov   rdi,PtabDac          {destination}
     mov   [rdi],x              {ranger dans Buffer}

     add   rdi,2
     cmp   rdi,PtabDacfin        {incrémenter }
     jl    @@2                   {mais si la fin est atteinte}
     mov   rdi,PtabDac0          {ranger l'adresse de début}

@@2: mov   PtabDac,rdi
     pop   rdi

     inc cntStoreDac;

  {$ENDIF}
end;



procedure TacqInterface.DisplayErrorMsg;
begin

end;

function TacqInterface.getNrnSymbolNames(cat: integer): TstringList;
begin
  result:=TstringList.create;
end;

function TacqInterface.PhysicalOutputString: AnsiString;
begin
  result:='';
end;

procedure TacqInterface.GetPhysicalInfo(num: integer; var tp: ToutputType;
  var Outnum, BitNum: integer);
begin
  tp:=TO_analog;
  OutNum:=0;
  BitNum:=0;
end;


procedure TacqInterface.installQKS;
begin

end;

function TacqInterface.FixedPeriod: boolean;
begin
  result:=false;
end;

function TacqInterface.getFixedPeriod: float;
begin
  result:=1;
end;

function TacqInterface.ElphyFormatOnly: boolean;
begin
  result:=false;
end;

function TacqInterface.RTmode:boolean;
begin
  result:=false;
end;

function TacqInterface.DxuSpk: float;
begin
  result:=0;
end;

function TacqInterface.getSampleIndex: integer;
begin
  result:=(cntDisp+1) div nbvoie -1;  { indice du dernier point d'une voie quand toutes les voies sont complètes }
end;

function TacqInterface.nbVoieSpk: integer;
begin
  result:=0;
end;


function TacqInterface.UnitXspk: AnsiString;
begin
  result:='';
end;



procedure TacqInterface.BuildInfo(var conf: TblocConf; lecture: boolean);
begin

end;

procedure TacqInterface.ProgRestart;
begin

end;

function TacqInterface.IsWaitingTrig: boolean;
begin
  result:=false;
end;

procedure TacqInterface.setThresholds;
begin

end;

function TacqInterface.CanAcqPhotons: boolean;
begin
  result:=false;
end;

procedure TacqInterface.ShowRTconsole;
begin

end;

function TacqInterface.setDout(num: integer; w: boolean): integer;
begin
  result:=0;
end;

end.
