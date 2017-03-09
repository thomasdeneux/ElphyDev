unit acqCom1;

interface
{$IFDEF FPC} {$mode delphi} {$DEFINE AcqElphy2} {$A1} {$Z1} {$ENDIF}

uses util1, debug0,
     acqDef2,AcqInf2,StimInf2;

{Pour une manipulation simple en assembleur, on copie tous les paramètres utiles
dans des variables globales.
}

var
  cntDisp:integer; { Indice du dernier échantillon rangé dans mainbuf
                     Initialisé à -1
                     Incrémenté à chaque appel de storeADC
                   }
  cntStim:integer; { Compte les échantillons lus dans mainDac
                     Initialisé à 0
                     Incrémenté à chaque appel de nextSampleDac
                   }
  cntStoreDac:integer; { Indice du dernier échantillon rangé dans DacDma
                     Initialisé à 0
                     Incrémenté à chaque appel de StoreDac
                   }

  BigAgg:integer;
                   
  FDACunsigned:boolean;


  voieSync:smallint;
  seuilP,seuilM:smallint;
  IntervalT:smallint;

  nbpt,nbAv,nbAp:integer;
  nbvoie:integer;           { reçoit nbVoieAcq }
  nbptStim:integer;

  Ftrig:boolean;
  Farmed:boolean;
  TrigDate:integer;
  oldSyncNum:boolean;

  IntTime,intTimeMax:single;
  nbInt:integer;

  ISI:integer;
  ISIstim:integer;
  withStim:boolean;
  Jhold1:array[0..3] of smallint;

  oldw1:smallint;

  nbdac:integer;

  
var
  Ptab0,PtabFin,Ptab:pointer;
    {adresses de début, de fin et courante du tableau ADC-DMA}
  Pmain0,PmainFin,Pmain:pointer;
    {adresses de début, de fin et courante du tableau ADC-main}

  wSample,wSampleR:packed array[0..4] of smallint ;
  {
  wSampleSingle:single absolute wsample;
    On renonce à cette déclaration car la directive ABSOLUTE provoque une erreur LA30 du linker quand on utilise
    wSampleSingle dans une routine assembleur
  }


  //wSampleR: packed array[0..4] of smallint ;


  Pfactor:double;

var
  PtabDac0,PtabDacFin,PtabDAc:pointer;
    {adresses de début, de fin et courante du tableau DAC-DMA}
  PmainDac0,PmainDacFin,PmainDac:pointer;
    {adresses de début, de fin et courante du tableau DAC-main}


  RestartEnabled:boolean;
  RestartOnTimer:boolean;
  AcqTime0:LongWord;

  ProcessDelay:integer;


var
  AgTotSize:integer;                      // Taille d'un agregat dans MainBuf
  AgOffsets:array[0..255] of integer;     // Offsets des échantillons dans un agrégat
  AgSampleSizes:array[0..255] of integer; // Tailles des échantillons dans un agrégat
  AgIsNRN: array[0..255] of boolean;

  PSampleSize0,PSampleSizeEnd,PSampleSize:pointer;
    {adresses de début, de fin et courante du tableau AgSampleSizes}

  LastSampleSize:integer;

Procedure initPmainDac;
procedure resetPmainDac;

function nextSampleDAC:word;pascal;
procedure storeDac(x:word);

Procedure initPmainDacRT;
function nextSampleDACRT:single;


procedure initAcqCom1;

implementation


var
  pstimBuf: TFbuffer;
  StoredEp:integer;
  ChC:integer;
  EpSize:integer;
  EpSize1:integer;

  cntStim2:integer;

Procedure initPmainDac;
begin
  pstimBuf:=paramStim.buffers;

  StoredEp:=paramStim.StoredEp;
  ChC:=paramStim.Activechannels;
  EpSize:=paramStim.EpSize;
  EpSize1:=EpSize*storedEp;

  cntStim2:=baseIndex;
end;

procedure resetPmainDac;
begin

end;

function nextSampleDAC:word;
var
  v,x,i,Ep:integer;
begin
  v:=cntStim2 mod chc; {num canal}
  x:=cntStim2 div chc;
  i:=x mod EpSize1;    {num point}

  result:= PStimbuf[v,i];

  inc(cntStim2);
  inc(cntStim);
end;


var
  pstimBuf1: TFbuffer1;

Procedure initPmainDacRT;
begin
  pstimBuf1:=paramStim.buffers1;

  StoredEp:=paramStim.StoredEp;
  ChC:=paramStim.Activechannels;
  EpSize:=paramStim.EpSize;
  EpSize1:=EpSize*storedEp;

  cntStim2:=baseIndex;
end;


function nextSampleDACRT:single;
var
  v,x,i,Ep:integer;
begin
  v:=cntStim2 mod chc; {num canal}
  x:=cntStim2 div chc;
  i:=x mod EpSize1;    {num point}

  move(PStimbuf1[v,i],result,4);

  inc(cntStim2);
  inc(cntStim);
end;



procedure storeDac(x:word);assembler;
asm
{$IFNDEF WIN64}
     cmp   FDACunsigned,0
     je    @@1
     sub   x,32768

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
     cmp   FDACunsigned,0
     je    @@1
     sub   x,32768

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


{ InitAcqCom initialise toutes les variables qui ne dépendent pas de la carte d'acquisition }

procedure initAcqCom1;
var
  i,ofs:integer;
begin
  ofs:=0;
  with AcqInf do
  for i:=1 to Qnbvoie do
  begin
    AgSampleSizes[i-1]:= SampleSize[i];
    AgOffsets[i-1]:=ofs;
    ofs:=ofs+ SampleSize[i];
    AgIsNrn[i-1]:= ChannelType[i]=TI_Neuron;
  end;
  if AcqInf.nbVoieAcq>AcqInf.Qnbvoie then
  with AcqInf do
  begin
    AgSampleSizes[nbvoieAcq-1]:= 2;
    AgOffsets[nbvoieAcq-1]:=ofs;
    ofs:=ofs+2;
    AgIsNrn[nbvoieAcq-1]:= false;
  end;

  AgTotSize:=ofs;

  Pmain0:=mainBuf;
  intG(PmainFin):=intG(mainBuf) + mainBufSize;
  Pmain:=mainBuf;

  PSampleSize0:=@AgSampleSizes;
  PSampleSize:=PSampleSize0;
  intG(PSampleSizeEnd):=intG(PSampleSize0)+AcqInf.nbvoieAcq*4;

  cntDisp:=-1;
end;





Initialization
AffDebug('Initialization acqCom1',0);


end.
