unit AcqInf2;

interface
{$IFDEF FPC} {$mode delphi} {$DEFINE AcqElphy2} {$A1} {$Z1} {$ENDIF}

uses forms,sysUtils,
     util1,varConf1, Gdos,
     stmdef,stmObj,
     AcqDef2,AcqBrd1, stmTCPIP1;


var
  TCPIPserver: TserverA;

{******************************** TacqInfo ***********************************}


type
  TinputType=(TI_analog,TI_anaEvent,TI_Digi8,TI_digi16,TI_digiBit,TI_digiEvent, TI_Neuron);

  String20=string[20];

  TchannelInfo=
     record
       unitY: string[10];
       jru1,jru2: smallint;
       yru1,yru2: single;
       Qdevice:byte;
       QvoieAcq:  byte;       { numéro de voie physique }
       Qgain:     byte;       { gain }
       EvtThreshold: single;
       QKS: word;             {down sampling factor}
       ChannelType: TinputType;
       EvtHysteresis: single;
       FRising: boolean;
       Dum1:smallint;
       CyberKunit:byte;       { Non utilisé }
       LogCh:smallint;
     end;
  PchannelInfo=^TchannelInfo;

  TacqRecInfo=record
    periodeCont:double;           { période en ms }
    DureeSeqU:double;             { Durée séquence en ms }
    DureePreTrigU:double;         { Duree pré trigger en ms }

    Qnbvoie:smallint;             { nombre de canaux (ADC ou DI }
    continu:boolean;

    ModeSynchro:TmodeSync;
    voieSynchro:smallint;         { numéro logique =voie d'acq ou
                                    voie d'acq= voie max+1 }
    seuilPlus,seuilMoins:single;  { seuils mode analog abs }
    IntervalTest:smallint;        { intervalle mode diff }

    Fdisplay:boolean;
    Fimmediate:boolean;
    Fcycled:boolean;
    Fhold:boolean;

    FFdat:boolean;
    FValidation:boolean;
    FEffaceTout:boolean;

    Fprocess:boolean;

    Qmoy:boolean;
    FFmoy:boolean;
    cadMoy:integer;

    IsiSec:single;
    Fstim:boolean;

    maxEpCount:integer;
    maxDuration:single;

    FileInfoSize:integer;
    EpInfoSize:integer;
    MiniCommentSize:integer;

    bid1:boolean;

    Bid2: single;

    RecSound:boolean;

    FControlPanel:boolean;
    FtriggerPos:boolean;
    WaitMode:boolean;

    DFformat:TdataFileFormat;
    CyberElecCount:word;
    CyberUnitCount:word;
    CyberWaveLen:word;    { nb de pts par waveform }
    PretrigWave:word;

    CyberUnitY: string[10];
    CyberJru1,CyberJru2: smallint;
    CyberYru1,CyberYru2: single;

    NIRisingSlope:boolean;
    AcqPhotons: byte;                     // 0 = None
                                          // 1 = carte NI
                                          // 2 = TCPIP
    DispPhotons: boolean;
    IPaddress: string20;
    TCPIPport: integer;
    TCPIPrawBuffer: boolean;
    TCPIPswapBytes: boolean;

    PCLnx,PCLny: integer;

  end;
  PacqRecInfo=^TacqRecInfo;



  TacqInfo=class(typeUO)
  private
    rec:TacqRecInfo;
    stim:pointer;
    oldAcqInfo:PacqRecord;

    (* les propriétés correspondantes pourraient être supprimées en modifiant les
       modules des cartes d'acquisition *)
    function getChunitY(n:integer):AnsiString;
    procedure setChunitY(n:integer;w:AnsiString);

    function getChjru1(n:integer):smallint;
    procedure setChjru1(n:integer;w:smallint);

    function getChjru2(n:integer):smallint;
    procedure setChjru2(n:integer;w:smallint);

    function getChYru1(n:integer):single;
    procedure setChYru1(n:integer;w:single);

    function getChYru2(n:integer):single;
    procedure setChYru2(n:integer;w:single);

    function getChQvoieAcq(n:integer):byte;
    procedure setChQvoieAcq(n:integer;w:byte);

    function getChQgain(n:integer):byte;
    procedure setChQgain(n:integer;w:byte);

    function getChEvtThreshold(n:integer):single;
    procedure setChEvtThreshold(n:integer;w:single);

    function getChQKS(n:integer):word;
    procedure setChQKS(n:integer;w:word);

    function getChChannelType(n:integer):TinputType;
    procedure setChChannelType(n:integer;w:TinputType);

    function getChEvtHysteresis(n:integer): single;
    procedure setChEvtHysteresis(n:integer;w:single);

    function getChFRising(n:integer):boolean;
    procedure setChFRising(n:integer;w:boolean);

    function getChDevice(n:integer):byte;
    procedure setChDevice(n:integer;w:byte);

    function getChNumType(n:integer):typetypeG;
    function getSampleSize(n:integer):integer;
    function getSampleOffset(n:integer):integer;



    procedure SetSeuilPlus(w:single);
    procedure SetSeuilMoins(w:single);

    procedure setNIRisingSlope(w:boolean);

    function getAcqPhotons:byte;
  public

    stGenAcq:AnsiString;
    stDat:AnsiString;
    stEvt:AnsiString;
    stGenHis:AnsiString;

    AcqComment:AnsiString;
    channels:array of TchannelInfo;
    NrnAcqName: array of AnsiString;
    NrnTagName:array[1..16] of AnsiString;

    property continu:boolean read rec.continu write rec.continu;
    property Qnbvoie:smallint read rec.Qnbvoie write rec.Qnbvoie;
    function Qnbpt:integer;

    property DureeSeqU:double read rec.DureeSeqU write rec.DureeSeqU;
    property DureePreTrigU:double read rec.DureePreTrigU write rec.DureePreTrigU;
    property periodeCont:double read rec.periodeCont write rec.periodeCont;

    property ModeSynchro:TmodeSync read rec.ModeSynchro write rec.ModeSynchro;
    property voieSynchro:smallint read rec.voieSynchro write rec.voieSynchro;
    property seuilPlus:single read rec.seuilPlus write SetSeuilPlus;
    property seuilMoins:single read rec.seuilMoins write SetSeuilMoins;

    property IntervalTest:smallint read rec.IntervalTest write rec.IntervalTest;

    property Fdisplay:boolean read rec.Fdisplay write rec.Fdisplay;
    property Fimmediate:boolean read rec.Fimmediate write rec.Fimmediate;
    property Fcycled:boolean read rec.Fcycled write rec.Fcycled;
    property Fhold:boolean read rec.Fhold write rec.Fhold;

    property FFdat:boolean read rec.FFdat write rec.FFdat;
    property FValidation:boolean read rec.FValidation write rec.FValidation;
    property FEffaceTout:boolean read rec.FEffaceTout write rec.FEffaceTout;

    property Fprocess:boolean read rec.Fprocess write rec.Fprocess;

    property Qmoy:boolean read rec.Qmoy write rec.Qmoy;
    property FFmoy:boolean read rec.FFmoy write rec.FFmoy;
    property cadMoy:integer read rec.cadMoy write rec.cadMoy;

    property IsiSec:single read rec.IsiSec write rec.IsiSec;
    property Fstim:boolean read rec.Fstim write rec.Fstim;

    property maxEpCount:integer read rec.maxEpCount write rec.maxEpCount;
    property maxDuration:single read rec.maxDuration write rec.maxDuration;

    property FileInfoSize:integer read rec.FileInfoSize write rec.FileInfoSize;
    property EpInfoSize:integer read rec.EpInfoSize write rec.EpInfoSize;
    property MiniCommentSize:integer read rec.MiniCommentSize write rec.MiniCommentSize;

    property RecSound:boolean read rec.RecSound write rec.RecSound;

    property FControlPanel:boolean read rec.FControlPanel write rec.FControlPanel;
    property FtriggerPos:boolean read rec.FtriggerPos write rec.FtriggerPos;
    property WaitMode:boolean read rec.WaitMode write rec.WaitMode;

    property DFformat:TdataFileFormat read rec.DFformat write rec.DFformat;

    property NIRisingSlope:boolean read rec.NIRisingSlope write setNIRisingSlope;


    (* Propriétés provisoires *)
    Property unitY[n:integer]:AnsiString read getChUnitY write setChUnitY;
    Property jru1[n:integer]: smallint read getChjru1 write setChjru1;
    Property jru2[n:integer]: smallint read getChjru2 write setChjru2;
    Property yru1[n:integer]: single read getChyru1 write setChyru1;
    Property yru2[n:integer]: single read getChyru2 write setChyru2;
    Property QvoieAcq[n:integer]:  byte read getChQvoieAcq write setChQvoieAcq;
    Property Qgain[n:integer]: byte read getChQgain    write setChQgain   ;
    Property EvtThreshold[n:integer]: single read getChEvtThreshold write setChEvtThreshold;
    Property QKS[n:integer]: word read getChQKS write setChQKS;
    Property ChannelType[n:integer]: TinputType read getChChannelType write setChChannelType;
    Property EvtHysteresis[n:integer]: single read getChEvtHysteresis write setChEvtHysteresis;
    Property FRising[n:integer]: boolean read getChFRising write setChFRising;
    Property ChannelDev[n:integer]: byte read getChDevice write setChDevice;
    Property ChannelNumType[n:integer]: typetypeG read getChNumType;
    Property SampleSize[n:integer]:integer read getSampleSize;
    Property SampleOffset[n:integer]:integer read getSampleOffset;
    function AgTotSize:integer;

    Property CyberElecCount:word read rec.CyberElecCount write rec.CyberElecCount;
    Property CyberUnitCount:word read rec.CyberUnitCount write rec.CyberUnitCount;
    Property CyberWaveLen:word read rec.CyberWaveLen write rec.CyberWaveLen;
    Property PretrigWave:word read rec.PretrigWave write rec.PretrigWave;

    Property AcqPhotons: byte read getAcqPhotons write rec.AcqPhotons;
    Property DispPhotons: boolean read rec.DispPhotons write rec.DispPhotons;
    Property IPaddress: string20 read rec.IPaddress write rec.IPaddress;
    Property TCPIPport: integer read rec.TCPIPport write rec.TCPIPport;
    Property TCPIPrawBuffer: boolean read rec.TCPIPrawBuffer write rec.TCPIPrawBuffer;
    Property TCPIPswapBytes: boolean read rec.TCPIPswapBytes write rec.TCPIPswapBytes;

    Property PCLnx: integer read rec.PCLnx write rec.PCLnx;
    Property PCLny: integer read rec.PCLny write rec.PCLny;


    function getRecInfo:PAcqrecInfo;

    constructor create;override;
    procedure initvar;

    procedure InitADCchannel(n:integer);

    class function STMClassName:AnsiString;override;

    procedure setSizes(conf:TblocConf);
    procedure BuildInfo(var conf:TblocConf;lecture,tout:boolean);override;
    procedure completeLoadInfo;override;
    procedure resetAll;override;
    procedure InitStimInfo(p:pointer);


    function nbADC:integer;
    function nbDigi:integer;
    function nbNrn:integer;

    function dureeSeq:float;
    function dureeSeqApres:float;

    function periodeParVoie:float;    { période  par voie en ms ou secondes}
    function periodeParVoieMS:float;  { période  par voie en ms }

    function periodeUS:float;         { période globale en microsecondes
                                        vaut PeriodeParVoieMS/nbVoieAcq   }

    function PeriodOutOfRAnge:boolean;


    function nbVoieAcq:integer;       { nb voie rangées dans mainBuf ou MultiMainBuf}
    function nbVoieEvt:integer;       { nombre de voies Evt, voies analogiques transformées en Evt uniquement}
    function nbVoieSpk:integer;       { nombre de voies CyberSpk }


    function Dxu:float;
    function x0u:float;
    function Dyu(v:integer):float;
    function y0u(v:integer):float;
    function unitX:AnsiString;

    function DxuSpk:float;
    function X0uSpk:float;
    function UnitXSpk:AnsiString;

    function DyuSpk:float;
    function Y0uSpk:float;

    function UnitYSpk:AnsiString;
    procedure setCyberScale(j1,j2: integer;y1,y2:float);

    function Xend:float;
    function maxPts:integer;

    function IsiPts:integer;

    function getSeuilPlusPts:integer;
    function getSeuilMoinsPts:integer;
    procedure setSeuilPlusPts(n:integer);
    procedure setSeuilMoinsPts(n:integer);

    property SeuilPlusPts:integer read getSeuilPlusPts write setSeuilPlusPts;
    property SeuilMoinsPts:integer read getSeuilMoinsPts write setSeuilMoinsPts;


    function QnbAv:integer;
    function Qnbpt1:integer;

    procedure initEvtParams;

    procedure controle;
    function getInfo:AnsiString;override;

    function MaxAdcSamples:integer;
    function immediateDisplay:boolean;

    function verifierGen:boolean;

    procedure OldToNew(old: PacqRecord);

    function maxADC:integer;
    function maxDigiPort:integer;
    function maxDigiBits:integer;

    procedure assign(p:TacqInfo);

    function HasDigEvent:boolean;

    procedure InstallTCPIPServer;
    destructor destroy;override;
  end;

function AcqInf:TacqInfo;
function AcqInfF:TacqInfo;


implementation

uses acqCom1,StimInf2, RTneuronBrd, recorder1, cyberKbrd1, NIbrd1;

{************************* Méthodes de TacqInfo **************************}

constructor TacqInfo.create;
begin
  inherited;

  initvar;
end;

procedure TacqInfo.initvar;
var
  i:integer;
begin
  continu:=true;
  Qnbvoie:=1;

  DureeSeqU:=1000;
  periodeCont:=1;

  ModeSynchro:=MSinterne;
  voieSynchro:=1;
  seuilPlus:=0;
  seuilMoins:=0;
  IntervalTest:=2;

  rec.Fdisplay:=true;
  rec.Fimmediate:=true;

  initAdcChannel(16);

  IsiSec:=1;
  Fstim:=false;

  CyberWaveLen:=64;
  PreTrigWave:=16;

  rec.CyberJru1:=0;
  rec.CyberJru2:=32767;
  rec.CyberYru1:=0;
  rec.CyberYru2:=100;
  rec.CyberUnitY:='mV';

  IPaddress:='';
  TCPIPport:=50195;
  TCPIPrawBuffer:=true;
  TCPIPswapBytes:=true;

  stGenAcq:=extractFilePath(application.ExeName)+'DATA';

  rec.DFformat:= ElphyFormat1;
end;

procedure TacqInfo.InitAdcChannel(n:integer);
var
  i:integer;
  n1:integer;
begin
  n1:=length(channels);
  if (n>n1) then setLength(channels,n);

  for i:=n1 to n-1 do
  with channels[i] do
  begin
    unitY:='mV';
    jru1:=0;
    jru2:=32767;
    yru1:=0;
    yru2:=10000;
    QvoieAcq:=(i-1) mod 16;
    Qgain:=1;
    QKS:=1;

    EvtThreshold:=0;
    EvtHysteresis:=0;
    ChannelType:=TI_analog;

    Frising:=true;
    LogCh:=i+1;
  end;

  if n>n1 then setLength(NrnAcqName,n);
end;

class function TacqInfo.STMClassName:AnsiString;
begin
  result:='B_Acq';
end;

procedure TacqInfo.setSizes(conf:TblocConf);
begin

end;

procedure TacqInfo.BuildInfo(var conf:TblocConf;lecture,tout:boolean);
var
  i,n:integer;
begin
  inherited;

  conf.setvarConf('rec1',rec,sizeof(rec),setSizes);      {rec changé en rec1 le 7 janvier 2004 }

  conf.setStringConf('stgenAcq',stGenAcq);
  conf.setStringConf('stdat',stdat);
  conf.setStringConf('stGenHis',stdat);

  if lecture then
  begin
    n:=length(channels);
    initAdcChannel(MaxADC0);
  end;
  for i:=0 to High(Channels) do
    conf.setvarConf('Chan'+Istr(i+1),channels[i],sizeof(channels[i]));

  for i:=0 to High(NrnAcqName) do
    conf.SetStringConf('NrnAcqName'+Istr(i+1), NrnAcqName[i] );

  for i:=1 to High(NrnTagName) do
    conf.SetStringConf('NrnTagName'+Istr(i), NrnTagName[i] );

  if assigned(board) then board.BuildInfo(conf,lecture);

  if lecture then
  begin
    new(OldAcqInfo);
    fillchar(oldAcqInfo^,sizeof(oldAcqInfo^),0);
    conf.setvarConf('Acq',oldAcqInfo^,sizeof(oldAcqInfo^));
  end;

  if lecture or (RTparamsSize>0) then
  begin
    conf.SetDynConf('RTparams',RTparams0,RTparamsSize);

  end;

end;

procedure TacqInfo.completeLoadInfo;
begin
  inherited;

  if oldAcqInfo^.Qnbvoie<>0 then OldToNew(oldAcqInfo);
  dispose(oldAcqInfo);
  oldAcqInfo:=nil;

  controle;
  if (RTparamsSize>0) and (RTparamsSize<sizeof(RTparams0^)) then
    begin
      reallocmem(RTparams0,sizeof(RTparams0^));
      fillchar(PtabOctet(RTparams0)^[RTparamsSize],sizeof(RTparams0^)-RTparamsSize,0);
      RTparamsSize:=sizeof(RTparams0^);
    end;
end;

procedure TacqInfo.resetAll;
var
  n:integer;
begin
  inherited;
  {est appelée dans NouvelleCfg après la mise en place du driver de la carte }
  n:=length(channels);
  initAdcChannel(MaxADC);

  if assigned(board) then board.installQKS;
  { Etait dans controle, mais il faut que channels soit en place pour appeler installQKS }

  InstallTCPIPServer;
end;


function TacqInfo.getChChannelType(n: integer): TinputType;
begin
  result:=channels[n-1].ChannelType;
end;

function TacqInfo.getChEvtHysteresis(n: integer): single;
begin
  result:=channels[n-1].EvtHysteresis;
end;

function TacqInfo.getChEvtThreshold(n: integer): single;
begin
  result:=channels[n-1].EvtThreshold;
end;

function TacqInfo.getChFRising(n: integer): boolean;
begin
  result:=channels[n-1].FRising;
end;

function TacqInfo.getChjru1(n: integer): smallint;
begin
  result:=channels[n-1].jru1;
end;

function TacqInfo.getChjru2(n: integer): smallint;
begin
  result:=channels[n-1].jru2;
end;

function TacqInfo.getChQgain(n: integer): byte;
begin
  result:=channels[n-1].Qgain;
end;

function TacqInfo.getChQKS(n: integer): word;
begin
  result:=channels[n-1].QKS;
end;

function TacqInfo.getChQvoieAcq(n: integer): byte;
begin
  result:=channels[n-1].QvoieAcq;
end;

function TacqInfo.getChunitY(n: integer): AnsiString;
begin
  result:=channels[n-1].unitY;
end;

function TacqInfo.getChYru1(n: integer): single;
begin
  result:=channels[n-1].Yru1;
end;

function TacqInfo.getChYru2(n: integer): single;
begin
  result:=channels[n-1].Yru2;
end;

function TacqInfo.getChDevice(n: integer): byte;
begin
  result:=channels[n-1].QDevice;
end;


procedure TacqInfo.setChChannelType(n: integer; w: TinputType);
begin
  channels[n-1].ChannelType:=w;
end;

procedure TacqInfo.setChEvtHysteresis(n: integer; w: single);
begin
  channels[n-1].EvtHysteresis:=w;
end;

procedure TacqInfo.setChEvtThreshold(n: integer; w: single);
begin
  channels[n-1].EvtThreshold:=w;
end;

procedure TacqInfo.setChFRising(n: integer; w: boolean);
begin
  channels[n-1].FRising:=w;
end;

procedure TacqInfo.setChjru1(n: integer; w: smallint);
begin
  channels[n-1].jru1:=w;
end;

procedure TacqInfo.setChjru2(n: integer; w: smallint);
begin
  channels[n-1].jru2:=w;
end;

procedure TacqInfo.setChQgain(n: integer; w: byte);
begin
  channels[n-1].Qgain:=w;
end;

procedure TacqInfo.setChQKS(n: integer; w: word);
begin
  channels[n-1].QKS:=w;
end;

procedure TacqInfo.setChQvoieAcq(n: integer; w: byte);
begin
  channels[n-1].QvoieAcq:=w;
end;

procedure TacqInfo.setChunitY(n: integer; w: AnsiString);
begin
  channels[n-1].unitY:=w;
end;

procedure TacqInfo.setChYru1(n: integer; w: single);
begin
  channels[n-1].Yru1:=w;
end;

procedure TacqInfo.setChYru2(n: integer; w: single);
begin
  channels[n-1].Yru2:=w;
end;

procedure TacqInfo.setChDevice(n: integer;w: byte);
begin
  channels[n-1].QDevice:=w;
end;

function TacqInfo.getChNumType(n: integer): typetypeG;
begin
  if n<=Qnbvoie then
  case channels[n-1].ChannelType of
    TI_analog,TI_anaEvent,TI_Digi8,TI_digi16,TI_digiBit,TI_digiEvent: result:=G_smallint;
    TI_Neuron: result:=G_single;
  end
  else result:=G_smallint;
end;

function TacqInfo.getSampleSize(n: integer): integer;
begin
  if n<=Qnbvoie then
  case channels[n-1].ChannelType of
    TI_analog,TI_anaEvent,TI_Digi8,TI_digi16,TI_digiBit,TI_digiEvent: result:=2;
    TI_Neuron: result:=4;
  end
  else result:=2; {voies tags}
end;

function TacqInfo.getSampleOffset(n:integer):integer;
var
  i:integer;
begin
  result:=0;
  for i:=1 to n-1 do
    result:=result+getSampleSize(i);
end;

function TacqInfo.AgTotSize:integer;
var
  i:integer;
begin
  result:=0;
  for i:=1 to nbVoieAcq do
    result:=result+SampleSize[i];
end;



function TacqInfo.getRecInfo: PAcqrecInfo;
begin
  result:=@rec;
end;

procedure TacqInfo.InitStimInfo(p:pointer);
begin
  stim:=p;
end;

function TacqInfo.nbVoieAcq:integer;
begin
  if assigned(board)
    then result:=board.nbVoieAcq(Qnbvoie)
    else result:=Qnbvoie;
end;

function TacqInfo.nbVoieEvt:integer;
var
  i:integer;
begin
  if DFformat=ElphyFormat1 then
    begin
      result:=0;
      for i:=1 to Qnbvoie do
        if Channels[i-1].ChannelType = TI_anaEvent then inc(result);
    end
  else result:=0;
end;

function TacqInfo.nbVoieSpk:integer;       { nombre de voies CyberSpk }
begin
  if assigned(board) and (Board is TcyberKinterface)
    then result:= CyberElecCount
    else result:=0;
end;


function TacqInfo.nbADC: integer;
var
  i:integer;
begin
  result:=0;
  for i:=0 to Qnbvoie-1 do
  with channels[i] do
  if channelType=ti_analog then inc(result);
end;

function TacqInfo.nbDigi: integer;
var
  i:integer;
begin
  result:=0;
  for i:=0 to Qnbvoie-1 do
  with channels[i] do
  if channelType=ti_digibit then inc(result);
end;

function TacqInfo.nbNrn: integer;
var
  i:integer;
begin
  result:=0;
  for i:=0 to Qnbvoie-1 do
  with channels[i] do
  if channelType=ti_Neuron then inc(result);
end;


function TacqInfo.DureeSeq:float;
begin
  result:=periodeParVoieMS*Qnbpt;
end;

function TacqInfo.DureeSeqApres:float;
var
  p:float;
begin
  result:=periodeParVoieMS*(Qnbpt-Qnbav);
end;


{Période globale en microsecondes}
function TacqInfo.periodeUS:float;
begin
  result:=periodeParVoieMS/nbvoieAcq*1000;
end;

{Période par voie en millisecondes
 C'est la référence pour toutes les durées. On propose periodeCont et
 la carte indique ce qu'elle peut faire.
 }
function TacqInfo.periodeParVoieMS:float;
var
  pIn,pOut:float;
begin
  if assigned(board) then
  begin
    board.GetPeriods(periodeCont,nbADC+nbvoieEvt,nbDigi,paramStim.nbDac,paramstim.nbDigi,pIn,pOut);
    result:=pIn;
  end
  else result:=1;
end;

{Période par voie en millisecondes ou secondes }
function TacqInfo.periodeParVoie:float;
begin
  result:=periodeParVoieMS;
  if continu then result:=result/1000;
end;


function TacqInfo.Qnbpt:integer;
begin
  if continu
    then result:=round(2000/periodeParVoieMS)
    else result:=round(dureeSeqU/periodeParVoieMS);
end;

function TacqInfo.QnbAv:integer;
begin
  result:=round(dureePreTrigU/periodeParVoieMS);
  if result>Qnbpt then result:=Qnbpt;
end;

function TacqInfo.PeriodOutOfRAnge:boolean;
begin
  result:=assigned(board) and (periodeUS<board.periodeMini);
end;

function TacqInfo.Dxu:float;
begin
  Dxu:=periodeParVoie;
end;

function TacqInfo.x0u:float;
begin
  x0u:=0;
end;

function TacqInfo.DxuSpk:float;
begin
  if assigned(board)
    then result:=board.DxuSpk
    else result:=0;

 // if continu then result:=result/1000;
end;

function TacqInfo.X0uSpk:float;
begin
  result:=0;
end;

function TacqInfo.UnitXSpk:AnsiString;
begin
  if assigned(board)
    then result:=board.UnitXSpk
    else result:='';
end;

function TacqInfo.DyuSpk:float;
begin
  with rec do
  if Cyberjru1<>Cyberjru2
    then result:=(CyberYru2-CyberYru1)/(Cyberjru2-Cyberjru1)
    else result:=1;
end;

function TacqInfo.Y0uSpk:float;
var
  dyB:float;
begin
  with rec do
  begin
    if Cyberjru1<>Cyberjru2
      then dyB:=(CyberYru2-CyberYru1)/(Cyberjru2-Cyberjru1)
      else dyB:=1;
    result:=cyberYru1-cyberJru1*DyB;
  end;
end;

function TacqInfo.UnitYSpk:AnsiString;
begin
  result:=rec.CyberUnitY;
end;

procedure TacqInfo.setCyberScale(j1,j2: integer;y1,y2:float);
begin
  if (j1<>j2) and (y1<>y2) then
  begin
    rec.Cyberjru2:=j1;
    rec.Cyberjru2:=j2;
    rec.CyberYru1:=y1;
    rec.CyberYru2:=y2;
  end;  
end;


function TacqInfo.Dyu(v:integer):float;
begin
  with channels[v-1] do
  if jru1<>jru2
    then result:=(Yru2-Yru1)/(jru2-jru1)
    else result:=1;


  if assigned(board) then
    result:=result*board.GcalibAdc(v);
end;

function TacqInfo.y0u(v:integer):float;
var
  dyB:float;
begin
  with channels[v-1] do
  begin
    if jru1<>jru2
      then dyB:=(Yru2-Yru1)/(jru2-jru1)
      else dyB:=1;

    result:=Yru1-Jru1*DyB;
  end;
  if assigned(board) then
    result:=result+DyB*board.OFFcalibAdc(v);
end;

function TacqInfo.unitX:AnsiString;
begin
  if continu
    then unitX:='sec'
    else unitX:='ms';
end;

function TacqInfo.Xend:float;
begin
  if continu
    then result:=1
    else result:=DureeSeq/Qnbpt*(Qnbpt-1);
end;

function TacqInfo.maxPts:integer;
begin
  if continu
    then result:=0
    else result:=Qnbpt;
end;


function TacqInfo.IsiPts:integer;
var
  w:float;
begin
  w:=periodeUS;
  if (w>0) and not continu and (modeSynchro in [MSinterne,MSimmediat])
    then result:=roundL(TstimInfo(stim).isi*1000000/w)
    else result:=1000000;
end;

function TacqInfo.getSeuilPlusPts:integer;
begin
  case modeSynchro of
    MSanalogAbs,MSanalogNI: result:=roundI((seuilPlus-Y0u(voieSynchro))/Dyu(voieSynchro));
    MSanalogDiff:result:=roundI(seuilPlus/Dyu(voieSynchro));
    else result:=0;
  end;
end;

procedure TacqInfo.setSeuilPlusPts(n:integer);
begin
  case modeSynchro of
    MSanalogAbs,MSanalogNI: seuilPlus:=n*Dyu(voieSynchro)+Y0u(voieSynchro);
    MSanalogDiff:seuilPlus:=n*Dyu(voieSynchro);
  end;

  seuilP:=n;
  if board.isWaitingTrig then board.relancer;
end;

function TacqInfo.getSeuilMoinsPts:integer;
begin
  case modeSynchro of
    MSanalogAbs,MSanalogNI: result:=roundI((seuilMoins-Y0u(voieSynchro))/Dyu(voieSynchro));
    MSanalogDiff:result:=roundI(seuilMoins/Dyu(voieSynchro));
    else result:=0;
  end;
end;

procedure TacqInfo.setSeuilMoinsPts(n:integer);
begin
  case modeSynchro of
    MSanalogAbs,MSanalogNI: seuilMoins:=n*Dyu(voieSynchro)+Y0u(voieSynchro);
    MSanalogDiff:seuilMoins:=n*Dyu(voieSynchro);
  end;

  seuilM:=n;
end;


function TacqInfo.Qnbpt1:integer;
begin
  if continu
    then result:=maxEntierLong
    else result:=Qnbpt*Qnbvoie;
end;


procedure TacqInfo.initEvtParams;
begin
end;



function TacqInfo.verifierGen:boolean;
var
  chemin,nom,num,ext:AnsiString;
  ok:boolean;
begin
  stGenAcq:=FsupespaceDebut(stGenAcq);
  stGenAcq:=FsupespaceFin(stGenAcq);

  stGenAcq:=Fmaj(stGenAcq);
  DecomposerNomFichier(stGenAcq,chemin,nom,num,ext);
  if nom='' then nom:='DATA'
  {else
  if nom[1]='$' then nom:=copy(nom,1,2)};
  stGenAcq:=chemin+nom;
  if (length(chemin)>0) and (chemin[length(chemin)]='\')
    then delete(chemin,length(chemin),1);
  ok:= repertoireExiste(chemin);

  result:=ok;
end;

procedure TacqInfo.controle;
var
  i:integer;
begin
   if (Qnbvoie<1) or (Qnbvoie>MaxADC0) then Qnbvoie:=1;

   if (DureePreTrigU<0) or (DureePreTrigU>DureeSeqU) then DureePreTrigU:=0;
   if DureeSeqU<0.001 then DureeSeqU:=1000;
   if periodeCont<0.001 then periodeCont:=1;

   if (ModeSynchro<low(TmodeSync)) or (ModeSynchro>high(TmodeSync))
     then ModeSynchro:=msInterne;
   if (voieSynchro<1) or (voieSynchro>128) then voieSynchro:=1;

   if (IntervalTest<1) or (IntervalTest>1000) then IntervalTest:=2;

   for i:=1 to Qnbvoie do
     with channels[i-1] do
     begin
       LogCh:=i;
       if (jru1=jru2) or (yru1=yru2) then
         begin
           jru1:=0;
           jru2:=2048;

           yru1:=0;
           yru2:=10000;
         end;


       if assigned(board) then
       begin
         {QvoieAcq:= board.ControleVoieAcq(QvoieAcq);}
         if (Qgain<1) or (Qgain>board.nbGain) then Qgain:=1;
         if board is TRTNIinterface then ChannelType:=TI_Neuron;
       end;
     end;


   if maxEpCount<0 then maxEpCount:=0;
   if maxDuration<0 then maxDuration:=0;

   if FileInfoSize<0 then FileInfoSize:=0;
   if EpInfoSize<0 then EpInfoSize:=0;

   if assigned(board) then
   begin
      if board.FixedPeriod then PeriodeCont:=board.getFixedPeriod;

      if board.ElphyFormatOnly then DFformat:=ElphyFormat1;


   end;
end;

function TacqInfo.getInfo:AnsiString;
var
  i:integer;
begin
  result:=
  'Continuous='+Bstr(continu)+CRLF+
  'Channel count='+Istr(Qnbvoie)+CRLF+
  'Samples per channel='+Istr(Qnbpt)+CRLF+
  'Samples before trigger='+Istr(Qnbav)+CRLF+
  'Episode duration='+Estr(DureeSeqU,3)+CRLF+
  'Period per channel='+Estr(periodeCont,3)+CRLF+
  'Trigger mode='+trigtype[ModeSynchro]+CRLF+
  'Sync. channel='+Istr(voieSynchro)+CRLF+
  'Upper threshold='+Estr(seuilPlus,3)+CRLF+
  'Lower threshold='+Estr(seuilMoins,3)+CRLF+
  'Test interval='+Istr(IntervalTest)+CRLF;

  for i:=1 to Qnbvoie do
    with channels[i-1] do
    begin
      result:=result+'Channel['+Istr(i)+']:'+crlf;
      result:=result+'   Scaling factors '
                   +Istr(jru1)+'('+Estr(yru1,3)+' '+unitY+')'+' '+
                    Istr(jru2)+'('+Estr(yru2,3)+' '+unitY+')'+CRLF;

      result:=result+'   Physical channel='+Istr(QvoieAcq) +CRLF;
      result:=result+'   Gain=' +Istr(Qgain)+' ';

    end;
end;

function TacqInfo.MaxAdcSamples:integer;
var
  AcqAg,maxEp:integer;
begin
  AcqAg:=Qnbvoie;

  if continu then
    begin
      if maxDuration<=0
        then result:=maxEntierLong
        else result:=roundL(maxDuration*1E6/periodeUS) div AcqAg*AcqAg-1;
    end
  else
    begin
      if maxEpCount<=0
        then maxEp:=maxEntierLong
        else maxEp:=maxEpCount;
      if MaxEp<>maxEntierLong
        then result:=maxEp*Qnbpt*nbvoieAcq-1
        else result:=maxEntierLong;
    end;
end;

function TacqInfo.immediateDisplay:boolean;
begin
  result:=Continu or Fimmediate and (dureeSeqU>200);
end;

procedure TacqInfo.OldToNew(old:PacqRecord);
var
  i:integer;
begin
  if not assigned(old) then exit;

  initvar;

  continu:=old.continu;
  Qnbvoie:=old.Qnbvoie;
  DureeSeqU:=old.DureeSeqU;
  periodeCont:=old.periodeCont;

  ModeSynchro:=old.ModeSynchro;
  voieSynchro:=old.voieSynchro;
  seuilPlus:=old.seuilPlus;
  IntervalTest:=old.IntervalTest;


  Fdisplay:=old.Fdisplay;
  Fimmediate:=old.Fimmediate;
  Fcycled:=old.Fcycled;
  Fhold:=old.Fhold;

  FFdat:=old.FFdat;
  FValidation:=old.FValidation;
  FEffaceTout:=old.FEffaceTout;

  Fprocess:=old.Fprocess;

  Qmoy:=old.Qmoy;
  FFmoy:=old.FFmoy;
  cadMoy:=old.cadMoy;

  IsiSec:=old.IsiSec;
  Fstim:=old.Fstim;

  maxEpCount:=old.maxEpCount;
  maxDuration:=old.maxDuration;

  FileInfoSize:=old.FileInfoSize;
  EpInfoSize:=old.EpInfoSize;
  MiniCommentSize:=old.MiniCommentSize;


  RecSound:=old.RecSound;

  FControlPanel:=old.FControlPanel;
  FtriggerPos:=old.FtriggerPos;
  WaitMode:=old.WaitMode;
  DFformat:=old.DFformat;

  if (Qnbvoie<=0) or (Qnbvoie>16) then exit;

  setLength(channels,nbvoieAcq);
  for i:=1 to nbvoieAcq do
  with channels[i-1] do
  begin
    QKS:=old.QKS[i];
    byte(ChannelType):=old.ChannelType[i];
    EvtHysteresis:=old.EvtHysteresis[i];
    FRising:=old.FRising[i];
    unitY:=old.unitY[i];
    jru1:=old.jru1[i];
    jru2:=old.jru2[i];

    yru1:=old.yru1[i];
    yru2:=old.yru2[i];

    QvoieAcq:=old.QvoieAcq[i];
    Qgain:=old.Qgain[i];
    EvtThreshold:=old.EvtThreshold[i];
  end;

end;


function TacqInfo.maxADC:integer;
var
  i:integer;
begin
  result:=0;
  if assigned(board) then
    for i:=0 to board.deviceCount-1 do
      result:=result+board.ADCCount(i);

  if result<16 then result:=16;
end;

function TacqInfo.maxDigiPort:integer;
var
  i:integer;
begin
  result:=0;
  if assigned(board) then
  for i:=0 to board.deviceCount-1 do
    result:=result+board.DigiINCount(i);
end;

function TacqInfo.maxDigiBits:integer;
var
  i:integer;
begin
  result:=0;
  if assigned(board) then
  for i:=0 to board.deviceCount-1 do
    if board.bitInCount(i)>result then result:=board.bitInCount(i);
end;




function AcqInf:TacqInfo;
begin
  result:=DacAcqInfo;
end;

function AcqInfF:TacqInfo;
begin
  result:=DacAcqInfo;
end;




procedure TacqInfo.assign(p: TacqInfo);
var
  i:integer;
begin
  rec:=p.rec;
  stim:=p.stim;

  stGenAcq:=p.stGenAcq;
  stDat:=p.stDat;
  stEvt:=p.stEvt;
  stGenHis:=p.stGenHis;

  AcqComment:=p.AcqComment;
  setLength(channels,length(p.channels)) ;
  move(p.channels[0],channels[0],sizeof(channels[0])*length(p.channels));

  setLength(NrnAcqName,length(p.NrnAcqName));
  for i:=0 to high(p.NrnAcqName) do
    NrnAcqName[i]:=p.NrnAcqName[i];

  for i:=1 to high(p.nrnTagName) do
    nrnTagName[i]:=p.nrnTagName[i];

end;


procedure TacqInfo.SetSeuilMoins(w: single);
begin
  rec.seuilMoins:=w;
  seuilM:=seuilMoinsPts;
  if assigned(AcqCommand) and AcqCommand.Visible then AcqCommand.UpdateThresholds;
end;

procedure TacqInfo.SetSeuilPlus(w: single);
begin
  rec.seuilPlus:=w;
  seuilP:=seuilPlusPts;
  if assigned(AcqCommand) and AcqCommand.Visible then AcqCommand.UpdateThresholds;
end;

procedure TacqInfo.setNIRisingSlope(w: boolean);
begin
  rec.NIRisingSlope:=w;
  if assigned(AcqCommand) and AcqCommand.Visible then AcqCommand.UpdateThresholds;
  if board.isWaitingTrig then board.relancer;
end;

function TacqInfo.HasDigEvent: boolean;
var
  i:integer;
begin
  result:=false;
  for i:=1 to Qnbvoie do
     if channelType[i]=TI_digiEvent then result:=true;

end;

function TacqInfo.getAcqPhotons:byte;
begin
  if board.CanAcqPhotons
    then result:= rec.AcqPhotons
    else result:=0;
end;

procedure TacqInfo.InstallTCPIPServer;
var
  NeedTCPIP:boolean;
begin
  NeedTCPIP:= assigned(board) and (AcqPhotons=2);

  if NeedTCPIP = assigned(TCPIPserver) then exit;

  if assigned(TCPIPserver) then
  begin
    TCPIPserver.Free;
    TCPIPserver:=nil;
  end;

  if NeedTCPIP then
  begin
    TCPIPserver:=TserverA.create;
    TCPIPserver.setup(IPaddress,TCPIPport,true,ord(TCPIPrawBuffer)*2); // mode buffer=0    mode RawBuffer=2
    // Quand ProcessBuffer est appelé à partir de mdac, les buffers sont détruits s'il n'y a pas de gestionnaire d'evt
    //if board is TNIboard then TCPIPserver.OnReceive:= TNIboard(board).onReceiveTCPIP;
  end;
end;

destructor TacqInfo.destroy;
begin
//  TCPIPserver.free;
//  TCPIPserver:=nil;
  inherited;

end;

end.
