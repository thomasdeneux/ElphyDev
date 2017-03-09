unit DemoBrd1;

interface
{$IFDEF FPC} {$mode delphi} {$DEFINE AcqElphy2} {$A1} {$Z1} {$ENDIF}

uses windows,sysutils,classes,
     util1,debug0,varconf1,
     stmDef,
     AcqBrd1,
     acqCom1, AcqInterfaces,
     acqDef2,acqInf2,stimInf2,
     dataGeneFile ;


type
  TDemoInterface=class(TacqInterface)
    protected
      buf:pointer;
      bufSize:integer;

      DacNbptBuf:integer;
      DacBuf:PtabEntier;

      nextSeq:integer;

      time0:integer;
      pms:float;            {Période globale en millisecondes }

      Qindex:integer;
      Qread:integer;
      RandomCnt: integer;

      IampNoise:array[0..15] of integer;
      nbOut:integer;

      function getCount:integer;override;
      function getCount2:integer;override;


      procedure nextSample;override;

      procedure storeWsample;override;

      procedure copySample(i:integer);override;

      procedure relancer;override;

   public
      FuseTagStart:boolean;
      Model:integer;
      ModelPeriod:double;    {Période du signal en millisecondes}
      ModelAmp: double;
      AmpNoise:double;
      EventFreq: double;

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
      function TagCount:integer;override;
      function tagShift:integer;override;

      function getMinADC:integer;override;
      function getMaxADC:integer;override;

      procedure setVSoptions;override;

      function getNrnSymbolNames(cat: integer): TstringList; override;
      function nbVoieAcq(n: integer): integer;override;
    end;




implementation

uses DemoOpt1;

const
  nbptBuf0=50000;

var
  TTevent:double;

constructor TdemoInterface.create(var st1:driverString);
var
  i:integer;
begin
  boardFileName:='Elphy Demo';

  ModelPeriod:=1000;
  ModelAmp:=1000;
  EventFreq:=10;
end;



destructor TdemoInterface.destroy;
begin
  if assigned(buf) then Freemem(buf);
  if assigned(DacBuf) then Freemem(dacBuf);
end;




procedure TdemoInterface.init;
var
  i,j:integer;
  Iperiod:integer;
  Iamp:array[0..15] of integer;
  p:pointer;
  x:double;
begin

  nbvoie:=AcqInf.nbVoieAcq;

  pms:=AcqInf.periodeUS/1000;

  Iperiod:=roundL(ModelPeriod/(pms*nbvoie));
  for j:=0 to nbvoie-ord(FuseTagSTart)-1 do
  begin
    Iamp[j]:= round((ModelAmp-AcqInf.y0u(j+1))/AcqInf.Dyu(j+1));
    IampNoise[j]:= round((AmpNoise-AcqInf.y0u(j+1))/AcqInf.Dyu(j+1));
  end;

  case model of
    0,1:
       begin
         BufSize:=Iperiod*AgTotSize;
         NbPt0DMA:=Iperiod*nbvoie;

         Reallocmem(buf,BufSize);

         p:=buf;
         for i:=0 to Iperiod-1 do
         begin
           for j:=0 to nbvoie-ord(FuseTagSTart)-1 do
           begin
             if model=0
               then Psmallint(p)^:= round(Iamp[j]*sin(2*pi/Iperiod*i))
               else Psmallint(p)^:=  1000*ord(i<Iperiod div 2);
             inc(intG(p),2);
           end;
           if FuseTagStart then
           begin
             if i<Iperiod div 4
               then Psmallint(p)^:= -1
               else Psmallint(p)^:= 0;
             inc(intG(p),2);
           end;
         end;
       end;

    2: begin
         Iperiod:=roundL(20/(pms*nbvoie));
         BufSize:=Iperiod*AgTotSize;
         Reallocmem(buf,BufSize);
         NbPt0DMA:=Iperiod*nbvoie;
         p:=buf;

         TTevent:=1000/EventFreq;

         for i:=0 to Iperiod-1 do
         begin
           x:=20/Iperiod*i;
           for j:=0 to nbvoie-ord(FuseTagSTart)-1 do
           begin
             Psmallint(p)^:= round(Iamp[j]/0.368*x*exp(-x) );
             inc(intG(p),2);
           end;
           if FuseTagStart then
           begin
             if i<Iperiod div 4
               then Psmallint(p)^:= -1
               else Psmallint(p)^:= 0;
             inc(intG(p),2);
           end;
         end;
       end;
  end;

  nbOut:=paramStim.ActiveChannels;

  tabDma1:=buf;
  tabDma2:=dacBuf;

  initPadc;

  nextSeq:=AcqInf.Qnbpt1;
  GI1:=-1;
  GI1x:=-1;

  cntStim:=0;
  initPdac;
  loadDmaDAC;


end;


procedure TdemoInterface.lancer;
begin
  Ptab0:=buf;
  intG(PtabFin):=intG(buf)+ bufSize;
  Ptab:=Ptab0;

  time0:=getTickCount;
  Qindex:=0;
  Qread:=0;
  RandomCnt:=0;
end;

procedure TdemoInterface.relancer;
begin
end;



procedure TdemoInterface.terminer;
begin
  {messageCentral('Fini');}
end;


function TdemoInterface.dataFormat:TdataFormat;
begin
  result:=F16bits;
end;

function TdemoInterface.DacFormat:TdacFormat;
begin
  result:=DacF1322;
end;


function TdemoInterface.getCount:integer;
begin
  result:=roundL((getTickCount-time0)/pms);
end;


function TdemoInterface.getCount2:integer;
begin
  result:=-1;
  count2:=result;
end;


function TdemoInterface.PeriodeElem:float;
begin
  result:=0.1;
end;

function TdemoInterface.PeriodeMini:float;
begin
  result:=10
