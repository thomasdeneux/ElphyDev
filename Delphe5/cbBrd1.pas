unit CBbrd1;

interface
{$IFDEF FPC} {$mode delphi} {$DEFINE AcqElphy2} {$A1} {$Z1} {$ENDIF}

uses windows,classes,
     util1,varconf1,
     debug0,
     stmdef,AcqBrd1,cbwgs520{,cbwgs512},
     cbOpt0,dataGeneFile,
     acqCom1, AcqInterfaces,
     acqDef2,acqInf2,StimInf2
     ;


{ Driver des cartes ComputerBoards

  Pour utiliser le DAC, il faut relier les bornes 95 et 44 de la 1602.
  C'est à dire Sortie horloge ADC sur Entrée horloge DAC.
  La borne 95 est sur le 2ème cable. La 44 est sur le premier cable mais ce cable est
  sur le connecteur P3. Heureusement, la borne 44 se retrouve sur les autres connecteurs
  (voir le manuel du bornier BNC):
    borne 10 de P1
    borne 44 de P4
    borne 10 de P2
  On peut donc brancher le fil en question sur un de ces connecteurs.
  Une autre solution serait de brancher le deuxieme cable sur P4, et à l'intérieur du
  boitier BNC, de supprimer toutes les liaisons inutiles, et de faire  la liaison 44-95.
  On aurait ainsi une solution propre à l'extérieur: plus de bricolage et de fils qui se
  promènent.
  Je n'ai pas essayé.
  Il faut bien sur modifier les switchs qui mettent les sorties DAC sur les BNC E14 et E15


}
const
  cbEventTest=FALSE;  {Essai de Callback event}

var
  CBcntEvent:integer;

type
  TCBinterface = class(TacqInterface)

  private
      boardNum:integer;


      CBnbvoie:integer;

      CBnbptBuf:integer;       {taille utile du buffer ADC, peut être inférieure à la taille allouée}
      CBbuf:PtabEntier;        {buffer ADC }
      nbptBuf0:integer;        {taille allouée en points }

      CbDacNbptBuf:integer;
      CbDacBuf:PtabEntier;

      base,count0:integer;
      base2,count02:integer;

      ranges:TstringList;

      nextSeq:integer;


      FinternalStop:boolean;
      FgetCount,FgetCount2:boolean;

      CBtagThreshold1,CBtagThreshold2:integer;

      ULstat:integer;

      DAConBoard:integer;

      function getCount:integer;override;
      function getCount2:integer;override;

      procedure doNumPlus;

      procedure nextSample;override;
      procedure copySample(i:integer);override;

      procedure relancer;override;
      procedure restartAfterWait;override;

      function DyRange(Vrange:integer):float;
      function RangeValue(k:integer):integer;

   public
      CBname:AnsiString;

      SeuilSingleIO:single;
      CB16bits,CBdma:boolean;
      CBadcBitCount,CBdacBitCount:integer;
      CBbufferSize:byte;
      CBpacketSize:integer;

      constructor create(var st1:driverString);override;
      destructor destroy;override;

      procedure InitKnownBoard(st:AnsiString);

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

      function Special1(mask:word;delay:integer):word;override;

      function getMinADC:integer;override;
      function getMaxADC:integer;override;

      function nbVoieAcq(n: integer): integer;override;

      procedure GetPeriods(PeriodU: float; nbADC,nbDI,nbDAC,nbDO: integer;var periodIn,periodOut: float);override;
      function AgPeriod(PeriodU: float; nbADC, nbDI, nbDAC,nbDO: integer): float;override;

      procedure initGlobals;override;
      procedure storeDac(x:word);override;

      procedure DisplayErrorMsg;override;

      function ADCcount(dev:integer):integer;override;     { nb ADC par device }
      function DACcount(dev:integer):integer;override;     { nb DAC par device }

    end;


implementation





var
  FCBdma:boolean;
  ADCpower2,DACpower2: smallint;


