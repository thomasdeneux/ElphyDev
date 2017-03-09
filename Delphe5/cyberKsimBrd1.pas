unit cyberKsimBrd1;

interface
{$IFDEF FPC} {$mode delphi} {$DEFINE AcqElphy2} {$A1} {$Z1} {$ENDIF}

uses windows,classes,
     util1,
     stmdef,AcqBrd1,stimInf2,
     acqCom1, AcqInterfaces,
     acqDef2,acqInf2,
     cyberK2, CyberKbrd1, debug0;


Const
  CyberSimModel:integer=2;

  MaxSpk=128;

type
  {On considère que les spikes sont les plus grand paquets. Ici 276 octets
   Si on alloue 20000 paquets, le buffer occupe environ 5 mégaoctets
   }
  TsimPacket= record
                time: UINT32;                // system clock timestamp
                chid: UINT16;                // channel identifier
                unit1: UINT8;                // unit identification
                dlen: UINT8;                // length of what follows
                case integer of
                1:(  fPattern: array[0..2] of single;
                     nPeak: INT16;
                     nValley: INT16;
                     wave: array[0..127] of INT16;     //   Spike waveform
                   );
                2:(  data: array[0..127] of INT16;     //   Analog data
                  );
                3:(  dataD:array[0..63] of UINT32;     //   Digital Data
                  );
                4:(  chan:smallint;value:smallint;     //   set digital Out
                  );
              end;

  PsimPacket=^TsimPacket;

  TCyberKSimInterface = class(TcyberKInterface)
  private
    CentralBuf:array of TsimPacket;
    CentralBufSize:integer;
    Pread,Pwrite:integer;

    SimSpkLength, SimSpkPretrig, SimSysfreq: longword;
    SimAinGroup:array[0..255] of byte;
    SimGroup:array[2..4] of array[0..255] of longword;
    SimNbG:array[2..4] of integer;

    Time0:longword;   // System time  when acquisition starts
    curTime:integer;  // current Time ( 0 when acquisition starts }

    SIMseqTime:integer;
    spks:array of array of array of Tlist;{   spks[ seq, chan, unit, index ] }
    spkIndex:array of array of integer;
    NumStim:integer;
    waveform:array[0..5,0..127] of smallint;

    DinState:longword;

    procedure InitCBfunctions;

    procedure CreateWave(n:integer;A,B:float);
    procedure InitSpikes;

    procedure MakeHeartBeatPacket(tt:integer);

    procedure MakeAnalogPacket1(tt:integer; gg:integer);
    procedure MakeAnalogPacket(tt:integer);

    procedure MakeSpkPacket1(tt:integer;ch,uu:integer);
    procedure MakeSpkPacket(tt:integer);

    procedure MakeDinPacket1(tt:integer; w:longword);
    procedure MakeDinPacket(tt:integer);
    procedure MakePackets;

    procedure CyberDelay(ms:integer);override;
    procedure freeSpikes;

  public
    constructor create(var st1:driverString);override;
    destructor destroy;override;

    procedure init;override;
    procedure lancer;override;
    procedure terminer;override;
  end;

procedure initCyberKsimBoards;

implementation

var
  brdSim:TCyberKSimInterface;

Const
  SIMseqDuration=5000*30;
  SIMseqISI=6000*30;

function SIMcbOpen: cbRESULT;cdecl;
begin
  result:=0;
end;

function SIMcbClose: cbRESULT;cdecl;
begin
  result:=0;
end;


function SIMcbMakePacketReadingBeginNow: cbRESULT; cdecl;
begin
  brdSim.Time0:=getTickCount;
  brdSim.Pread:=0;
  brdSim.Pwrite:=0;
  result:=0;
end;

function SIMcbGetSpikeLength( length: PUINT32;  pretrig: PUINT32;  pSysfreq: PUINT32): cbRESULT;cdecl;
begin
  length^:=brdSim.SimSpkLength;
  pretrig^:=brdSim.SimSpkPreTrig;
  psysFreq^:=brdSim.SimSysFreq;
  result:=0;
end;

function SIMcbSetSpikeLength( length: UINT32;  pretrig: UINT32): cbRESULT;cdecl;
begin
  brdSim.SimSpkLength:= length;
  brdSim.SimSpkPreTrig:=pretrig;

  result:=0;
