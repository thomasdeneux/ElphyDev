unit RtimeBrd;


interface

uses windows,classes,sysUtils,
     util1,Dgraphic,varconf1,
     debug0,
     stmdef,AcqBrd1,
     cbOpt0,windriver0;

{ Driver test pour PCI-DAS1600 temps réel
}

type
  TRealTimeInterface = class(TacqInterface)

  protected
      WD0: TPCIdriver;

      function getCount:integer;override;
      function getCount2:integer;override;

      procedure nextSample;override;

      procedure relancer;override;

   public
      constructor create(var st1:driverString);override;
      destructor destroy;override;

      procedure init(nbVoieTot:integer);override;
      procedure lancer;override;
      procedure terminer;override;

      function dataFormat:TdataFormat;override;
      function dacFormat:TdacFormat;override;



      function PeriodeElem:float;override;
      function PeriodeMini:float;override;

      procedure outdac(num,j:word);override;
      procedure outDIO(j:word);override;
      function inADC(n:integer):smallint;override;
      function inDIO:word;override;

      function RAngeString:string;override;
      function MultiGain:boolean;override;
      function gainLabel:string;override;
      function nbGain:integer;override;

      function channelRange:boolean;override;

      procedure GetOptions;override;
      procedure setDoAcq(var procInt:ProcedureOfObject);override;

      procedure initcfgOptions(conf:TblocConf);override;

      function tagShift:integer;override;


      function getMinADC:integer;override;
      function getMaxADC:integer;override;
    end;

procedure initRTboards(drivers:TstringList);

implementation

uses acqCom1,
     {$IFDEF AcqElphy2}acqDef2 {$ELSE}acqDef1 {$ENDIF}
     ;

var
  FCBdma,FCB16:boolean;

constructor TRealTimeInterface.create(var st1:driverString);
begin
  boardFileName:='DAS 1600 Real Time';

  WD0:=TPCIdriver.Create;
  if not WD0.Open($1307,$10,0) then
  begin
    WD0.free;
    WD0:=nil;
  end;
end;

destructor TRealTimeInterface.destroy;
begin
  WD0.free;
end;


procedure TRealTimeInterface.init(nbVoieTot:integer);
begin
  tabDma1:=@WD0.lastData[0];
  nbpt0DMA:=maxDataPCIdriver;

  tabDma2:=nil;
  FnbptDacDMA:=0;

  initPadc;

  GI1:=-1;
  GI1x:=-1;

  cntStim:=0;
  initPdac(0);
  loadDmaDAC;

end;


procedure TRealTimeInterface.nextSample;assembler;
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

     mov   wsample,ax

@@2: mov   wsampleR,ax

@fin:pop   esi
end;


procedure TRealTimeInterface.lancer;
begin
  if assigned(WD0) then
  begin
     WD0.setAcq;
  end;
end;

procedure TRealTimeInterface.relancer;
begin
end;


procedure TRealTimeInterface.terminer;
begin
  if assigned(WD0) then WD0.doneAcq;
end;


function TRealTimeInterface.dataFormat:TdataFormat;
begin
  result:=F16bits;
end;

function TRealTimeInterface.DacFormat:TdacFormat;
begin
  result:=DacF12bits;
end;


function TRealTimeInterface.getCount:integer;
begin
  result:=WD0.cntData;
end;


function TRealTimeInterface.getCount2:integer;
begin
  result:=0;
end;


function TRealTimeInterface.PeriodeElem:float;
begin
  result:=1;
end;

function TRealTimeInterface.PeriodeMini:float;
begin
  result:=100;
end;

procedure TRealTimeInterface.outdac(num,j:word);
begin
end;

procedure TRealTimeInterface.outDIO(j:word);
begin
end;

function TRealTimeInterface.inADC(n:integer):smallint;
begin
end;

function TRealTimeInterface.inDIO:word;
begin
end;



function TRealTimeInterface.RangeString:string;
var
  i:integer;
begin
  result:='';
end;

function TRealTimeInterface.MultiGain:boolean;
begin
  result:=false;
end;

function TRealTimeInterface.GainLabel:string;
begin
  result:='Range';
end;

function TRealTimeInterface.nbGain;
begin
  result:=1;
end;

function TRealTimeInterface.channelRange:boolean;
begin
  result:=true;
end;

procedure TRealTimeInterface.GetOptions;
begin
end;

procedure TRealTimeInterface.setDoAcq(var procInt:ProcedureOfObject);
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

procedure TRealTimeInterface.initcfgOptions(conf:TblocConf);
begin
  with conf do
  begin
  end;
end;

function TRealTimeInterface.tagShift:integer;
begin
  result:=0;
end;


function TRealTimeInterface.getMinADC:integer;
begin
  result:=-32768;
end;

function TRealTimeInterface.getMaxADC:integer;
begin
  result:=32768;
end;


procedure initRTboards(drivers:TstringList);
begin


 drivers.AddObject('Real Time DAS 1600',pointer(TRealTimeInterface));

end;


end.