procedure TCBinterface.InitKnownBoard(st:AnsiString);
begin
  if st='PCI-DAS1000' then
  begin
    CBAdcBitCount:=12;
    CBDacBitCount:=12;
    CBdma:=false;
    DacOnBoard:=0;
  end
  else
  if st='PCI-DAS1001' then
  begin
    CBAdcBitCount:=12;
    CBDacBitCount:=12;
    CBdma:=false;
    DacOnBoard:=0;
  end
  else
  if st='PCI-DAS1002' then
  begin
    CBAdcBitCount:=12;
    CBDacBitCount:=12;
    CBdma:=false;
    DacOnBoard:=0;
  end
  else
  if st='PCI-DAS1602/12' then
  begin
    CBAdcBitCount:=12;
    CBDacBitCount:=12;
    CBdma:=false;
    DacOnBoard:=2;
  end
  else
  if st='PCI-DAS1602/16' then
  begin
    CBAdcBitCount:=16;
    CBDacBitCount:=16;
    CBdma:=false;
    DacOnBoard:=2;
  end;
end;

constructor TCBinterface.create(var st1:driverString);
var
  code:integer;
  revLevel:single;

  st:AnsiString;
begin
  boardFileName:='CB';

  cbBufferSize:=1;
  NbptBuf0:=cbBufferSize*65536;

  st:=st1;
  delete(st,pos('#',st),10);
  CBname:=Fmaj(Fsupespace(st));

  delete(st1,1,pos('#',st1));
  val(st1,boardNum,code);

  ranges:=TstringList.create;

  ranges.addObject('-10 to +10 Volts',pointer(BIP10VOLTS) );

  ranges.addObject('-5 to +5 Volts',pointer(BIP5VOLTS));
  ranges.addObject('-2.5 to +2.5 Volts',pointer(BIP2PT5VOLTS));
  ranges.addObject('-1.25 to +1.25 Volts',pointer(BIP1PT25VOLTS));
  ranges.addObject('-1 to +1 Volt',pointer(BIP1VOLTS));
  ranges.addObject('-0.625 to +0.625 Volts',pointer(BIPPT625VOLTS));
  ranges.addObject('-0.5 to +0.5 Volts',pointer(BIPPT5VOLTS));
  ranges.addObject('-0.1 to +0.1 Volts',pointer(BIPPT1VOLTS));
  ranges.addObject('-0.05 to + .05Volts',pointer(BIPPT05VOLTS));
  ranges.addObject('-0.01 to +0.01 Volts',pointer(BIPPT01VOLTS));
  ranges.addObject('-0.005 to +0.005 Volts',pointer(BIPPT005VOLTS));
  ranges.addObject('-1.67 to +1.67 Volts',pointer(BIP1PT67VOLTS));

  ranges.addObject('0 to +10 Volts',pointer(UNI10VOLTS));
  ranges.addObject('0 to +5 Volts',pointer(UNI5VOLTS));
  ranges.addObject('0 to +2.5 Volts',pointer(UNI2PT5VOLTS));
  ranges.addObject('0 to +2 Volts',pointer(UNI2VOLTS));
  ranges.addObject('0 to +1.25 Volts',pointer(UNI1PT25VOLTS));
  ranges.addObject('0 to +1 Volts',pointer(UNI1VOLTS));
  ranges.addObject('0 to +0.1 Volts',pointer(UNIPT1VOLTS));
  ranges.addObject('0 to +0.01 Volts',pointer(UNIPT01VOLTS));
  ranges.addObject('0 to +0.02 Volts',pointer(UNIPT02VOLTS));
  ranges.addObject('0 to +1.67 Volts',pointer(UNI1PT67VOLTS));

  CBbuf := pointer(cbWinBufAlloc (nbptBuf0));

  CbDacBuf := pointer(cbWinBufAlloc (nbptBuf0+2048)); {64K une fois pour toutes}
  CbDacNbPtBuf:=nbptBuf0;

  SeuilSingleIO:=10000;
  CBpacketSize:=2048;

  CBAdcBitCount:=12;
  CBDacBitCount:=12;

  revLevel:=CURRENTREVNUM;
  ULStat := cbDeclareRevision(revLevel);

