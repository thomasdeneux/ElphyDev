unit stmAuxInt1;

{ TauxStimulator permet de piloter une carte PD2-AO-16/32 de UEI

  Trigger : entrée IRQC borne 31 sur J2

  Ext Clock : TMR2 borne 4 sur J2


  J2 connector  (view looking into the connector as mounted on the board):

                  DGND   1  2   DGND
                  TMR0   3  4   TMR2
                  DGND   5  6   DGND
                  DGND   7  8   DGND
                  ..................           ==> arrière de la carte
                  IRQC  31  32  DGND
                  DGND  33  34   DGND
                  DGND  35  36   DGND


  Relier les TMR2 avec une résistance de 100 ou 200 ohms pour la synchronisation
}



interface
{$IFDEF FPC} {$mode delphi} {$DEFINE AcqElphy2} {$A1} {$Z1} {$ENDIF}

uses windows, classes,
     util1,dtf0,varconf1, debug0,
     pwrdaq32G, pwrDaqG,pdfw_defG,
     stmdef,stmObj,stmVec1,Ncdef2,stmPg;

type
  typeChannel=  record
                  PhysNum:byte;
                  Adapt:byte;             { Adapter Num }
                  IBuf:byte;              { Buffer Index }
                  Jru1,Jru2:integer;
                  Yru1,Yru2:single;
                  unitY:string[10];
                end;
  Pchannel=^typeChannel;

  TauxStimulator= class;
  TthreadAux=class(TThread)
               stim:TauxStimulator;
               NumAdapt:integer;
               error:integer;
               NbInt:integer;
               TimeInt:array[1..100] of integer;
               constructor create(stim1:TauxStimulator; Num:integer);
               procedure execute;override;
             end;


  TauxStimulator= class(typeUO)
                 private
                   FlagSwap: boolean;

                   MaxChCount:integer;
                   hdriver:Thandle;
                   Adapter:Dword;
                   hAdapter:array[0..1] of Thandle;
                   hNotifyEvent: array[0..1] of Thandle;
                   AdapterCount:Dword;

                   PDVersion : PWRDAQ_VERSION;
                   PDPciConfig : array[0..1] of PWRDAQ_PCI_CONFIG;
                   AdapterInfo : array[0..1] of TADAPTER_INFO_STRUCT;

                   Buffer: array[0..1] of PtabWord;
                   BufSize:integer;

                   Fchannel:array of typeChannel;

                   vecA:array of Tvector;

                   FextClock: boolean;

                   Fcontinuous:boolean;
                   FrameCount:integer;
                   UserFrameCount:integer;
                   CurFrame:integer;        { mis à jour par l'int  commence à zéro}
                   LastFrame:integer;       { dernier traité }

                   EventsToNotify:Dword;
                   Thread:array[0..1] of TthreadAux;

                   BuildEp: Tpg2Event;

                   function getchannel(logCh:integer):Pchannel;
                   procedure initVectors;
                   procedure updateVectors(FrameNum:integer);
                   function installBuffers:boolean;
                   function ClkDivisor:integer;

                   procedure SetSwapMode(w:boolean);
                 public
                   EpDuration:float;
                   SamplingInt:float;

                   constructor create;override;
                   destructor destroy;override;
                   class function STMClassName:AnsiString;override;

                   property Channel[i:integer]:Pchannel read getChannel;
                      { Canal logique 1 à MaxChCount}

                   function Dyu(v:integer):float;
                   function y0u(v:integer):float;
                   function dxu:float;
                   function x0u:float;
                   function unitX:AnsiString;

                   function PtsPerChannel:integer;

                   procedure StartCont(Ftrig:boolean);
                   Procedure StartEp(Ftrig:boolean);
                   Procedure Start(Ftrig:boolean);
                   Procedure Stop;

                   procedure Update;
                   procedure BuildNextFrame;
                 end;


procedure proTauxChannel_PhysNum(w:integer;pu:Pchannel);pascal;
function fonctionTauxChannel_PhysNum(pu:Pchannel):integer;pascal;
function fonctionTauxChannel_Dy(pu:Pchannel):float;pascal;
function fonctionTauxChannel_y0(pu:Pchannel):float;pascal;
procedure proTauxChannel_unitY(w:AnsiString;pu:Pchannel);pascal;
function fonctionTauxChannel_unitY(pu:Pchannel):AnsiString;pascal;
procedure proTauxChannel_setScale(j1,j2:integer;y1,y2:float;pu:Pchannel);pascal;

procedure proTauxStimulator_Create(stname:AnsiString; var pu:typeUO);pascal;
procedure proTauxStimulator_Create_1( var pu:typeUO);pascal;
procedure proTauxStimulator_Create_2( Sim:boolean; Nadapter:integer; var pu:typeUO);pascal;

procedure proTauxStimulator_ChannelCount(w:integer;var pu:typeUO);pascal;
function fonctionTauxStimulator_ChannelCount(var pu:typeUO):integer;pascal;
function fonctionTauxStimulator_Channels(n:integer;var pu:typeUO):pointer;pascal;
function fonctionTauxStimulator_vector(num:integer;var pu:typeUO):Tvector;pascal;


function fonctionTauxStimulator_EpDuration(var pu:typeUO):float;pascal;
procedure proTauxStimulator_EpDuration(w:float;var pu:typeUO);pascal;
function fonctionTauxStimulator_SamplingInt(var pu:typeUO):float;pascal;
procedure proTauxStimulator_SamplingInt(w:float;var pu:typeUO);pascal;
function fonctionTauxStimulator_SamplesPerChannel(var pu:typeUO):integer;pascal;
procedure proTauxStimulator_InitVectors(var pu:typeUO);pascal;

procedure proTauxStimulator_Start(Ftrig:boolean;var pu:typeUO);pascal;
procedure proTauxStimulator_Stop(var pu:typeUO);pascal;

function fonctionTauxStimulator_ExternalClock(var pu:typeUO):boolean;pascal;
procedure proTauxStimulator_ExternalClock(w:boolean;var pu:typeUO);pascal;

function fonctionTauxStimulator_Fcontinuous(var pu:typeUO):boolean;pascal;
procedure proTauxStimulator_Fcontinuous(w:boolean;var pu:typeUO);pascal;

procedure proTauxStimulator_buildEp(w:integer;var pu:typeUO);pascal;
function fonctionTauxStimulator_buildEp(var pu:typeUO):integer;pascal;

procedure proTauxStimulator_Update(var pu:typeUO);pascal;
procedure proTauxStimulator_EpCount(w:integer;var pu:typeUO);pascal;
function fonctionTauxStimulator_EpCount(var pu:typeUO):integer;pascal;

procedure proTauxStimulator_BuildNextEpisod(var pu:typeUO);pascal;

procedure proTauxStimulator_FSwapAdapters(w:boolean;var pu:typeUO);pascal;
function fonctionTauxStimulator_FswapAdapters(var pu:typeUO):boolean;pascal;


implementation

Const
  SimMode:boolean=false; { si True, on peut tester sans la présence de la carte }
  NbAdapter:integer=0;
                 



{ TauxStimulator }


constructor TauxStimulator.create;
var
  Error:Dword;
  i:integer;
  ok:boolean;
  hDum: Thandle;
  dwAOutCfg : array[0..1] of DWORD;

begin
  inherited;

  UserFrameCount:=2;

  if not SimMode then
  begin
    if not InitPowerDaq32 then exit;

    { Open Driver + Adapter }
    ok:= PdDriverOpen(@hDriver, @Error, @AdapterCount);

    if (NbAdapter>0) and (NbAdapter<=AdapterCount) then AdapterCount:=NbAdapter;

    if ok then
    for i:=0 to AdapterCount-1 do
      ok:= _PdAdapterOpen(i, @Error, @hAdapter[i]);


    { Get some Info }
    if ok then ok:= PdGetVersion(hDriver, @Error, @PDVersion);
    if ok then
      for i:=0 to AdapterCount-1 do

        ok:= PdGetPciConfiguration(hAdapter[i],  @Error, @PDPciConfig[i]);
    if ok then
      for i:=0 to AdapterCount-1 do
        ok:= _PdGetAdapterInfo(i, @Error, @AdapterInfo[i]);

    { Init subSystem}
    if ok then
      for i:=0 to AdapterCount-1 do
        ok:= PdAdapterAcquireSubsystem(hAdapter[i], @Error, AnalogOut, 1);

    dwAOutCfg[0]:=AOB_CVSTART0 + AOB_DMAEN  + AOB_INTCVSBASE; {internal clock }
    dwAOutCfg[1]:=AOB_CVSTART1 + AOB_DMAEN  ;                 {external Clock }


    if ok then
      for i:=0 to AdapterCount-1 do
      begin
        ok:= _PdAO32Reset(hAdapter[i],@Error);


        ok:= _PdAOutSetCfg(hAdapter[i], @error, dwAOutCfg[i], 0);
      end;
    if not ok then sortieErreur('Unable to initialize AuxStimulator. Error='+Istr(error));
  end
  else
  begin
    AdapterCount:=NbAdapter;
  end;


  samplingInt:=1;
  EpDuration:=1000;

  MaxChCount:= AdapterCount*32;

  setLength(Fchannel,MaxChCount);
  setLength(vecA,MaxChCount);
  for i:=0 to MaxChCount-1 do
  begin
    vecA[i]:=Tvector.create;
    vecA[i].NotPublished:=true;
    vecA[i].Fchild:=true;
  end;

  for i:=1 to MaxChCount do
    AddTochildList(vecA[i-1]);

end;

destructor TauxStimulator.destroy;
var
  Error:Dword;
  i:integer;
begin
  for i:=0 to MaxChCount-1 do vecA[i].free;

  if not SimMode then
  begin
    stop;

    for i:=0 to AdapterCount-1 do
    begin
      if assigned(Buffer[i]) and not _PdReleaseBuffer(hAdapter[i], @Error,AnalogOut, Pointer(Buffer[i]))
        then messageCentral('_PdReleaseBuffer error='+Istr(error));

      if not PdAdapterAcquireSubsystem(hAdapter[i], @Error, AnalogOut, 0)
        then messageCentral('PdAdapterAcquireSubsystem error='+Istr(error));

      if not _PdAdapterClose(hAdapter[i], @Error)
        then messageCentral('_PdAdapterClose error='+Istr(error));
    end;

    if not PdDriverClose(hDriver, @Error)
      then messageCentral('PdDriverClose error='+Istr(error));
  end
  else
  for i:=0 to AdapterCount-1 do freemem(Buffer[i]);

  inherited;
end;

function TauxStimulator.getchannel(logCh: integer): Pchannel;
begin
  if (logCh>=1) and (logCh<=length(Fchannel))
    then result:=@Fchannel[logCh-1]
    else result:=nil;
end;

function TauxStimulator.installBuffers:boolean;
var
  Error:Dword;
  dwFrames, dwFrameScans,dwScanSamples:integer;
  i,j:integer;
  dwMode:integer;
begin
  if Fcontinuous then
  begin
    FrameCount:=UserFrameCount;
    if FrameCount<2 then FrameCount:=2;
    dwMode:=BUF_BUFFERRECYCLED;
  end
  else
  begin
    FrameCount:=2;
    dwMode:=0;// AIB_BUFFERWRAPPED;
  end;

  if not SimMode then
  for i:=0 to AdapterCount-1 do
  begin
    dwFrames:=FrameCount;
    dwScanSamples:=32;

    dwFrameScans:= PtsPerChannel;

    if not _PdAO32Reset(hAdapter[i],@Error)
      then messageCentral('_PdAO32Reset Error='+Istr(error));

    result:= _PdAcquireBuffer(hAdapter[i],@Error, @Buffer[i], dwFrames, dwFrameScans,dwScanSamples,
                          AnalogOut, dwMode);
    if not result
      then messageCentral('_PdAcquireBuffer error='+Istr(error))
      else
      for j:=0 to dwFrames*dwFrameScans*dwScanSamples-1 do Buffer[i]^[j]:=32768;

  end
  else
  for i:=0 to AdapterCount-1 do
  begin
    getmem(Buffer[i],PtsPerChannel*32*2*FrameCount);
    fillchar(Buffer[i]^,PtsPerChannel*32*2*FrameCount,0);
    result:=true;
  end;
end;

procedure TauxStimulator.startEp(Ftrig:boolean);
var
  dwAOutCfg : array[0..1] of DWORD;
  dwAOutCvClkDiv : DWORD;
  dwChListSize : DWORD;
  ChList : Array[0..1,0..31] of Dword;
  error:Dword;
  i,j:integer;
  ok:boolean;

begin
  if SimMode then exit;

  dwAOutCfg[0]:=AOB_CVSTART0 + AOB_DMAEN  + AOB_INTCVSBASE; {internal clock }
  dwAOutCfg[1]:=AOB_CVSTART1 + AOB_DMAEN  ;                 {external Clock }


  if Ftrig then
      dwAOutCfg[0]:=dwAOutCfg[0] + AOB_STARTTRIG0  {+ AOB_STARTTRIG1} ;

  for i:=0 to 1 do
  ok:= _PdAOutSetCfg(hAdapter[i], @error, dwAOutCfg[i], 0);


  dwAOutCvClkDiv:= ClkDivisor -1;


  EventsToNotify:=0;

  dwChListSize:=32;

  fillchar(chlist,sizeof(chlist),255);
  for i:=1 to MaxChCount do
  with channel[i]^ do
  begin
    Chlist[adapt,Ibuf]:=PhysNum mod 32;
  end;

  for i:= adapterCount-1 downto 0 do
  begin
    if not _PdAO32Reset(hAdapter[i],@Error)
      then messageCentral('_PdAO32Reset Error='+Istr(error));
    if not _PdAOAsyncInit(hAdapter[i],@Error, dwAOutCfg[i],dwAOutCvClkDiv,EventsToNotify,dwChListSize,@ChList[i,0])
      then messageCentral(' _PdAOAsyncInit Error='+Istr(error));

    //_PdAO32SetUpdateChannel(hAdapter[i], @Error, 0, true);
  end;


  for i:=adapterCount-1 downto 0 do
  begin
    if not _PdAOAsyncStart(hAdapter[i],@Error)
      then messageCentral('_PdAOAsyncStart  Error='+Istr(error));
  end;
end;


procedure TauxStimulator.startCont(Ftrig:boolean);
var
  dwAOutCfg : array[0..1] of DWORD;
  dwAOutCvClkDiv : DWORD;
  dwChListSize : DWORD;
  ChList : Array[0..1,0..31] of Dword;
  error:Dword;
  i,j:integer;
begin
  if SimMode then exit;

  dwAOutCfg[0]:=AOB_CVSTART0 + AOB_DMAEN  +AOB_INTCVSBASE; {internal clock }
  dwAOutCfg[1]:=AOB_CVSTART1 + AOB_DMAEN  ; {external Clock }


  if Ftrig then
    dwAOutCfg[0]:=dwAOutCfg[0] + AOB_STARTTRIG0;

  dwAOutCvClkDiv:= ClkDivisor -1;

  {EventsToNotify:= eTimeout or eFrameDone or eBufferDone or eBufferError or eStopped;}
  EventsToNotify:=0;

  dwChListSize:=32;

  fillchar(chlist,sizeof(chlist),255);
  for i:=1 to MaxChCount do
  with channel[i]^ do
  begin
    Chlist[adapt,Ibuf]:=PhysNum mod 32;
  end;

  for i:=0 to adapterCount-1 do
  begin
    if not _PdAO32Reset(hAdapter[i],@Error)
      then messageCentral('_PdAO32Reset Error='+Istr(error));
    if not _PdAOAsyncInit(hAdapter[i],@Error, dwAOutCfg[i],dwAOutCvClkDiv,EventsToNotify,dwChListSize,@ChList[i,0])
      then messageCentral(' _PdAOAsyncInit Error='+Istr(error));

    (*
    if not _PdAOSetPrivateEvent(hAdapter[i], @hNotifyEvent[i])
      then messageCentral(' _PdAOAsetPrivateEvent Error=');

    if not _PdSetUserEvents(hAdapter[i], @Error, AnalogOut, EventsToNotify)
      then messageCentral(' _PdSetUserEvent Error='+Istr(error));

    *)
  end;

  for i:=0 to adapterCount-1 do
  begin
    if not _PdAOAsyncStart(hAdapter[i],@Error)
      then messageCentral('_PdAOAsyncStart  Error='+Istr(error))
  end;
  (*
  for i:=0 to adapterCount-1 do
    Thread[i]:=TthreadAux.create(self,i);
  *)
end;

procedure TauxStimulator.start(Ftrig:boolean);
begin
  if Fcontinuous
    then startCont(Ftrig)
    else startEp(Ftrig);
end;

procedure TauxStimulator.stop;
var
  Error : DWORD;
  res:boolean;
  i:integer;
begin
  if SimMode then exit;

  for i:=0 to AdapterCount-1 do
  begin
    if not _PdAOAsyncStop(hAdapter[i], @Error) then messageCentral('AsyncStop Error='+Istr(error));

    if (hNotifyEvent[i]<>0) then
    begin
      if not _PdAOClearPrivateEvent(hAdapter[i], @hNotifyEvent[i]) then messageCentral('PdAOClearPrivateEvent error='+Istr(error));
      _PdClearUserEvents(hAdapter[i], @Error, AnalogOut, eAllEvents);
      hNotifyEvent[i]:=0;
    end;

    if not _PdAOAsyncTerm(hAdapter[i], @Error) then  messageCentral('AsyncTerm Error='+Istr(error));

    if assigned(Thread[i]) then
    begin
      if thread[i].error<>0 then messageCentral('Thread Error='+Istr(thread[i].Error));
      messageCentral('nbInt='+Istr(thread[i].NbInt)+'  time='+Istr(thread[i].TimeInt[thread[i].NbInt]) );

      Thread[i].Free;
      Thread[i]:=nil;
    end;

  end;
end;

function TauxStimulator.ClkDivisor: integer;
begin
  Result:= round(33E6 * samplingInt/1000/ 32   );
end;

procedure TauxStimulator.initVectors;
var
  i:integer;
  dat:typeDataW;
  nbch1,nbch2:integer;
  Fcheck:array[0..63] of boolean;
  error,scanIndex,numscans:integer;
begin
  if not installBuffers then exit;

  fillchar(Fcheck,sizeof(Fcheck),0);


  nbch1:=0;
  nbch2:=0;
  for i:=1 to MaxChCount do
  with channel[i]^ do
  begin
    PhysNum:= PhysNum mod MaxChCount;
    Fcheck[PhysNum]:=true;

    if PhysNum<32 then
    begin
      adapt:=0;
      inc(nbch1);
      Ibuf:=nbCh1-1;
    end
    else
    begin
      adapt:=1;
      inc(nbch2);
      Ibuf:=nbCh2-1;
    end;
  end;

  for i:=0 to MaxChCount-1 do
    if not Fcheck[i] then
    begin
      messageCentral('Physical numbers are not consistent');
      exit;
    end;

  for i:=1 to MaxChCount do
  with vecA[i-1] do
  begin
    dat:=typeDataW.create(@Buffer[channel[i].adapt,channel[i].Ibuf] , 32,0,0,PtsPerChannel-1);
    { Toujours Frame0 }
    initDat1Ex(dat,G_word);
    inf.readOnly:=false;

    ident:='V'+Istr(i);
    tagUO:=i;

    x0u:=0;
    dxu:=self.dxu;
    dyu:=self.dyu(i);
    y0u:=self.y0u(i);
    unitY:=Fchannel[i-1].unitY;
    unitX:='ms';
  end;

  ClearChildList;
  for i:=1 to MaxChCount do
  AddTochildList(vecA[i-1]);
  sysList.FModified:=true;

  if Fcontinuous and BuildEp.valid then
  begin
    for i:=0 to FrameCount-1 do
    begin
      updateVectors(i);
      with BuildEp do
      if valid then pg.executerProcedure1(ad,i+1);
    end;

    curFrame:=FrameCount-1;
    LastFrame:=CurFrame;
  end;

end;

procedure TauxStimulator.updateVectors(FrameNum:integer);
var
  i:integer;
  dat:typeDataW;
begin
  FrameNum:=FrameNum mod FrameCount;

  for i:=1 to MaxChCount do
  with vecA[i-1] do
  begin
    dat:=typeDataW.create(@Buffer[channel[i].adapt,channel[i].Ibuf + FrameNum*PtsPerChannel*32], 32,0,0,PtsPerChannel-1);
    initDat1Ex(dat,G_word);
    inf.readOnly:=false;

    x0u:=0;
    dxu:=self.dxu;
    dyu:=self.dyu(i);
    y0u:=self.y0u(i);

  end;
end;


function TauxStimulator.Dyu(v:integer):float;
var
  p:Pchannel;
begin
  p:=channel[v];
  if assigned(p) then
  with p^ do
  begin
    if jru1<>jru2
      then Dyu:=(Yru2-Yru1)/(jru2-jru1)
      else Dyu:=1;
  end
  else result:=1;
end;

function TauxStimulator.y0u(v:integer):float;
var
  dyB:float;
  p:Pchannel;
begin
  p:=channel[v];
  if assigned(p) then
  with p^ do
  begin
    if jru1<>jru2
      then DyB:=(Yru2-Yru1)/(jru2-jru1)
      else DyB:=1;

    y0u:=Yru1-Jru1*DyB;
  end
  else result:=0;
end;

function TauxStimulator.dxu:float;
begin
  result:=Clkdivisor*1000*32 /33E6;
end;

function TauxStimulator.PtsPerChannel: integer;
begin
  result:=round(Epduration/dxu);
  if Fcontinuous
    then result:=(result div 1024)*1024;
end;


function TauxStimulator.unitX: AnsiString;
begin
  result:='ms';
end;

function TauxStimulator.x0u: float;
begin
  result:=0;
end;

class function TauxStimulator.STMClassName: AnsiString;
begin
  result:='AuxStimulator';
end;


procedure TauxStimulator.Update;
var
  i:integer;
  NewFrame:integer;
begin
(*
  NewFrame:=CurFrame;    { CurFrame peut changer en cours de calcul }
  if NewFrame-LastFrame>FrameCount-1
    then sortieErreur('TauxStimulator.update : unable to update. Diff='+Istr(NewFrame-LastFrame));

  for i:=LastFrame+1 to NewFrame do
  begin
    updateVectors(i);
    with BuildEp do
    if valid then pg.executerProcedure1(ad,i);
  end;
  LastFrame:=NewFrame;
  *)
end;

procedure TauxStimulator.BuildNextFrame;
begin
  inc(LastFrame);
  updateVectors(LastFrame);
  with BuildEp do
  if valid then pg.executerProcedure1(ad,LastFrame+1);
end;

procedure TauxStimulator.SetSwapMode(w: boolean);
var
  hDum: Thandle;
begin
  if (FlagSwap<>w) and (AdapterCount=2) then
  begin
    hdum:=hAdapter[0];
    hAdapter[0]:=hAdapter[1];
    hAdapter[1]:=hDum;
    FlagSwap:=w;
  end;
end;

{ TthreadAux }

constructor TthreadAux.create(stim1: TauxStimulator; Num:integer);
begin
  stim:=stim1;
  NumAdapt:=num;
  inherited create(false);
end;

procedure TthreadAux.execute;
var
  res:integer;
  events:longword;
  scanIndex,numScans:integer;
  frame:integer;
  tt:integer;
begin
  tt:=0;
  with stim do
  repeat
    res:=WaitForSingleObject(hNotifyEvent[NumAdapt],100);
    inc(tt);

    if res = WAIT_OBJECT_0 then
    begin
      inc(nbInt);
      TimeInt[nbInt]:=tt;
      if not _PdGetUserEvents(hAdapter[NumAdapt],@Error, AnalogOut, @events) then error:=2;

      if not _PdSetUserEvents(hAdapter[NumAdapt],@Error, AnalogOut, eventsToNotify) then error:=3;

      if (events and eTimeout<>0) then error:=4;
      if (events and eBufferError<>0) then error:=5;
      if (events and eBufferDone<>0) or (events and eFrameDone<>0) then
      begin
        if not _PdAOGetBufState(hAdapter[NumAdapt],@Error, PtsPerChannel, @scanIndex, @numScans) then error:=7;
        if numscans>0 then
        begin
          Frame:=scanIndex div PtsPerChannel;
          inc(curFrame);
          if curFrame mod FrameCount<>Frame then error:=8;
        end;
      end;
    end;
    if (error<>0) then terminate;

  until Terminated;
end;





{********************************** Méthodes STM ***************************}



procedure proTauxChannel_PhysNum(w:integer;pu:Pchannel);
begin
  with pu^ do
  begin
    if w<0 then sortieErreur('TauxChannel: invalid physical number');

    PhysNum:=w;
  end;
end;

function fonctionTauxChannel_PhysNum(pu:Pchannel):integer;
begin
  result:=pu^.PhysNum;
end;


function fonctionTauxChannel_Dy(pu:Pchannel):float;
begin
  with pu^ do
  begin
    if jru1<>jru2
    then result:=(Yru2-Yru1)/(jru2-jru1)
    else result:=1;
  end;
end;

function fonctionTauxChannel_y0(pu:Pchannel):float;
var
  dyB:float;
begin
  with pu^ do
  begin
    if jru1<>jru2
      then DyB:=(Yru2-Yru1)/(jru2-jru1)
      else DyB:=1;

    result:=Yru1-Jru1*DyB;
  end;
end;

procedure proTauxChannel_unitY(w:AnsiString;pu:Pchannel);
begin
  pu^.unitY:=w;
end;

function fonctionTauxChannel_unitY(pu:Pchannel):AnsiString;
begin
  result:=pu^.unitY;
end;

procedure proTauxChannel_setScale(j1,j2:integer;y1,y2:float;pu:Pchannel);
begin
  if (j1=j2) then sortieErreur('TauxChannel.setScale : invalid parameter' );

  with pu^ do
  begin
    jru1:=j1;
    jru2:=j2;
    Yru1:=y1;
    Yru2:=y2;
  end;
end;

procedure proTauxStimulator_Create(stname:AnsiString; var pu:typeUO);
begin
  SimMode:=false;
  NbAdapter:=0;
  createPgObject(stname,pu,TauxStimulator);
end;

procedure proTauxStimulator_Create_1( var pu:typeUO);
begin
  SimMode:=false;
  NbAdapter:=0;
  createPgObject('',pu,TauxStimulator);
end;

procedure proTauxStimulator_Create_2( Sim:boolean; Nadapter:integer; var pu:typeUO);
begin
  SimMode:=Sim;
  if Nadapter=2 then NbAdapter:=2 else NbAdapter:=1;

  createPgObject('',pu,TauxStimulator);
end;

procedure proTauxStimulator_FSwapAdapters(w:boolean;var pu:typeUO);
begin
  verifierObjet(pu);
  TauxStimulator(pu).setSwapMode(w);
end;

function fonctionTauxStimulator_FswapAdapters(var pu:typeUO):boolean;
begin
  verifierObjet(pu);
  result:=TauxStimulator(pu).FlagSwap;
end;



procedure proTauxStimulator_ChannelCount(w:integer;var pu:typeUO);
begin
end;

function fonctionTauxStimulator_ChannelCount(var pu:typeUO):integer;
begin
  verifierObjet(pu);
  result:=TauxStimulator(pu).MaxChCount;
end;

function fonctionTauxStimulator_Channels(n:integer;var pu:typeUO):pointer;
begin
  verifierObjet(pu);
  with TauxStimulator(pu) do
  begin
    if (n<1) or (n>MaxChCount)
      then sortieErreur('TauxStimulator.Channel : index out of range');
    result:=@Fchannel[n-1];
  end;
end;


function fonctionTauxStimulator_vector(num:integer;var pu:typeUO):Tvector;
begin
  verifierObjet(pu);
  with TauxStimulator(pu) do
  begin
    if (num<1) or (num>maxChCount)
      then sortieErreur('TauxStimulator.vector : index out of range');
    result:=@vecA[num-1];
  end;
end;


function fonctionTauxStimulator_EpDuration(var pu:typeUO):float;
begin
  verifierObjet(pu);
  result:=TauxStimulator(pu).EpDuration;
end;

procedure proTauxStimulator_EpDuration(w:float;var pu:typeUO);
begin
  verifierObjet(pu);
  if w<=0 then sortieErreur( 'TauxStimulator: EpDuration must be positive');
  TauxStimulator(pu).EpDuration:=w;
end;

function fonctionTauxStimulator_SamplingInt(var pu:typeUO):float;
begin
  verifierObjet(pu);
  result:=TauxStimulator(pu).SamplingInt ;
end;

procedure proTauxStimulator_SamplingInt(w:float;var pu:typeUO);
begin
  verifierObjet(pu);
  if (w<0.01) or (w>1) then sortieErreur( 'TauxStimulator: SamplingInt out of range');
  TauxStimulator(pu).SamplingInt:=w;
end;

function fonctionTauxStimulator_SamplesPerChannel(var pu:typeUO):integer;
begin
  verifierObjet(pu);
  result:=TauxStimulator(pu).PtsPerChannel ;
end;



procedure proTauxStimulator_InitVectors(var pu:typeUO);
begin
  verifierObjet(pu);
  TauxStimulator(pu).initVectors;
end;


procedure proTauxStimulator_Start(Ftrig:boolean;var pu:typeUO);
begin
  verifierObjet(pu);
  TauxStimulator(pu).start(Ftrig);
end;

procedure proTauxStimulator_Stop(var pu:typeUO);
begin
  verifierObjet(pu);
  TauxStimulator(pu).stop;
end;

function fonctionTauxStimulator_ExternalClock(var pu:typeUO):boolean;
begin
  verifierObjet(pu);
  result:=TauxStimulator(pu).FextClock;
end;

procedure proTauxStimulator_ExternalClock(w:boolean;var pu:typeUO);
begin
  verifierObjet(pu);
  TauxStimulator(pu).FextClock:=w;
end;

function fonctionTauxStimulator_Fcontinuous(var pu:typeUO):boolean;
begin
  verifierObjet(pu);
  result:= TauxStimulator(pu).Fcontinuous;
end;

procedure proTauxStimulator_Fcontinuous(w:boolean;var pu:typeUO);
begin
  verifierObjet(pu);
  TauxStimulator(pu).Fcontinuous:=w;
end;


procedure proTauxStimulator_buildEp(w:integer;var pu:typeUO);
begin
  verifierObjet(pu);
  TauxStimulator(pu).BuildEp.setAd(w);
end;

function fonctionTauxStimulator_buildEp(var pu:typeUO):integer;
begin
  verifierObjet(pu);
  result:=TauxStimulator(pu).BuildEp.Ad;
end;


procedure proTauxStimulator_Update(var pu:typeUO);
begin
  verifierObjet(pu);
  TauxStimulator(pu).Update;
end;

procedure proTauxStimulator_EpCount(w:integer;var pu:typeUO);
begin
  verifierObjet(pu);
  if (w<2) or (w>1000) then sortieErreur('TauxStimulator.EpCount : value out of range');
  TauxStimulator(pu).UserFrameCount:=w;
end;

function fonctionTauxStimulator_EpCount(var pu:typeUO):integer;
begin
  verifierObjet(pu);
  result:=TauxStimulator(pu).UserFrameCount;
end;

procedure proTauxStimulator_BuildNextEpisod(var pu:typeUO);
begin
  verifierObjet(pu);
  TauxStimulator(pu).BuildNextFrame;
end;



Initialization
AffDebug('Initialization stmAuxInt1',0);
registerObject(TauxStimulator,sys);

end.