end;

function SIMcbGetAinpSampling( chan: UINT32;  filter: PUINT32; group: PUINT32): cbRESULT;cdecl;
begin
  group^:=brdSim.SimAinGroup[chan mod 255];
  Result:=0;
end;

function SIMcbSetAinpSampling( chan: UINT32;  filter: UINT32;   group: UINT32): cbRESULT;cdecl;
begin
  brdSim.SimAinGroup[chan mod 255]:=group;
  Result:=0;
end;


function SIMcbGetSampleGroupList(  proc: UINT32;  group: UINT32; length: PUINT32;  list: PUINT32 ): cbRESULT;cdecl;
var
  i:integer;
begin
  with brdSim do
  begin
    fillchar(SimGroup[Group],sizeof(SimGroup[group]),0);
    SimNbg[group]:=0;;

    for i:=0 to 255 do
      if (SimAinGroup[i]=group) then
      begin
        SimGroup[group,SimNbg[group]]:=i;
        inc(SimNbg[group]);
      end;

    length^:=SimNbg[group];
    move(SimGroup[group,0],list^,SimNbg[group]*4);
  end;

  result:=0;
end;

function SIMcbSetDinpOptions(  chan: UINT32;  options: UINT32;  eopchar: UINT32 ): cbRESULT;cdecl;
begin
  result:=0;
end;

function SIMcbGetNextPacketPtr: PcbPKT_GENERIC;cdecl;
begin
  with brdSim do
  begin
    MakePackets;
    if Pread<Pwrite then
    begin
      result:=@CentralBuf[Pread mod CentralBufSize];
      inc(Pread);
    end
    else result:=nil;
  end;
end;


{ La seule utilisation est SetDout
  Comme Dout 4 est reliée Din 16 , on génère un message en conséquence
}
function SIMcbSendPacket(pPacket: pointer): cbRESULT;cdecl;
begin
  with brdSim do makeDinPacket1(curTime,DinState and $7FFF OR PsimPacket(pPacket)^.value and $8000);

end;


 { TCyberKSimInterface }

constructor TCyberKSimInterface.create(var st1: driverString);
begin
  inherited;

  SimSpklength:= 128;
  SimSpkPretrig:=16;
  SimSysfreq:=30000;

  FsimCyberK:=true;
end;

destructor TCyberKSimInterface.destroy;
begin
  freeSpikes;
  inherited;
end;

procedure TCyberKSimInterface.init;
begin
  brdSim:=self;
  InitcbFunctions;

  CentralBufSize:=20000;
  setLength(CentralBuf,CentralBufSize);
  Pread:=0;
  Pwrite:=0;

  SIMseqTime:=200*30;
  NumStim:=0;
  InitSpikes;

  inherited;

end;

procedure TCyberKSimInterface.InitCBfunctions;
begin
  FreeCyberKdll;

  cbOpen:= SIMcbOpen;
  cbClose:= SIMcbClose;
  cbMakePacketReadingBeginNow:= SIMcbMakePacketReadingBeginNow;
  cbGetSpikeLength:= SIMcbGetSpikeLength;

  cbSetSpikeLength:= SIMcbSetSpikeLength;
  cbGetAinpSampling:= SIMcbGetAinpSampling;
  cbSetAinpSampling:= SIMcbSetAinpSampling;
  cbGetSampleGroupList:= SIMcbGetSampleGroupList;
  cbSetDinpOptions:= SIMcbSetDinpOptions;
  cbGetNextPacketPtr:= SIMcbGetNextPacketPtr;

  cbSendPacket:=SIMcbSendPacket;
end;

procedure TCyberKSimInterface.lancer;
begin
  curTime:=-1;
  inherited;
end;

procedure TCyberKSimInterface.CreateWave(n:integer;A,B:float);
var
  i:integer;
  ss:array[0..127] of float;
  max:float;

function cvx(i:integer):float;
begin
  result:=(i-64)*10/64;
end;

begin
  max:=0;
  for i:=0 to 127 do
  begin
    ss[i]:=(A*cvx(i)+B)/(1+sqr(sqr(cvx(i))));
    if ss[i]>max then max:=ss[i];
  end;

  for i:=0 to 127 do
    waveForm[n,i]:=round(ss[i]/max*1000);