end;

{ Dyrange est le facteur de conversion brut .
  Vrange est le numéro dans la liste ranges }
function TCBinterface.DyRange(Vrange: integer): float;
var
  d:integer;
begin
  d:=1 shl CBadcBitCount;

  case Vrange of
    0 {BIP10VOLTS     }  : result:=10000/d;              { -10 to +10 Volts }
    1 {BIP5VOLTS      }  : result:= 5000/d;              { -5 to +5 Volts }
    2 {BIP2PT5VOLTS   }  : result:= 2500/d;              { -2.5 to +2.5 Volts }
    3 {BIP1PT25VOLTS  }  : result:= 1250/d;              { -1.25 to +1.25 Volts }
    4 {BIP1VOLTS      }  : result:= 1000/d;              { -1 to +1 Volts }
    5 {BIPPT625VOLTS  }  : result:=  625/d;              { -.625 to +.625 Volts }
    6 {BIPPT5VOLTS    }  : result:=  500/d;              { -.5 to +.5 Volts }
    7 {BIPPT1VOLTS    }  : result:=  100/d;              { -.1 to +.1 Volts }
    8 {BIPPT05VOLTS   }  : result:=   50/d;              { -.05 to +.05 Volts }
    9 {BIPPT01VOLTS   }  : result:=   10/d;              { -.01 to +.01 Volts }
    10{BIPPT005VOLTS  }  : result:=    5/d;              { -.005 to +.005 Volts }
    11{BIP1PT67VOLTS  }  : result:=    1.67/d;           { -.1.67 to + 1.67 Volts }

    12{UNI10VOLTS     }  : result:= 10000/2/d;           { 0 to 10 Volts }
    13{UNI5VOLTS      }  : result:=  5000/2/d;           { 0 to 5 Volts }
    14{UNI2PT5VOLTS   }  : result:=  2500/2/d;           { 0 to 2.5 Volts }
    15{UNI2VOLTS      }  : result:=  2000/2/d;           { 0 to 2 Volts }
    16{UNI1PT25VOLTS  }  : result:=  1250/2/d;           { 0 to 1.25 Volts }
    17{UNI1VOLTS      }  : result:=  1000/2/d;           { 0 to 1 Volts }
    18{UNIPT1VOLTS    }  : result:=   100/2/d;           { 0 to .1 Volts }
    19{UNIPT01VOLTS   }  : result:=    10/2/d;           { 0 to .01 Volts }
    20{UNIPT02VOLTS   }  : result:=     2/2/d;           { 0 to .02 Volts }
    21{UNI1PT67VOLTS  }  : result:=     1.67/2/d;        { 0 to 1.67 Volts }

    else result:=10000/d;
  end;
end;

function TCBinterface.RangeValue(k:integer):integer;
begin
  if (k>=0) and (k<ranges.count)
    then result:=intG(ranges.objects[k])
    else result:=BIP10VOLTS;
end;

destructor TCBinterface.destroy;
begin
  ranges.free;

  if assigned(CBbuf) then cbWinBufFree(intG(CBbuf));
  if assigned(CbDacBuf) then cbWinBufFree(intG(CbDacBuf));
end;


