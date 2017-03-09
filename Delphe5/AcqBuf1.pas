unit AcqBuf1;

INTERFACE
{$IFDEF FPC} {$mode delphi} {$DEFINE AcqElphy2} {$A1} {$Z1} {$ENDIF}

uses windows,classes,forms,graphics,controls,sysUtils,
     util1,Ddosfich,debug0,clock0,stmdef,syncObjs,dtf0,
     AcqBrd1,NIbrd1,
     dac2file,stmvec1,
     stmMemo1,
     acqDef2,AcqInf2,StimInf2,
     AcqCom1,dataGeneFile;


var
  memoA:TstmMemo;

type
  TthreadInt=class(Tthread)
               Fdigi:boolean;
               nbvMbuf,nbvAna,nbvEv:integer;
               nbptTotSeq:integer;
               evtIndex:integer;
               cntInt:integer;

               procInt:procedureOfObject;

               constructor create(createSuspended:boolean);
               procedure execute;override;
               procedure doNothing;

               function executeLoop:integer;
              end;




function getIntTime:single;
function getMaxIntTime:single;

var
  threadInt:TthreadInt;
  eventInt:Tevent;



procedure afficheInfos;


procedure AdjustMainBuffers;

procedure AdjustMainBuf;


IMPLEMENTATION



{*************************  **************************}

procedure FreeBufEv;
var
  i:integer;
begin
  for i:=low(EvtBuf) to high(EvtBuf) do
  begin
    EvtBuf[i].free;
    EvtBuf[i]:=nil;
  end;
  DigEvtBuf:=nil;
end;

procedure allouerBufEv;
var
  i:integer;
begin
  FreeBufEv;

  for i:=1 to AcqInf.Qnbvoie do
  case AcqInf.ChannelType[i] of
    TI_AnaEvent:
      EvtBuf[i]:=TmultiMainBuf.create(g_longint,MaxSimpleEvt,AcqInf.periodeParVoieMS); // 100000 evts max par épisode
    TI_digiEvent:
      begin
        EvtBuf[i]:=TmultiMainBuf.create(g_longint,MaxPhoton,0.001);// 1 million d'evts !
        DigEvtBuf:=EvtBuf[i];
      end;
  end;

end;


procedure FreeMultiMainBuf;
var
  i:integer;
begin
  for i:=0 to length(MultiMainBuf)-1 do MultiMainBuf[i].free;
  for i:=0 to length(MultiEvtBuf)-1 do MultiEvtBuf[i].free;

  setLength(MultiMainBuf,0);
  setLength(MultiEvtBuf,0);

  MultiCyberTagBuf.free;
  MultiCyberTagBuf:=nil;
end;


procedure AdjustSingleMainBuf;
const
  tailleMiniDac=500000;
  tailleMiniAdc=65536;
var
  tailleSeq,tailleOpti:integer;
  MinDuration: double;
begin
  {stratégie: les buffers ADC ou DAC doivent contenir
     au moins 10 secondes d'enregistrement
     au moins 2 séquences
     un buffer de taille mini tailleMiniAdc
     contenir un multiple du nombre de points par séquence

   }

  if acqInf.continu and (UserMinimalTimeInBuffer<>0)
    then MinDuration:= UserMinimalTimeInBuffer*1000
    else MinDuration:= 10E3;

  tailleOpti:=roundL(MinDuration/acqInf.periodeParVoieMS);   {nb de pts par voie approximatif en 10 secondes }
  tailleOpti:=tailleOpti*AcqInf.AgTotSize;            {taille en octets}
  if tailleOpti<tailleMiniADC then tailleOpti:=(tailleMiniADC div AcqInf.AgTotSize) * AcqInf.AgTotSize;

  if not acqInf.continu then
    begin
      tailleSeq:=AcqInf.AgTotSize*AcqInf.Qnbpt;
      if 2*tailleSeq>tailleOpti
        then tailleOpti:=2*tailleSeq
        else tailleOpti:=tailleOpti div tailleSeq*tailleSeq;
      nbseq0:=tailleOpti div tailleSeq;
    end
  else
    begin
      nbseq0:=1;
    end;

  mainBufSize:=tailleOpti;

  reallocmem(mainBuf,mainBufSize+10);    // +10 car dans DemoBrd1, la routine asm  écrit 4 octets au lieu de 2
  fillchar(mainbuf^,mainBufSize,0);

  nbAg0:=mainBufSize div AcqInf.AgTotSize;
  FreeMultiMainBuf;
end;

procedure AdjustMultiMainBuf;
const
  tailleMiniAdc=65536;
var
  tailleSeq,tailleOpti:integer;
  i:integer;
  MinDuration: float;
  MeMax:integer;
begin
  {stratégie: les buffers ADC ou DAC doivent contenir
     au moins 10 secondes d'enregistrement
     au moins 2 séquences
     au moins 20000 points
     contenir un multiple du nombre de points par séquence

   }

  if acqInf.continu and (UserMinimalTimeInBuffer<>0)
    then MinDuration:= UserMinimalTimeInBuffer*1000
    else MinDuration:= 10E3;

  tailleOpti:=roundL(MinDuration/acqInf.periodeParVoieMS);   {nb de pts par voie approximatif en 10 secondes }