end;

function compare(Item1, Item2: Pointer): Integer;
begin
  if intG(item1)<intG(item2) then result:=-1
  else
  if intG(item1)=intG(item2) then result:=0
  else result:=1;
end;

procedure TCyberKSimInterface.InitSpikes;
var
  i,j,k,kk,ind,stim,tt1,ss:integer;
  tt0:float;
  shuffle:array[0..49] of integer;

  procedure addSpk(stm,ch,u,tt:integer);
  begin
    spks[stm,ch,u].Add(pointer(tt));
  end;

begin
  setlength(spkIndex,MaxSpk,6);
  for i:=0 to MaxSpk-1 do
  for j:=0 to 4 do
    spkIndex[i,j]:=0;

  if length(spks)>0 then exit;

  for i:=0 to 5 do createWave(i,10-3*i,-3+3*i);

  setlength(spks,10,MaxSpk,5);
  for i:=0 to 9 do                 { 10 stimuli }
  for j:=0 to MaxSpk-1 do          { 32 voies }
  for k:=0 to 4 do                 {  5 unités }
    spks[i,j,k]:=Tlist.create;


 case CyberSimModel of

   1: for stim:=0 to 9 do
      begin
        for i:=0 to 49 do shuffle[i]:=i;
        randseed:=stim;
        for i:=0 to 49 do
        begin
          j:=random(50);
          k:=shuffle[i];
          shuffle[i]:=shuffle[j];
          shuffle[j]:=k;
        end;

        randomize;

        for i:=0 to MaxSpk-1 do
        for j:=0 to 4 do
        begin
          for k:=0 to 49 do
          begin
            ss:=shuffle[k];
            tt1:=100*30*k;

            //for kk:=0 to 5 do
            case ss of
              0..9:    addSpk(stim,i,j, tt1+ (10+random(1))*30 );
              10..19:  addSpk(stim,i,j, tt1+ (20+random(1))*30 );
              20..29:  addSpk(stim,i,j, tt1+ (40+random(1))*30 );
              30..39:  addSpk(stim,i,j, tt1+ (60+random(1))*30 );
              40..49:  addSpk(stim,i,j, tt1+ (70+random(1))*30 );
            end;

            {if ss=1 then addSpk(stim,i,j, tt1+ 10*30 );}
          end;
        end;
      end;

   2: for stim:=0 to 9 do
      begin
        randseed:=stim;

        for i:=0 to MaxSpk-1 do
        for j:=0 to 4 do
        for k:=0 to 99 do
          addSpk(stim,i,j, random(50000*30) );
      end;
  end;

  for stim:=0 to 9 do
  for i:=0 to MaxSpk-1 do
  for j:=0 to 4 do
    spks[stim,i,j].Sort(compare);

end;


procedure TCyberKSimInterface.MakeHeartBeatPacket(tt:integer);
begin
  with CentralBuf[Pwrite mod CentralBufSize] do
  begin
    time:=tt;
    chid:=$8000;
    unit1:=0;
    dlen:=0;
  end;
  inc(Pwrite);
end;


var
  DataIndex:array[0..255] of integer;

function getData(PhysNum:integer):integer;
begin
  result:=round(100*sin(2*pi/95*DataIndex[PhysNum]));         // Period= 95 ms
  inc(DataIndex[physNum]);
end;

procedure TCyberKSimInterface.MakeAnalogPacket1(tt:integer; gg:integer);
var
  i:integer;
begin
  with CentralBuf[Pwrite mod CentralBufSize] do
  begin
    time:=tt;
    chid:=0;
    unit1:=gg;
    dlen:=SIMnbG[gg];
    for i:=0 to dlen-1 do data[i]:=getData(SIMgroup[gg,i]);
  end;
  inc(Pwrite);
end;

procedure TCyberKSimInterface.MakeAnalogPacket(tt:integer);
begin
  if (tt mod 30=0) and (SIMnbG[2]>0) then MakeAnalogPacket1(tt, 2);
  if (tt mod 15=0) and (SIMnbG[3]>0)  then MakeAnalogPacket1(tt, 3);
  if (tt mod 3=0) and (SIMnbG[4]>0)  then MakeAnalogPacket1(tt, 4);