procedure TCBinterface.init;
begin
  ULstat:=0;
  FinternalStop:=false;
  FgetCount:=false;
  FgetCount2:=false;

  AdcPower2:= 1 shl (CBAdcBitCount-1);
  DacPower2:= 1 shl (CBDacBitCount-1);


  CBnbvoie:=AcqInf.Qnbvoie;

  if (cbBufferSize<1) or (cbBufferSize>20) then cbBufferSize:=1;

  if NbptBuf0<>cbBufferSize*65536 then
  begin
    cbWinBufFree(intG(CBbuf));
    NbptBuf0:=cbBufferSize*65536;
    CBbuf := pointer(cbWinBufAlloc (NbptBuf0));
  end;

  CBnbptBuf:=(nbptBuf0 div (CBnbvoie*CBpacketSize))*(CBnbvoie*CBpacketSize);

  (*
  if acqinf.Fstim and (acqinf.modeSynchro in [msNumPlus,msNumMoins])
     and (acqinf.Qnbpt*CBnbvoie>nbptBuf0) and not acqInf.continu then
    begin
      if CBnbptBuf<>(acqInf.Qnbpt*CBnbvoie div (CBnbvoie*2048))*(CBnbvoie*2048+1) then
        begin
          cbWinBufFree(intG(CBbuf));
          CBnbptBuf:=(acqInf.Qnbpt*CBnbvoie div (CBnbvoie*2048))*(CBnbvoie*2048+1);
          CBbuf := pointer(cbWinBufAlloc (CBnbptBuf));
        end;
    end
  else
    begin
      if CBnbptBuf>nbPtBuf0 then
        begin
          cbWinBufFree(intG(CBbuf));
          CBbuf := pointer(cbWinBufAlloc (nbptBuf0));
        end;
      CBnbptBuf:=(nbptBuf0 div (CBnbvoie*2048))*(CBnbvoie*2048);
    end;
  *)
  nbvoie:=CBnbvoie;
  nbpt:=AcqInf.Qnbpt*nbvoie;

  base:=0;
  count0:=-1;

  base2:=0;
  count02:=-1;

  tabDma1:=CBbuf;
  tabDma2:=CBdacBuf;
  nbpt0DMA:=CBnbptBuf;
  FnbptDacDMA:=CbDacNbptBuf;

  {messageCentral(Istr(cbNbptBuf)+' '+Istr(cbDacNbptBuf) );}

  initPadc;

  nextSeq:=AcqInf.Qnbpt*CBnbvoie;
  GI1:=-1;
  GI1x:=-1;

  if acqInf.Fstim then
    begin
     cntStim:=0;
     cntStoreDac:=0;
     initPdac;
     loadDmaDAC;
    end;

  FwaitRestart:=false;

  FCBdma:=CBdma;

  


end;


procedure EventCallBack(BoardNum:integer;EventType, EventData, UserData:integer);stdCall;
begin
  setThreadPriority(getCurrentThread,THREAD_PRIORITY_TIME_CRITICAL);
  inc(CBcntEvent);
end;



procedure TCBinterface.lancer;
var
  rate:longint;
  i,k,range:integer;
  flags:integer;
  ChanArray,GainArray:array[1..16] of smallint;
begin
  {affdebug('TCBinterface.lancer 1 '+Istr(intG(@cbAoutScan)));}

  base:=0;
  count0:=-1;

  base2:=0;
  count02:=-1;

  Ptab0:=CBbuf;
  PtabFin:=@CBbuf^[nbpt0DMA];
  Ptab:=Ptab0;

  CBcntEvent:=0;

  range:=rangeValue(AcqInf.Qgain[1]-1);

  FinternalStop:=true;
  with AcqInf do
  begin
    if (AcqInf.Fstim) then
      begin
        rate:=0;
        ULStat := cbAoutScan(BoardNum,0,paramStim.ActiveChannels-1 ,
                    CbDacNbptBuf, rate, BIP10VOLTS, intG(CbDacBuf),
                    BACKGROUND + CONTINUOUS +EXTCLOCK );
        if ULstat<>0 then
        begin
          flagStopPanic:=true;
          exit;
        end;
      end;

    rate:=round(1000/AcqInf.periodeparVoieMS);
    {messageCentral('Rate='+Estr(rate,6)+' seuil='+Estr(SeuilSingleIO,3) );}

    flags:= BACKGROUND + CONTINUOUS;
    if not CBdma then
    begin
      flags:=flags+CONVERTDATA;
      if (rate<SeuilSingleIO) then
      begin
        flags:=flags + singleIO;
        if CBeventTest then
        begin
          ULstat:=cbEnableEvent(BoardNum, ON_DATA_AVAILABLE, 1,
                                @EventCallback, nil);

          //if ULstat<>0 then
          //begin
          //  flagStopPanic:=true;
          //  exit;
          //end;

        end;
      end;
    end;

    if modeSynchro in [msNumPlus,msNumMoins] then flags:=flags + ExtTrigger;

    for i:=1 to acqInf.Qnbvoie   do
    begin
      chanArray[i]:=QvoieAcq[i];
      GainArray[i]:=rangeValue(AcqInf.Qgain[i]-1);
    end;


    {ULstat:=cbALoadQueue(BoardNum,ChanArray[1],GainArray[1],CBnbVoie);}

    ULStat := cbAInScan(BoardNum,QvoieAcq[1],QvoieAcq[1]+CBnbvoie-1,
                        CBnbptBuf, rate, range, intG(CBbuf),
                        flags);
    if ULstat<>0 then
      begin
        flagStopPanic:=true;
        exit;
      end;
  end;

  FinternalStop:=false;