//  tailleOpti:=roundL(10E3/acqInf.periodeParVoieMS);   {nb de pts par voie approximatif en 10 secondes }

  if not acqInf.continu then
    begin
      tailleSeq:=AcqInf.Qnbpt;
      if 2*tailleSeq>tailleOpti
        then tailleOpti:=2*tailleSeq
        else tailleOpti:= (tailleOpti div tailleSeq) *tailleSeq;
      nbseq0:=tailleOpti div tailleSeq;
    end
  else
    begin
      nbseq0:=1;
    end;

  { tailleOpti est le nombre de point par voie non décimée }

  FreeMultiMainBuf;
  setLength(MultiMainBuf,AcqInf.nbVoieAcq);
  if length(MultiMainBuf)>0
    then fillchar(MultiMainBuf[0],sizeof(MultiMainBuf[0])*length(MultiMainBuf),0);

  with AcqInf do
  for i:=1 to QnbVoie do
  begin
    case ChannelType[i] of
      TI_analog:   if QKS[i]<>0
                      then MultiMainBuf[i-1]:=TmultiMainBuf.create(ChannelNumType[i], tailleOpti div QKS[i],acqInf.periodeParVoieMS); {dx non utilisé}
    end;
  end;
  with AcqInf do
  if board.TagMode=tmCyberK then
    MultiCyberTagBuf:=TmultiMainBuf.createWithCybTag(g_smallint, tailleOpti, acqInf.periodeParVoieMS); {dx non utilisé}

  setLength(MultiEvtBuf,AcqInf.nbVoieSpk);
  if length(MultiEvtBuf)>0
    then fillchar(MultiEvtBuf[0],sizeof(MultiEvtBuf[0])*length(MultiEvtBuf),0);

  if UserMaxMultiEvt>MaxMultiEvt then meMax:= UserMaxMultiEvt else meMax:= MaxMultiEvt;
  with AcqInf do
  for i:=1 to nbVoieSpk do
     MultiEvtBuf[i-1]:=TmultiMainBuf.createWithWaves(G_longint,meMax,CyberWaveLen,acqInf.periodeParVoieMS);

  {libérer mainBuf}
  freemem(mainBuf);
  mainBuf:=nil;
  mainBufSize:=0;

  nbAg0:=TailleOpti;

  FlagFullMulti:=false;
  FlagFullEvt:=false;
end;

procedure AdjustMainBuf;
begin
  if FMultiMainBuf
    then adjustMultiMainBuf
    else adjustSingleMainBuf;
end;



procedure AdjustMainBuffers;
var
  dx:float;
begin
  AdjustMainBuf;
  AllouerBufEv;

  PCLbuf.Free;
  PCLbuf:=nil;

  if AcqInf.continu then dx:=1 else dx:=1000;
  if AcqInf.AcqPhotons>0 then PCLbuf:=TPCLbuf.create(MaxPhoton, dx );

end;



{*************************** Thread interruption ***************************}



constructor TthreadInt.create(createSuspended:boolean);
begin
  board.initGlobals;

  board.setDoAcq(procInt);
  if not assigned(procInt) then procInt:=DoNothing;

  inherited create(createSuspended);
  priority:=tpTimeCritical;
end;

procedure TthreadInt.execute;
begin
  repeat
    inc(cntInt);

    ProcInt;

    if cntInt mod 3=0 then eventInt.setEvent;

    sleepEx(10,false);
  until terminated;
end;

procedure TthreadInt.doNothing;
begin
end;

function TthreadInt.executeLoop:integer;
begin
  procInt;
  result:=board.getSampleIndex;
end;


function getIntTime:single;
begin
  if nbInt>0
    then result:=IntTime/nbInt
    else result:=0;
end;

function getMaxIntTime:single;
begin
  result:=IntTimeMax;
end;


procedure afficheInfos;
const
  LF=#10+#13;
begin
  with acqInf do
  messageCentral('DureeSeq='+Estr(dureeSeq,3)+LF+
                 'Periode='+Estr(PeriodeUS,3)+LF+
                 'PeriodeParVoie='+Estr(PeriodeParVoie,3)
                 );
  with paramStim do
  messageCentral('ActiveChannels='+Istr(ActiveChannels)+LF+
                 'nbpt='+Istr(nbpt)+LF+
                 'nbpt1='+Istr(nbpt1)+LF+
                 'periodeParDac='+Estr(periodeParDac,3)+LF+
                 'ISI='+Estr(ISI,3)+LF+
                 'ISIpts='+Istr(ISIpts)

                 );

end;

{************************ Initialisation *********************************}

Initialization
AffDebug('Initialization AcqBuf1',0);

eventInt:=Tevent.create(nil,false,false,'');

finalization

eventInt.free;

end.