end;

procedure TCyberKSimInterface.MakeSpkPacket1(tt:integer;ch,uu:integer);
var
  i:integer;
begin
  with CentralBuf[Pwrite mod CentralBufSize] do
  begin
    time:=tt;
    chid:=ch;
    unit1:=uu;

    move(waveform[uu],wave,SIMspkLength*2);
    for i:=0 to 127 do inc(wave[i],random(500)-250);
  end;
  inc(Pwrite);

end;

procedure TCyberKSimInterface.MakeSpkPacket(tt:integer);
var
  i,j,u,ts:integer;
begin
  ts:=tt-SImseqTime;
  for i:=0 to MaxSpk-1 do
  for u:=0 to 4 do
  if (SpkIndex[i,u]<Spks[NumStim,i,u].Count) and (ts>= intG(Spks[NumStim,i,u][SpkIndex[i,u]])) then
  begin
    MakeSpkPacket1(tt,i+1,u);
    inc(SpkIndex[i,u]);
  end;

  if ts>SIMseqDuration then
  begin
    SIMseqTime:=SIMseqTime+SIMseqISI;
    for i:=0 to high(SpkIndex) do
    for j:=0 to high(SpkIndex[i]) do
      spkIndex[i,j]:=0;

    NumStim:= (NumStim+1) mod 10;
  end;

end;

procedure TCyberKSimInterface.MakeDinPacket1(tt:integer; w:longword);
begin
  with CentralBuf[Pwrite mod CentralBufSize] do
  begin
    time:=tt;
    chid:=151;
    unit1:=0;
    dlen:=1;
    dataD[0]:=w;
    DinState:=w;
  end;
  inc(Pwrite);
end;

procedure TCyberKSimInterface.MakeDinPacket(tt:integer);
var
  tt1:integer;
Const
  tops:integer=0;
  maxTops=200;
begin
  {
  if (tt=SIMseqTime) then MakeDinPacket1(tt,1)
  else
  if (tt=SIMseqTime+SIMseqDuration-1) then MakeDinPacket1(tt,0);
  }
  {
  if (tt>=SIMseqTime) and (tt<SIMseqTime+SIMseqDuration) then
  begin
    tt1:=(tt-SIMseqTime) mod (13*30);
    if tt1=0 then MakeDinPacket1(tt,3)
    else
    if tt1=30 then MakeDinPacket1(tt,0);
  end;
  }


  tt1:= tt mod (500);                          { 8.333*2*30 = 500           }
  if tt1=0 then
  begin
    if (tt mod(12000*30) =0) then
    begin
      tops:=0;
      MakeDinPacket1(tt,3);
    end
    else
    if (tt mod (12000*30)>=1000*30) and (tops<maxTops )  then
    begin
      MakeDinPacket1(tt,3);
      inc(tops);
    end
    else MakeDinPacket1(tt,2);
  end
  else
  if (tt1=3) then MakeDinPacket1(tt,0);

end;

procedure TCyberKSimInterface.MakePackets;
var
  tt:integer;
  i:integer;
begin
  tt:=(getTickCount - time0) * 30;

  for i:=curTime+1 to tt do
  begin
    MakeAnalogPacket(i);
    MakeSpkPacket(i);
    MakeDinPacket(i);

    if i mod 300=0 then MakeHeartBeatPacket(i);
  end;
  curTime:=tt;
end;

procedure TCyberKSimInterface.terminer;
begin
  inherited;

end;

procedure TCyberKSimInterface.CyberDelay(ms: integer);
begin
  Delay(ms);
  MakePackets;
end;


procedure TCyberKSimInterface.freeSpikes;
var
  i,j,k:integer;
begin
  for i:=0 to high(spks) do
  for j:=0 to high(spks[i]) do
  for k:=0 to high(spks[i,j]) do
    spks[i,j,k].Free;
end;



procedure initCyberKsimBoards;
begin
  { On installe la version SIM quand la version normale est installée }

  if FlagCYberKexists then  registerBoard('CyberK SIM',pointer(TCyberKsimInterface));
end;




end.