end;

function TCBinterface.Special1(mask:word;delay:integer):word;
var
  buf:PtabEntier;
  nbBuf:integer;
  flags:integer;
  rate:longint;

  status:smallint;
  CurCount:Longint;
  CurIndex:Longint;
  stop:boolean;
  i:integer;
const
  seuil=2460;
begin
  if acquisitionON then
    repeat
      if testEscape then exit;
    until FwaitRestart;

  if (delay<0) or (delay>100000) then exit;

  nbbuf:=2048*16;
  buf := pointer(cbWinBufAlloc (nbBuf));
  fillchar(buf^,nbBuf*2,0);

  flags:=CONVERTDATA + ExtTrigger + BACKGROUND +continuous;
  rate:=1000;

  ULStat := cbAInScan(BoardNum,0,15,
                      nbBuf, rate, BIP10VOLTS, intG(buf),
                      flags);

  if ULstat=0 then
    repeat
      ULstat:=cbGetStatus(BoardNum, Status, CurCount, CurIndex,AIfunction);
      stop:=testEscape;
    until (status=0) or stop or (curCount>(delay+1)*16 )
  else messageCentral('CB special error='+Istr(ULstat));

  {if (status<>0) then} cbStopBackground(BoardNum,AIfunction);

  result:=0;
  for i:=0 to 15 do
    result:=result + ord(buf^[delay*16+i]>seuil) shl i;

  result:=result and mask;

  cbWinBufFree(intG(buf));
end;

procedure TCBinterface.relancer;
begin
  base:=0;
  count0:=-1;

  base2:=0;
  count02:=-1;

  GI1:=-1;


  cntStim:=0;
  initPdac;
  loadDmaDAC;

  lancer;
end;



procedure TCBinterface.terminer;
var
  Status:smallint;
  CurCount, CurIndex:integer;
  ULstat:integer;
begin
  FinternalStop:=true;


  repeat until not FgetCount and not FgetCount2;


  if AcqInf.Fstim
    then ULStat := cbStopBackground(BoardNum,AOfunction);

  ULStat := cbStopBackground(BoardNum,AIfunction);

  {if ULstat<>0 then
     messageCentral('cbStopBackground error='+Istr(ULstat));}


  {if ULstat<>0 then
     messageCentral('cbStopBackground error='+Istr(ULstat));}

  FinternalStop:=false;

  if CBeventTest then
  begin
    ULstat:=cbDisableEvent(BoardNum, ON_DATA_AVAILABLE);
    messageCentral('nb Event='+Istr(CBcntEvent));
  end;
end;


function TCBinterface.dataFormat:TdataFormat;
begin
  result:=F12bits;
end;

function TcbInterface.DacFormat:TdacFormat;
begin
  result:=DacF12bits;
end;


function TCBinterface.getCount:integer;
var
  Status:SmallInt;
  CurCount:Longint;
  CurIndex:Longint;
  x:integer;