end;


procedure TdemoInterface.outdac(num,j:word);
begin
end;

function TdemoInterface.outDIO(dev,port,value: integer): integer;
begin
end;

function TdemoInterface.inADC(n:integer):smallint;
begin
end;

function TdemoInterface.inDIO(dev,port:integer):integer;
begin
  result:=0;
end;

function interMS:double;
var
  i:integer;
  x:double;
Const
  gamma=2;
begin
  result:=0;
  for i:=1 to gamma do
  begin
    x:=1-random;
    if x>0 then x:=-ln(x)*TTevent/gamma;
    result:=result+x;
  end;
end;

procedure TdemoInterface.nextSample;
var
  i,ch: integer;
begin
  LastSampleSize:= 2;

  if RandomCnt>0 then  dec(RandomCnt);

  if RandomCnt>0 then wsample[0]:=0
  else
  if withStim and (model=3) then
  begin
    ch:=Qindex mod nbvoie;
    if (ch<nbOut) then wsample[0]:=nextSampleDAC;
    if ch=nbvoie-1 then
      for i:=nbvoie+1 to nbout do nextSampleDac;
  end
  else
  begin
    wsample[0]:=PtabEntier(Buf)^[Qread mod (BufSize div 2)];
    inc(Qread);
  end;

  if (model<>3) then
    if not FuseTagStart or (Qindex mod nbvoie<>nbvoie-1) then wsample[0]:=wsample[0]+round((random-0.5)*IAmpNoise[Qindex mod nbvoie]);


  inc(Qindex);
  if (RandomCnt=0) and (model=2) and (Qread mod (BufSize div 2)=0) then RandomCnt:=round(interMs/pms)*nbvoie+1;
  wsampleR:=wsample;

  
end;


procedure TdemoInterface.storeWsample;assembler;
asm
{$IFNDEF WIN64}
     push  edi

     mov  eax,Dword ptr wsample  { lire wsampleSingle attention à l'erreur LA30 }

     mov   edi,Pmain             {destination}

     mov   dword ptr [edi],eax             {ranger 4 octets dans mainBuf}

     mov   ecx,LastSampleSize
     add   edi,ecx               {Ajouter la taille à Pmain }
     cmp   edi,Pmainfin
     jl    @@2                   {mais si la fin est atteinte}
     mov   edi,Pmain0            {ranger l'adresse de début}

@@2: mov   Pmain,edi
     inc   cntDisp               {incrémenter cntDisp}

     pop   edi
{$ELSE}
     push  rdi

     mov  eax,Dword ptr wsample  { lire wsampleSingle attention à l'erreur LA30 }

     mov   rdi,Pmain             {destination}

     mov   dword ptr [rdi],eax             {ranger 4 octets dans mainBuf}

     mov   rcx,0
     mov   ecx,LastSampleSize
     add   rdi,rcx               {Ajouter la taille à Pmain }
     cmp   rdi,Pmainfin
     jl    @@2                   {mais si la fin est atteinte}
     mov   rdi,Pmain0            {ranger l'adresse de début}

@@2: mov   Pmain,rdi
     inc   cntDisp               {incrémenter cntDisp}

     pop   rdi


{$ENDIF}

end;



function TdemoInterface.RangeString:AnsiString;
begin
  result:='-10 volts to +10 volts';
end;

function TdemoInterface.MultiGain:boolean;
begin
  result:=false;
end;

function TdemoInterface.GainLabel:AnsiString;
begin
  result:='Range';
end;

function TdemoInterface.nbGain;
begin
  result:=1;
end;

function TdemoInterface.channelRange:boolean;
begin
  result:=false;
end;

procedure TdemoInterface.GetOptions;
begin
  DemoOptions.execution(self);
end;

procedure TdemoInterface.setDoAcq(var procInt:ProcedureOfObject);
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


procedure TdemoInterface.initcfgOptions(conf:TblocConf);
begin
  with conf do
  begin
    setvarconf('UseTagStart',FUseTagStart,sizeof(FUseTagStart));
    setvarconf('Model',Model,sizeof(Model));
    setvarconf('ModelPeriod1',ModelPeriod,sizeof(ModelPeriod));
    setvarconf('AmpNoise',AmpNoise,sizeof(AmpNoise));
  end;
end;


function TDemoInterface.TagMode: TtagMode;
begin
 if FuseTagStart
    then result:=tmITC
    else result:=tmNone;
end;


function TDemoInterface.TagCount: integer;
begin
  result:=16;
end;

function TdemoInterface.tagShift:integer;
begin
  result:=0;
end;

function TdemoInterface.getMinADC:integer;
begin
  result:=-32768;
end;

function TdemoInterface.getMaxADC:integer;
begin
  result:=32767;
end;

function TDemoInterface.nbVoieAcq(n: integer): integer;
begin
  result:=n+ord(FuseTagStart);
end;


procedure TdemoInterface.setVSoptions;
begin
  FuseTagStart:=true;
end;



function TDemoInterface.getNrnSymbolNames(cat: integer): TstringList;
begin

  result:=TstringList.create;
  result.Add('DemoName');

end;

procedure TDemoInterface.copySample(i:integer);
var
  Ag,v:integer;
begin
  Ag:=(i mod nbpt0DMA) div nbvoie;
  v:= (i mod nbpt0DMA) mod nbvoie;

  Psingle(@wsample)^:=Psingle( intG(buf)+Ag*AgTotSize + AgOffsets[v])^;
  LastSampleSize:=AgSampleSizes[v];
  storeWsample;

end;


procedure initElphyDemo;
begin
  RegisterBoard('Elphy Demo',pointer(TDemoInterface));
end;



Initialization
AffDebug('Initialization DemoBrd1',0);
initElphyDemo;

end.