begin
  try
  if FinternalStop then
    begin
      result:=count0;
      exit;
    end;

  FgetCount:=true;
  ULStat := cbGetStatus(BoardNum, Status, CurCount, CurIndex,AIfunction);
  
  if ULstat<>0 then
    flagStopPanic:=true;

  if curCount<0 then
    begin
      result:=count0;
      FgetCount:=false;
      exit;
    end;

  x:=base+curCount;

  if x<count0 then
    begin
      base:=base+CBnbptBuf;
      x:=x+CBnbptBuf;
    end;

  count0:=x;
  result:=x;

  FgetCount:=false;
  finally
    affdebug('                           getCount='+Istr(result),41);
  end;
end;


function TCBinterface.getCount2:integer;
var
  Status:SmallInt;
  CurCount:Longint;
  CurIndex:Longint;
  x:integer;
begin
  try
  if FinternalStop then
    begin
      result:=count02;
      exit;
    end;

  FgetCount2:=true;
  ULStat := cbGetStatus(BoardNum, Status, CurCount, CurIndex,AOfunction);
  if ULstat<>0 then
  begin
    flagStopPanic:=true;
    exit;
  end;

  if curCount<0 then
    begin
      result:=count02;
      FgetCount2:=false;
      exit;
    end;

  x:=base2+curCount;

  if x<count02 then
    begin
      base2:=base2+CBDACnbptBuf;
      x:=x+CBDACnbptBuf;
    end;

  count02:=x;
  result:=x;

  count2:=result;
  FgetCount2:=false;

  finally
    result:=result-2048;
    affDebug('getCount2='+Istr(result),41);
  end;
end;


function TCBinterface.PeriodeElem:float;
begin
  result:=1;
end;

function TCBinterface.PeriodeMini:float;
begin
  result:=3;
end;

procedure TCBinterface.outdac(num,j:word);
begin
  cbAOut(BoardNum, num,1, j);
end;

function TCBinterface.outDIO(dev,port,value: integer): integer;
begin
end;

function TCBinterface.inADC(n:integer):smallint;
begin
end;

function TCBinterface.inDIO(dev,port:integer):integer;
begin
end;



procedure TCBinterface.nextSample;
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

     cmp   FCBdma,0
     je    @@4
     mov   cx,4                  {cas DMA+12bits  données non converties }
     shr   ax,4                  {on élimine les 4 bits contenant le numéro de voie}
     sub   ax,2048               {on récupère le signe }
     jmp   @@3                   {c'est tout}

@@4: sub   ax,ADCpower2          {Non DMA 16 bits, on retranche 32768}

@@3:
     mov   word ptr wsample,ax            {On doit toujours obtenir un entier signé }
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

     cmp   FCBdma,0
     je    @@4
     mov   cx,4                  {cas DMA+12bits  données non converties }
     shr   ax,4                  {on élimine les 4 bits contenant le numéro de voie}
     sub   ax,2048               {on récupère le signe }
     jmp   @@3                   {c'est tout}

@@4: sub   ax,ADCpower2          {Non DMA 16 bits, on retranche 32768}

@@3:
     mov   word ptr wsample,ax            {On doit toujours obtenir un entier signé }
     mov   word ptr wsampleR,ax


{$ENDIF}
end;

procedure ConvSample;assembler;
asm
       mov   ax,word ptr wsample
       cmp   FCBdma,0        { 12 bits non convertis }
       je    @@4
       shr   ax,4
       sub   ax,2048
       jmp   @@3

  @@4: sub ax,AdcPower2

  @@3:
       mov   word ptr wsample,ax
       mov   word ptr wsampleR,ax

end;

procedure TCBInterface.copySample(i:integer);
var
  x:word;
begin
  wsample[0]:=tabDMA1^[i mod nbpt0DMA];
  convSample;
  storeWsample;
end;


procedure TCBinterface.doNumPlus;
var
  j:integer;
  i,GI2,GI2x:integer;
begin
  if FwaitRestart then
    begin
      if FCanRestart then restart;
      exit;
    end;

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

        if not AcqInf.waitMode then
          begin
            if acqInf.Fstim then
              begin
                inc(baseIndex,nbptStim);
                initPdac;
                loadDmaDac;
              end;
            lancer;
          end
        else
          begin
            if acqInf.Fstim then inc(baseIndex,nbptStim);
            FwaitRestart:=true;
          end;
        exit;
      end;
  end;

  GI1:=GI2;

  if AcqInf.Fstim then
    begin
      GI2x:=getCount2;
      for i:=GI1x+1 to GI2x do storeDac(nextSampleDac);
      GI1x:=GI2x;
    end;
  
end;


function TcbInterface.RangeString:AnsiString;
var
  i:integer;
begin
  result:=ranges[0];
  for i:=1 to ranges.count-1 do
    result:=result+'|'+ranges[i];
end;

function TcbInterface.MultiGain:boolean;
begin
  result:=false;
end;

function TcbInterface.GainLabel:AnsiString;
begin
  result:='Range';
end;

function TcbInterface.nbGain;
begin
  result:=ranges.count;
end;

function TcbInterface.channelRange:boolean;
begin
  result:=true;
end;

procedure TcbInterface.GetOptions;
begin
  CBoptions.execution(self);
end;

procedure TcbInterface.setDoAcq(var procInt:ProcedureOfObject);
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
        MSnumPlus: ProcInt:=doNumPlus;

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

procedure TcbInterface.initcfgOptions(conf:TblocConf);
begin
  with conf do
  begin
    setvarconf('ThMode',SeuilSingleIO,sizeof(SeuilSingleIO));
    setvarconf('CBdma',CBdma,sizeof(CBdma));
    setvarconf('CB16bits',CB16bits,sizeof(CB16bits));

    setvarconf('AdcBitCount',CBadcBitCount,sizeof(CBadcBitCount));
    setvarconf('DacBitCount',CBdacBitCount,sizeof(CBdacBitCount));
    setvarconf('BufferSize',CBbufferSize,sizeof(CBbufferSize));

    setvarconf('PacketSize',CBpacketSize,sizeof(cbPacketSize));
  end;
end;

function TcbInterface.TagMode:TtagMode;
begin
  result:=tmNone;
end;


function TcbInterface.tagShift:integer;
begin
  result:=0;
end;

function TcbInterface.TagCount:integer;
begin
  result:=0;
end;

procedure TcbInterface.restartAfterWait;
begin
  if acqInf.Fstim then
    begin
      initPdac;
      loadDmaDac;
    end;
  lancer;
end;

function TcbInterface.getMinADC:integer;
begin
  result:=-1 shl (CBAdcBitCount-1);
end;

function TcbInterface.getMaxADC:integer;
begin
  result:=1 shl (CBAdcBitCount-1);
end;

function TcbInterface.nbVoieAcq(n: integer): integer;
begin
  result:=n;
end;


procedure TcbInterface.GetPeriods(PeriodU: float; nbADC,nbDI,nbDAC,nbDO: integer;var periodIn,periodOut: float);
var
  p:float;
begin
  {periodU est la période par canal souhaitée}
  if nbADC<1 then nbADC:=1;;

  p:=periodU*1000/nbADC;                { période globale en microsecondes}
  p:=round(p/periodeElem)*periodeElem;  { doit être un multiple de periodeElem }
  if p<periodeMini then p:=periodeMini; { doit être supérieure à periodeMini }
  periodIn:=p*nbADC/1000;               { période calculée en millisecondes }
  periodOut:=p/1000;                    { Simultané sur DAS1600 , donc = période globale }
end;

function TcbInterface.AgPeriod(PeriodU: float; nbADC, nbDI, nbDAC,nbDO: integer): float;
var
  pIn,pOut:float;
begin
  GetPeriods(PeriodU,nbADC,nbDI,nbDAC,nbDO,pIn,pOut);

  result:= pIn ;
      {pour la 1600, les dac sont simultanés, on ignore les autres cartes}
end;


procedure TcbInterface.initGlobals;
begin
  with acqinf do
  begin
    inherited;

    isi:=isiPts;
    isiStim:=paramStim.isiPts;

    nbvoie:=CBnbvoie;
    nbpt:=Qnbpt*nbvoie;
    nbAv:=QnbAv*nbvoie;
    nbAp:=nbpt-nbAv;

    nbptStim:=paramStim.nbpt1;

    //Pfactor:=paramStim.periodeUS/acqInf.periodeUS;

    nbdac:=paramStim.ActiveChannels;

  end;
end;


procedure TCBInterface.storeDac(x:word);assembler;
{$IFNDEF WIN64}
asm
     add   x,DacPower2          { 16 bits : ajouter 32768 }

@@2: push  edi
     mov   edi,PtabDac          {destination}
     mov   [edi],x              {ranger dans Buffer}

     add   edi,2
     cmp   edi,PtabDacfin       {incrémenter }
     jl    @@3                  {mais si la fin est atteinte}
     mov   edi,PtabDac0         {ranger l'adresse de début}

@@3: mov   PtabDac,edi
     pop   edi

     inc(cntStoreDac);
end;
{$ELSE}
asm
     add   x,DacPower2          { 16 bits : ajouter 32768 }

@@2: push  rdi
     mov   rdi,PtabDac          {destination}
     mov   [rdi],x              {ranger dans Buffer}

     add   rdi,2
     cmp   rdi,PtabDacfin       {incrémenter }
     jl    @@3                  {mais si la fin est atteinte}
     mov   rdi,PtabDac0         {ranger l'adresse de début}

@@3: mov   PtabDac,rdi
     pop   rdi

     inc(cntStoreDac);
end;
{$ENDIF}

procedure initComputerBoards;
var
  configVal:integer;
  UL:integer;
  revLevel:single;

  InfoType:        Integer;
  DevNum:          Integer;
  ConfigItem:      Integer;
  st:AnsiString;


  BoardCount:integer;
  BoardNum:integer;

  i,j:integer;
begin

  if not initCBlib then exit;

  revLevel:=CURRENTREVNUM;
  UL := cbDeclareRevision(revLevel);

  InfoType := GLOBALINFO;
  BoardNum := 0;
  DevNum := 0;
  ConfigItem := GINUMBOARDS;

  cbGetConfig (InfoType, BoardNum, DevNum, ConfigItem, ConfigVal);

  BoardCount := ConfigVal;

  if BoardCount=0 then exit;

  for i:=0 to BoardCount-1 do
  begin
    st:='';
    for j:=0 to BOARDNAMELEN do st:=st+' ';
    cbGetBoardName(i,@st[1]);
    while (length(st)>0) and ((st[length(st)]=' ') or (st[length(st)]=#0))
    do delete(st,length(st),1);
    st:=FsupespaceFin(st);
    if st<>'' then RegisterBoard(st+' #'+Istr(i),pointer(TCBinterface));
  end;
end;





procedure TCBinterface.DisplayErrorMsg;
var
  ErrMsg:array of char;
  w:integer;
  st:AnsiString;
begin
  if ULstat<>0 then
  begin
    setLength(ErrMsg,ERRSTRLEN);
    w:=cbGetErrMsg(ULstat, @ErrMsg[0]);
    if w=0 then
    begin
      st:=Pansichar(@ErrMsg[0]);
      messageCentral(st,CBname+' error message');
    end;
  end;

end;

function TCBinterface.ADCcount(dev: integer): integer;
begin
  result:=16;
end;


function TCBinterface.DACcount(dev: integer): integer;
begin
  result:= 2; { Provisoire: il faudrait tenir compte de  DacOnBoard }
end;


Initialization
AffDebug('Initialization CBbrd1',0);
initComputerBoards;

end.
