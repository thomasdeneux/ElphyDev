unit StimInf2;

interface
{$IFDEF FPC} {$mode delphi} {$DEFINE AcqElphy2} {$A1} {$Z1} {$ENDIF}

uses  graphics,sysutils,classes,
      util1,varconf1,NcDef2,Dtrace1,dtf0,
      stmDef,stmObj,
      stmPG,
      AcqDef2,AcqInf2,stmvec1,AcqBrd1,
      debug0;


{******************************** TstimInfo **********************************}

{ TstimInfo gère les buffers de sortie pendant l'acquisition/stimulation.

 le buffer est déclaré Fbuffer: array of array of smallint
 Fbuffer[n] correspond au canal n (numérique ou analogique) (n de 0 à nbBuf-1)
            et contient StoredEp épisodes de taille EpSize

 Buffer[logch,numEp] est une propriété qui permet de manipuler Fbuffer en utilisant
 le numéro logique et le numéro d'épisode.

 février 2006 : on n'appelle plus initStimbuffers sinon
                  - avant une acquisition
                  - dans initvectors



}




const
  minPossibleChannels=8;
  maxPossibleChannels=64;

type
  typeSegmentAna=record
                   mode:byte;
                   duree,amp,incAmp,incDuree,Vinit,Vfinale:single;
                   rep1,rep2:word;
                 end;

  typeSegmentDigi=
                record
                  date,duree,incDate,incDuree:single;
                  rep1,rep2:word;
                end;

  typeTrain=    record
                  largeurPulse,cadencePulse,cadenceSalve:single;
                  NbSalve, NbPulse:integer;
                  DelaiTrain: single;
                end;

  TautoFillInfo=record
                  Ana:  array[1..20] of typeSegmentAna;
                  pulse: array[1..20] of typeSegmentDigi;
                  train: typeTrain;
                  FillMode:byte;
                  PulseAmp:single;
                end;
  PautoFillInfo = ^TautoFillInfo;

  typeOutput=   record
                  Device,PhysNum:byte;
                  tpOut:ToutputType;
                  BitNum:byte;

                  Jru1,Jru2:integer;
                  Yru1,Yru2:single;
                  unitY:string[10];

                  color: integer;
                  Ymin,Ymax:single;
                  readOnly:boolean;
                  buildEp: Tpg2Event;
                  BufferNum: integer;           {commence à 0 }
                  logch0:byte;

                end;
  Poutput= ^typeOutPut;

  TFbuffer= array of array of smallint;

  TFbuffer1= array of array of single;

  TFbufferInfo= record
                  Device,PhysNum:byte;
                  IsDigi:boolean;
                end;



  TstimInfo=    class(typeUO)
                private
                  acqInfo:TacqInfo;         { pointeur sur AcqInfo }

                  oldStimInfo1:PparamStimOld;
                  oldStimInfo2:PparamStim;

                  Fchannel:array of typeOutput;
                  FNrnName:array of AnsiString;
                  Fbuffer: TFbuffer;       { Fbuffer[NumBuffer,i] }

                  RTmode:boolean;
                  Fbuffer1:TFbuffer1;

                  FAutoFillInfo:array of TautoFillInfo;

                  FstoredEp:integer;        { Dimensions de Fbuffer = nbBuf*storedEp*EpSize }
                  FEPsize:integer;          { taille épisode en points }
                  FnbBuf:integer;

                  StoredSamples:integer;    { StoredSamples = nbBufStoredEp*EpSize }
                  oldStimCount:integer;

                  XnumSeq:integer;          { Valeurs utilisées à l'exécution commence à 1 }
                  Xnbpt1:integer;
                  XActiveChannels:integer;
                  Xana,Xdigi,Xnrn:integer;

                  vecA:array of Tvector;    { Un vecteur pour chaque canal logique }

                  ReadOnly:boolean;
                  maxChanR:integer;

                  { logCh et NumEp commencent à 1 }
                  { PhysNum commence à 0 }
                  procedure outPutDefault(var p:typeOutPut;LogNum:integer);
                  function getchannel(logCh:integer):PoutPut;
                  function getAutoFillInfo(logCh:integer):PautoFillInfo;
                  function getNrnName(logCh:integer):Pansistring;

                  function getBuffer(logCh,NumEp:integer):PtabEntier;
                  function getBuffer1(logCh,NumEp:integer):PtabSingle;

                  procedure initVectors;
                  procedure freeVectors;
                  procedure AdjustVector(logCh,NumEp:integer;fillZero:boolean);

                  procedure FillAnaSegs(num,seq:integer);
                  procedure FillDigiPulses(num,seq:integer);
                  procedure FillDigiTrain(num,seq:integer);

                  function getBufferInfo(n:integer):Poutput;

                  procedure onReadChCount(conf:TBlocConf);
                  procedure onReadMaxChanR(conf:TBlocConf);
                  function getvector(logCh:integer):Tvector;
                public

                  AlwaysUpdateBuffers:boolean;
                  bufferCountU:integer;
                  bufferSizeU:integer;
                  currentBufferU:integer;

                  channelCount:integer; {nombre de canaux logiques}

                  SetByProgU:boolean;

                  AnaDisplayed:boolean;
                  DigiDisplayed:boolean;
                  Xmin,Xmax:single;

                  DigiMask:array[0..15] of word;
                  DacMask:array[0..15] of word;

                  property Channel[i:integer]:PoutPut read getChannel;
                      { Canal logique 1 à channelCount}
                  property AutoFillInfo[i:integer]:PautoFillInfo read getAutoFillInfo;
                      { Canal logique 1 à channelCount}

                  property NrnName[logCh:integer]:Pansistring read getNrnName;

                  property Buffer[logch,numEp:integer]:PtabEntier read getBuffer;
                      { Adresse d'un buffer: logCh de 1 à ChannelCount
                                             numEp de 1 à l'infini (prend le modulo StoredEp) }

                  property Buffer1[logch,numEp:integer]:PtabSingle read getBuffer1;
                      { Adresse d'un buffer: logCh de 1 à ChannelCount
                                             numEp de 1 à l'infini (prend le modulo StoredEp) }


                  property BufferInfo[BufNum:integer]:Poutput read getBufferInfo;

                  property EpSize:integer read FepSize;
                  property StoredEp:integer read FstoredEp;

                  property Buffers: TFbuffer read Fbuffer;
                  property Buffers1: TFbuffer1 read Fbuffer1;


                  constructor create;override;
                  destructor destroy;override;
                  class function STMClassName:AnsiString;override;
                  procedure BuildInfo(var conf:TblocConf;lecture,tout:boolean);override;
                  procedure completeLoadInfo;override;
                  procedure resetAll;override;
                  procedure saveToStream( f:Tstream;Fdata:boolean);override;
                  function  loadFromStream(f:Tstream;size:LongWord;Fdata:boolean):boolean;override;


                  procedure InitChannelMax(nb:integer);
                  procedure InitAcqInfo(p:TacqInfo);

                  { Nombre de canaux physiques utilisés = nbDac + nbDigi + nbNrn , c'est aussi le nb de buffers }
                  property ActiveChannels:integer read XactiveChannels;
                  property nbDac:integer read Xana;          { Nombre de Dac }
                  property nbDigi:integer read Xdigi;        { Nombre de canaux Digi , 1 canal digi = 1 port 16 bits}
                  property nbNRN:integer read Xnrn;          { Nombre de canaux Nrn }

                  function nbpt:integer;
                  function nbpt1:integer;


                  function periodeParDac:float;  {période par DAC en ms}

                  function Isi:float;
                  function IsiPts:integer;

                  function stimDuration:float;

                  function maxChan:integer;


                  procedure OldToNew(var old: TparamStimOld);
                  procedure Old2ToNew(var old: TparamStim);
                  procedure controle;

                  procedure initStimBuffers(Fmini:boolean);
                  procedure FreeStimBuffers;

                  procedure initOutPutValues;
                  procedure setOutPutValues(cnt:integer);

                  procedure install;
                  procedure reset;

                  function Dyu(v:integer):float;
                  function y0u(v:integer):float;
                  function dxu:float;
                  function x0u:float;
                  function unitX:AnsiString;

                  procedure setChildNames;override;

                  property vector[logCh:integer]:Tvector read  getVector;
                  procedure BuildMenuStim(seq:integer);
                  procedure BuildPgStim(seq:integer);
                  procedure BuildStim(seq:integer);
                  procedure RefreshVectors;

                  property setByProgP:boolean read setByProgU write setByProgU;
                  procedure setRTmode;
               end;



function ParamStim:TstimInfo;

procedure proTstimChannel_Device(w:integer;pu:PoutPut);pascal;
function fonctionTstimChannel_Device(pu:PoutPut):integer;pascal;

procedure proTstimChannel_PhysNum(w:integer;pu:PoutPut);pascal;
function fonctionTstimChannel_PhysNum(pu:PoutPut):integer;pascal;

procedure proTstimChannel_ChannelType(w:integer;pu:PoutPut);pascal;
function fonctionTstimChannel_ChannelType(pu:PoutPut):integer;pascal;

procedure proTstimChannel_BitNum(w:integer;pu:PoutPut);pascal;
function fonctionTstimChannel_BitNum(pu:PoutPut):integer;pascal;

function fonctionTstimChannel_Dy(pu:PoutPut):float;pascal;
function fonctionTstimChannel_y0(pu:PoutPut):float;pascal;

procedure proTstimChannel_unitY(w:AnsiString;pu:PoutPut);pascal;
function fonctionTstimChannel_unitY(pu:PoutPut):AnsiString;pascal;

procedure proTstimChannel_setScale(j1,j2:integer;y1,y2:float;pu:PoutPut);pascal;

procedure proTstimChannel_buildEp(w:integer;pu:PoutPut);pascal;
function fonctionTstimChannel_buildEp(pu:PoutPut):integer;pascal;

procedure proTstimChannel_NrnSymbolName(w:AnsiString;pu:PoutPut);pascal;
function fonctionTstimChannel_NrnSymbolName(pu:PoutPut):AnsiString;pascal;


procedure proTstimulator_BufferCount(w:integer;var pu:typeUO);pascal;
function fonctionTstimulator_BufferCount(var pu:typeUO):integer;pascal;

procedure proTstimulator_BufferSize(w:integer;var pu:typeUO);pascal;
function fonctionTstimulator_BufferSize(var pu:typeUO):integer;pascal;


procedure proTstimulator_CurrentBuffer(w:integer;var pu:typeUO);pascal;
function fonctionTstimulator_CurrentBuffer(var pu:typeUO):integer;pascal;


function fonctionTstimulator_vector(num:integer;var pu:typeUO):Tvector;pascal;

function fonctionTstimulator_setValue(Device,tpOut,physNum,value:integer;var pu:typeUO):boolean;pascal;
function fonctionTstimulator_getValue(Device,tpIn,physNum:integer;var value:smallint;var pu:typeUO):boolean;pascal;

procedure proTstimulator_ChannelCount(w:integer;var pu:typeUO);pascal;
function fonctionTstimulator_ChannelCount(var pu:typeUO):integer;pascal;

function fonctionTstimulator_Channels(n:integer;var pu:typeUO):pointer;pascal;

procedure proTstimulator_initVectors(var pu:typeUO);pascal;

procedure proTstimulator_SetByProg(w:boolean;var pu:typeUO);pascal;
function fonctionTstimulator_SetByProg(var pu:typeUO):boolean;pascal;

procedure proTstimulator_AlwaysUpdateBuffers(w:boolean;var pu:typeUO);pascal;
function fonctionTstimulator_AlwaysUpdateBuffers(var pu:typeUO):boolean;pascal;


implementation

uses RTneuronBrd;


{************************* Méthodes de TstimInfo *************************}

constructor TstimInfo.create;
begin
  inherited;
  initChannelMax(16);
  SetRTmode;
end;

destructor TstimInfo.destroy;
begin
  freeVectors;
  FreeStimBuffers;
  inherited;
end;

class function TstimInfo.STMClassName:AnsiString;
begin
  result:='B_Stim';
end;


procedure TstimInfo.onReadChCount(conf: TBlocConf);
begin
  if channelCount<0 then channelCount:=0;
  if channelCount>maxChanR then channelCount:=maxChanR;
end;

procedure TstimInfo.onReadMaxChanR(conf: TBlocConf);
begin
  if maxChanR<minPossibleChannels then maxChanR:=minPossibleChannels;
  if maxChanR>maxPossibleChannels then maxChanR:=maxPossibleChannels;
end;


procedure TstimInfo.BuildInfo(var conf:TblocConf;lecture,tout:boolean);
var
  i,j:integer;
  n:integer;
begin
  inherited;

  conf.setvarConf('MaxChan',MaxChanR,sizeof(MaxChanR),onReadMaxChanR);
  conf.setvarConf('ChCount',channelCount,sizeof(channelCount),onReadChCount);
  conf.setvarConf('BufferCount',BufferCountU,sizeof(BufferCountU));
  conf.setvarConf('BufferSize',BufferSizeU,sizeof(BufferSizeU));
  conf.setvarConf('AlwaysUpdate',AlwaysUpdateBuffers,sizeof(AlwaysUpdateBuffers));

  for i:=0 to High(FChannel) do
    conf.setvarConf('Chan'+Istr(i+1),Fchannel[i],sizeof(Fchannel[i]));

  for i:=0 to High(FautoFillInfo) do
    conf.setvarConf('AutoFill'+Istr(i+1),FautoFillInfo[i],sizeof(FautoFillInfo[i]));

  for i:=0 to High(FNrnName) do
    conf.SetStringConf('NrnName'+Istr(i+1), FNrnName[i] );


  if lecture then
  begin
    new(OldStimInfo1);
    fillchar(oldStimInfo1^,sizeof(OldStimInfo1^),0);
    conf.setvarConf('Stim',oldStimInfo1^,sizeof(OldStimInfo1^));

    new(OldStimInfo2);
    fillchar(oldStimInfo2^,sizeof(OldStimInfo2^),0);
    conf.setvarConf('ElphyStim',oldStimInfo2^,sizeof(oldStimInfo2^));
  end;
end;

procedure TstimInfo.completeLoadInfo;
var
  i:integer;
begin
  inherited;
  
  if oldStimInfo1^.id<>'' then OldToNew(oldStimInfo1^);
  dispose(oldStimInfo1);
  oldStimInfo1:=nil;

  if oldStimInfo2^.id<>'' then Old2ToNew(oldStimInfo2^);
  dispose(oldStimInfo2);
  oldStimInfo2:=nil;

  for i:=0 to high(Fchannel) do Fchannel[i].logch0:=i+1;

  controle;
end;

procedure TstimInfo.resetAll;
begin
  inherited;
  {est appelée dans NouvelleCfg après la mise en place du driver de la carte }
  //initChannelMax;
  {initStimBuffers(true);}
end;

procedure TstimInfo.InitAcqInfo(p:TacqInfo);
begin
  acqInfo:=p;
end;

procedure TstimInfo.InitChannelMax(nb:integer);
var
  n,i:integer;
begin
  n:=length(Fchannel);

  setLength(Fchannel,nb);
  for i:=n to nb-1 do outPutDefault(Fchannel[i],i+1);

  setLength(FAutoFillInfo,nb);
  for i:=n to nb-1 do fillchar( FAutoFillInfo[i],sizeof(FAutoFillInfo[i]),0 );

  setLength(FnrnName,nb);
  for i:=n to nb-1 do FnrnName[i]:='';

  for i:=nb to n-1 do vecA[i].Free;
  setLength(vecA,nb);

  for i:=n to high(vecA) do
  begin
    vecA[i]:=Tvector.create;
    with vecA[i] do
    begin
      ident:='Stimulator.v'+Istr(i+1);
      Fchild:=true;
      NotPublished:=true;
      readOnly:=true;
      tagUO:=i;
    end;
  end;

  if channelCount<0 then channelCount:=0;
  if channelCount>nb then channelCount:=nb;

  ClearChildList;
  for i:=1 to nb do
    addToChildList(vecA[i-1]);
end;



function TstimInfo.Dyu(v:integer):float;
var
  p:Poutput;
begin
  p:=channel[v];
  if assigned(p) then
  with p^ do
  begin
    if jru1<>jru2
      then result:=(Yru2-Yru1)/(jru2-jru1)
      else result:=1;
    if assigned(board) then
      result:=result*board.GcalibDac(physNum);
           { GcalibDac devrait utiliser Device mais la DD1322 n'a qu'un device }
  end
  else result:=1;
end;

function TstimInfo.y0u(v:integer):float;
var
  dyB:float;
  p:Poutput;
begin
  p:=channel[v];
  if assigned(p) then
  with p^ do
  begin
    if jru1<>jru2
      then DyB:=(Yru2-Yru1)/(jru2-jru1)
      else DyB:=1;

    y0u:=Yru1-Jru1*DyB;

    if assigned(board) then
      result:=result+DyB*board.OFFcalibDac(physNum);
      { OffcalibDac devrait utiliser Device mais la DD1322 n'a qu'un device }
  end
  else result:=0;
end;

function TstimInfo.dxu:float;
begin
  if assigned(acqInfo) and acqInfo.continu
    then result:=PeriodeParDac/1000
    else result:=PeriodeParDac;
end;

function TstimInfo.x0u:float;
begin
  if not assigned(acqInfo) or (acqInfo.modeSynchro in [MSinterne,MSimmediat])
    then result:=0
    else result:=dxu/ActiveChannels;
end;


function TstimInfo.stimDuration:float;
begin
  if assigned(acqInfo) then
    begin
      if acqInfo.modeSynchro=MSnumPlus
        then result:=acqInfo.dureeSeqApres
        else result:=acqInfo.dureeSeq;
    end
  else result:=0;
end;

function TstimInfo.nbpt:integer;
begin
  if ActiveChannels=0 then
  begin
    result:=1000;
    exit;
  end;

  if assigned(acqInfo) then
  begin
    if AcqInfo.continu then
      begin
        result:=round(2000/periodeParDac);
        if result<100 then result:=100;
      end
    else result:=roundL(stimDuration/periodeParDac);
  end
  else result:=1000;
end;

function TstimInfo.nbpt1:integer;
begin
  result:=nbpt*ActiveChannels;
end;


function TstimInfo.unitX:AnsiString;
begin
  if assigned(acqInfo) and AcqInfo.continu
    then unitX:='sec'
    else unitX:='ms';
end;

function TstimInfo.periodeParDac:float;   {Résultat en millisecondes}
var
  pIn,pOut:float;
begin
  if assigned(acqInfo) and assigned(board) then
  begin
    pIn:=1;
    pOut:=1;
    board.GetPeriods(acqInfo.periodeCont,acqInfo.nbADC+acqInfo.nbVoieEvt,acqInfo.nbDigi,nbDAC,nbDigi,pIn,pOut);
    result:=pOut;
  end
  else result:=1;
end;

function TstimInfo.isi:float;
var
  p,w:float;
begin
  result:=1000;
  if not assigned(board) or acqInf.continu then exit;


  if (acqInf.ISIsec*1000<acqInf.dureeSeq) or (acqInf.modeSynchro=MSimmediat)
    then p:=acqInf.dureeSeq
    else p:=acqInf.ISIsec*1000;     {isi souhaité en ms }

  w:=board.AgPeriod(AcqInf.DureeSeq/AcqInf.Qnbpt,AcqInf.Qnbvoie,0,nbDac,nbdigi); {Durée d'un agrégat en ms}
  if w=0 then exit;

  result:=roundL(p/w)*w/1000;
  if (acqInf.modeSynchro in [MSimmediat,MSinterne]) and not acqInf.continu then
  while (result*1000<acqInf.dureeSeq) do
          result:=result+w/1000;
end;

function TstimInfo.isiPts:integer;
begin
  result:=roundL(isi*1000/periodeParDac);
  if ActiveChannels>0
    then result:=result*ActiveChannels
    else result:=1000;
end;


procedure TstimInfo.controle;
begin
  {
  if (nbAna<0) or (nbAna>maxDAC0) then nbAna:=0;
  if (nbDigiDevice<0) or (nbDigiDevice>maxDigiDevice0) then nbDigiDevice:=0;
  }
end;

procedure TstimInfo.OldToNew(var old: TparamStimOld);
var
  i,j:integer;
begin
end;

procedure TstimInfo.Old2ToNew(var old: TparamStim);
var
  i,j:integer;
begin
end;


function ParamStim:TstimInfo;
begin
  result:=DacStimInfo;
end;






procedure TstimInfo.outPutDefault(var p:typeOutPut;LogNum:integer);
begin
  fillchar(p,sizeof(p),0);
  with p do
  begin
    Jru1:=0;
    Jru2:=32767;
    Yru1:=0;
    Yru2:=10000;
    unitY:='mV';

    color:=clRed;
    Ymin:=-10000;
    Ymax:=10000;

    logCh0:=LogNum;
  end;
end;

function TstimInfo.getchannel(logCh: integer): PoutPut;
begin
  if (logCh>=1) and (logCh<=length(Fchannel))
    then result:=@Fchannel[logCh-1]
    else result:=nil;
end;

function TstimInfo.getAutoFillInfo(logCh: integer): PAutoFillInfo;
begin
  if (logCh>=1) and (logCh<=length(FAutoFillInfo))
    then result:=@FAutoFillInfo[logCh-1]
    else result:=nil;
end;

function TstimInfo.getNrnName(logCh: integer): Pansistring;
begin
  if (logCh>=1) and (logCh<=length(FAutoFillInfo))
    then result:=@FnrnName[logCh-1]
    else result:=nil;
end;

function TstimInfo.maxChan: integer;
begin
  result:=length(Fchannel);
end;

function compare(Item1, Item2: Pointer): Integer;
begin
  if intG(item1)<intG(item2) then result:=-1
  else
  if intG(item1)=intG(item2) then result:=0
  else result:=1;

end;

{ initStimBuffers réalloue les buffers en se basant sur les paramètres utilisateur.
  Le contenu des buffers n'est pas modifié.
  Si les paramètres n'ont pas changé, les buffers et leur contenu sont inchangés.
}
procedure TstimInfo.initStimBuffers(Fmini:boolean);
const
  tailleMiniDac=100000;
var
  i,j,k:integer;
  n,n1,n2:integer;
  bufSize:integer;
  list:Tlist;
  p:pointer;

function PseudoP(LogCh:integer):pointer;
begin
  with channel[LogCh]^ do
  result:=pointer(physNum + Device*100 + 10000*ord(tpOut=to_digibit) + (1000000+logCh)*ord(tpout=to_neuron));
end;

begin
  {list permet de fixer les numéros de buffer associés au canaux logiques
   Le nombre de buffers est inférieur ou égal au nombre de canaux logiques
   On ordonne les buffers en rangeant d'abord les voies analogiques pour chaque device
   puis les voies digitales pour chaque device.
   On en profite pour construire DigiMask et DacMask.
  }
  setRTmode;

  fillchar(DigiMask,sizeof(DigiMask),0);
  fillchar(DacMask,sizeof(DacMask),0);

  list:=Tlist.create;
  for i:=1 to channelCount do
  with channel[i]^ do
  begin
    if not RTmode and (tpOut=TO_neuron) then tpOut:=to_analog;
    p:=pseudoP(i);
    if list.indexof(p)<0 then list.add(p);

    case tpOut of
      to_analog:  DacMask[physNum div 16]:=DacMask[physNum div 16] or (1 shl (physNum mod 16));
      to_DigiBit: DigiMask[physNum and $F]:=DigiMask[physNum and $F] or (1 shl bitNum);
    end;
  end;
  list.Sort(compare);

  {Une fois la liste triée, on affecte les numéros de buffer}
  for i:=1 to channelCount do
  with channel[i]^ do
  begin
    p:=pseudoP(i);
    BufferNum:=list.indexof(p);
  end;

  {On compte les nombres de buffers analogiques Xana et digitaux Xdigi
   XactiveChannels est la somme des deux.
  }
  XAna:=0;
  Xdigi:=0;
  Xnrn:=0;
  XActiveChannels:=0;
  if not AcqInf.Fstim then exit;

  for i:=0 to list.Count-1 do
  if intG(list[i])<10000 then inc(Xana)
  else
  if intG(list[i])<1000000 then inc(Xdigi)
  else inc(Xnrn);

  list.free;

  if not RTmode then Xnrn:=0;
  XActiveChannels:=Xana+Xdigi+Xnrn;

  if XActiveChannels=0 then exit;

  if AcqInfo.continu and (BufferSizeU>0)
    then FEPsize:=BufferSizeU
    else FEPsize:=nbpt;

  Xnbpt1:=FEPsize*XActiveChannels;

  {EPsize est simplement la taille d'un épisode ou pseudo-épisode (fichier continu)}

  {On calcule le nombre d'épisodes stockés
   On souhaite au moins deux épisodes ou deux secondes, sauf si BufferCountU<>0
  }
  if Fmini then BufSize:=FEPsize
  else
  if bufferCountU>0 then BufSize:=FEPsize*bufferCountU
  else
    begin
      BufSize:=roundL(2000/periodeParDAC);
      if bufSize<tailleMiniDac then bufSize:=tailleMiniDac;

      if 2*FEPsize>BufSize
        then BufSize:=2*FEPsize
        else BufSize:=(BufSize div FEPsize+1)*FEPsize;
    end;

  FstoredEp:=BufSize div FEPsize;


  {Allocation des buffers}
  if RTmode then
  begin
    n1:=length(Fbuffer1);
    if n1>0
      then n2:=length(Fbuffer1[0])
      else n2:=0;

    setLength(Fbuffer1,XActiveChannels,FstoredEp*FEPsize);
    setLength(Fbuffer,0,0);
  end
  else
  begin
    n1:=length(Fbuffer);
    if n1>0
      then n2:=length(Fbuffer[0])
      else n2:=0;

    setLength(Fbuffer,XActiveChannels,FstoredEp*FEPsize);
    setLength(Fbuffer1,0,0);
  end;

  {On met à zéro les parties nouvellement créées. }
  for n:=0 to XactiveChannels-1 do
    if FstoredEp*FEPsize>n2 then
      if RTmode
        then fillchar(Fbuffer1[n,n2],(FstoredEp*FEPsize-n2)*2,0)
        else fillchar(Fbuffer[n,n2],(FstoredEp*FEPsize-n2)*2,0);

  {Initialisation des vecteurs}
  initVectors;
end;

procedure TstimInfo.FreeStimBuffers;
begin
  setLength(Fbuffer,0);
  setLength(Fbuffer1,0);
end;

function TstimInfo.getBuffer(logCh,NumEp:integer):Ptabentier;
var
  ep,numbuf:integer;
begin
  numBuf:=channel[logCh]^.BufferNum;
  ep:=(NumEp-1) mod storedEp;
  result:=@Fbuffer[numBuf,ep*epSize];
end;

function TstimInfo.getBuffer1(logCh,NumEp:integer):PtabSingle;
var
  ep,numbuf:integer;
begin
  numBuf:=channel[logCh]^.BufferNum;
  ep:=(NumEp-1) mod storedEp;
  result:=@Fbuffer1[numBuf,ep*epSize];
end;



procedure TstimInfo.initVectors;
var
  i,n:integer;
  dat:typeDataTab;
begin

  {Pour chaque canal logique, on associe le premier épisode du bon buffer}
  for i:=1 to channelCount do
  with vecA[i-1] do
  begin
    if RTmode then
    begin
      if Fchannel[i-1].tpOut <>to_DigiBit then
      begin
        dat:=typeDataS.create(Buffer1[i,1],1,0,0,FEPsize-1);
        initDat1Ex(dat,G_single);
      end
      else
      begin
        dat:=typeDataIbit.create(Buffer1[i,1],2,0,0,FEPsize-1,Fchannel[i-1].bitNum);  { on indique 2 voies }
        initDat1Ex(dat,G_smallint);
      end;
    end
    else
    begin
      if Fchannel[i-1].tpOut <>to_DigiBit
        then dat:=typeDataI.create(Buffer[i,1],1,0,0,FEPsize-1)
        else dat:=typeDataIbit.create(Buffer[i,1],1,0,0,FEPsize-1,Fchannel[i-1].bitNum);
      initDat1Ex(dat,G_smallint);
    end;

    inf.readOnly:=false;      {Autorise l'écriture, pas le changement de structure }

    x0u:=0;
    dxu:=self.dxu;
    if Fchannel[i-1].tpOut=TO_analog then
    begin
      dyu:=self.dyu(i);
      y0u:=self.y0u(i);
      unitY:=Fchannel[i-1].unitY;
    end
    else
    begin
      dyu:=1;
      y0u:=0;
      unitY:='';
    end;
    unitX:='ms';
    invalidate;
  end;

  for i:= channelCount to high(vecA) do
    vecA[i].initDat1(nil,G_smallint);

end;

procedure TstimInfo.freeVectors;
var
  i:integer;
begin
  for i:=0 to high(vecA) do vecA[i].free;
  setLength(vecA,0);
  clearChildList;
end;

procedure TstimInfo.adjustVector(logCh,NumEp:integer;FillZero:boolean);
begin
  {On change simplement l'adresse du buffer, suivant NumEp
  }
  with vecA[logCh-1] do
  begin
    if RTmode
      then data.modifyData(buffer1[logCh,NumEp])
      else data.modifyData(buffer[logCh,NumEp]);
    if fillZero then fill(0);

    if AcqInf.continu
      then x0u:=Dxu*FepSize*(NumEp-1);
  end;
end;



procedure TstimInfo.FillAnaSegs(num,seq:integer); {num commence à 0 ; seq commence à 1 }
var
  t,amp0:float;
  i,rep01,rep02:integer;
begin
  if not assigned(vecA[num]) then exit;

  Seq:=Seq-1;

  with FAutoFillInfo[num] do
  begin
    t:=0;
    i:=1;
    while (i<=20) and (t<=vecA[num].Xend) and (ana[i].duree<>0) do
    with ana[i] do
    begin
      if rep1=0 then rep01:=maxEntierLong
                else rep01:=rep1;
      if rep2<=0 then rep02:=1
                 else rep02:=rep2;
      if mode=0 then
        begin
          amp0:=amp+((Seq div rep02) mod rep01)*incAmp;
          vecA[num].Vmoveto(t,amp0);
          t:=t+duree+((Seq div rep02) mod rep01)*incduree;
          vecA[num].VlineTo(t,amp0);
        end
      else
        begin
          vecA[num].Vmoveto(t,Vinit);
          t:=t+duree;
          vecA[num].Vlineto(t,Vfinale);
        end;

      inc(i);
    end;

  end;
end;

procedure TstimInfo.FillDigiPulses(num,seq:integer);
var
  t:float;
  i,rep01,rep02:integer;
  numP,numS,numseq1:integer;
  delta,amp:float;
begin
  if not assigned(vecA[num]) then exit;
  Seq:=Seq-1;


  with FautoFillInfo[num] do
  begin
    if Fchannel[num].tpOut=to_analog
    then amp:=PulseAmp
    else amp:=1;

    for i:=1 to 20 do
      with pulse[i] do
      begin
        if rep1=0 then rep01:=maxEntierLong
                  else rep01:=rep1;
        if rep2<=0 then rep02:=1
                   else rep02:=rep2;


        t:=date+((Seq div rep02) mod rep01)*incdate;
        vecA[num].Vmoveto(t,amp);
        delta:=duree+((numSeq1 div rep02) mod rep01)*incduree;
        t:=t+delta;
        if delta<>0 then vecA[num].VlineTo(t-vecA[num].dxu,amp);
      end
  end
end;

procedure TstimInfo.FillDigiTrain(num,seq:integer);
var
  t,amp:float;
  i:integer;
  numP,numS:integer;
begin
  if not assigned(vecA[num]) then exit;
  Seq:=Seq-1;

  with FautoFillInfo[num], train do
  begin
    if Fchannel[num].tpOut=to_analog
    then amp:=PulseAmp
    else amp:=1;

    for numP:=1 to nbPulse do
      for numS:=1 to nbSalve do
        begin
          t:=delaiTrain+(numS-1)*cadenceSalve+(numP-1)*cadencePulse;
          vecA[num].Vmoveto(t,amp);
          vecA[num].Vlineto(t+largeurPulse-vecA[num].dxu,amp);
        end;
  end;
end;





procedure TstimInfo.BuildMenuStim(seq:integer);
var
  i:integer;
  oldX0:double;
begin
  for i:=1 to channelCount do
  with AutoFillInfo[i]^ do
  begin
    adjustVector(i,seq,true);
    oldX0:=vecA[i-1].X0u;
    vecA[i-1].X0u:=0;

    case FillMode of
      0:  FillAnaSegs(i-1,seq);
      1:  FillDigiPulses(i-1,seq);
      2:  FillDigiTrain(i-1,seq);
    end;

    vecA[i-1].X0u:=oldX0;
  end;
end;

procedure TstimInfo.BuildPgStim(seq:integer);
var
  i:integer;
begin
  if finexeU^ then exit;

  for i:=1 to channelCount do
    with channel[i]^ do
    begin
      adjustVector(i,seq,false);
      with BuildEp do
        if valid then pg.executerBuildEp(ad,seq,typeUO(VecA[i-1]));
    end;
end;

procedure TstimInfo.BuildStim(seq:integer);
begin
  if FstoredEp=0 then exit;
  if setByProgU
    then BuildPgStim(seq)
    else BuildMenuStim(seq);
end;

procedure TstimInfo.initOutPutValues;
var
  j,seq:integer;
begin
  if finExeU^ then exit;

  affdebug('InitOutPutValues ',80);
  {On remplit tous les buffers avec les premières stimulations }
  for seq:=1 to StoredEp do
  begin
    XNumSeq:=seq;
    BuildStim(seq);
  end;

  XNumSeq:=storedEp;
  StoredSamples:=XActiveChannels*StoredEp*EpSize;
  oldStimCount:=StoredSamples-1;
end;

procedure TstimInfo.setOutPutValues(cnt: integer);
var
  i,j,seq:integer;
begin
  if finExeU^ then exit;
  if cnt<=0 then exit;

  {
   janvier 2012:
     BufferCount=0 est la seule condition pour que les buffers soient mis à jour pendant l'acquisition
     Quand BufferCount=0 , les buffers sont mis à jour par les params du dialogue Stimulation si SetByProg = false
                             les buffers sont mis à jour par le programme (stimulator.buildEp) si SetByProg = true
     Si BufferCount>0 ,les buffers ne sont jamais mis à jour
                             Avec SetByProg = false , ils sont initialisés par les params du dialogue Stimulation.
                             Avec SetByProg = true,  ils ne sont pas initialisés du tout.
  }
  if (BufferCountU=0) then
  begin
    {cnt est le nombre de points total avalés par la carte d'acquisition/stimulation
     On peut donc remplacer ces points par des nouveaux. Toutefois, on doit
     construire un épisode en une seule fois.
    }
    affdebug('setOutPutValues cnt='+Istr(cnt),80);

    cnt:=StoredSamples+cnt;
    for i:=oldStimCount+1 to cnt do
      begin
        seq:=i div Xnbpt1 ;             {séquence précédente}

        if (seq > XNumSeq) then
          begin
            XNumSeq:=seq;
            BuildStim(seq);
          end;
      end;
    oldStimCount:=cnt;
  end;
end;

procedure TstimInfo.install;
begin
  initStimBuffers(false);
  XnumSeq:=-1;
end;

procedure TstimInfo.reset;
begin
  {initStimBuffers(true);}
end;


procedure TstimInfo.setChildNames;
var
  i:integer;
begin
  for i:=0 to high(vecA) do
  with vecA[i] do
    ident:='Stimulator.v'+Istr(i+1);
end;

function TstimInfo.getBufferInfo(n:integer): Poutput;
var
  i:integer;
begin
  for i:=1 to channelCount do
  with channel[i]^ do
  if BufferNum=n then
  begin
    logCh0:=i;
    result:=@Fchannel[i-1];
    exit;
  end;
end;




function TstimInfo.loadFromStream(f: Tstream; size: LongWord;Fdata: boolean): boolean;
var
  st1:string[255];
  posf:LongWord;
  res:intG;
  posIni,pos1:LongWord;
  n,code:integer;

  OldstID:string[30];
  stID: AnsiString;
  ok:boolean;
  conf:TblocConf;
begin
  result:=inherited loadFromStream(f,size,false);

  if not result then exit;

  if f.position>=f.size then exit;

  FLoadObjectsMINI:=true;

  if (maxChanR>=minPossibleChannels) and (maxChanR<=maxPossibleChannels)
    then initChannelMax(maxChanR);

  repeat
    posIni:=f.position;
    st1:=readHeader(f,size);
    ok:=false;

    if (st1=Tvector.STMClassName) then
    begin
      pos1:=f.position;

      StId:='';
      OldStId:='';

      conf:=TblocConf.create(st1);
      conf.setvarConf('IDENT',OldstId,sizeof(OldstId));
      conf.setStringConf('IDENT1',stId);
      ok:=(conf.lire1(f,size)=0);
      conf.free;
      f.Position:=pos1;

      if stId='' then stId:=OldStId;

      if copy(stId,1,12)='Stimulator.v' then
        begin
          delete(stId,1,12);
          val(stId,n,code);
          if (code=0) and (n>=1) and (n<=maxChan)
            then ok:=vecA[n-1].loadFromStream(f,size,Fdata)
            else f.Position:=posini+size;
        end
        else f.Position:=posini+size;
    end
  else
    begin
      ok:=false;
      f.Position:=posini+size;
    end;
  until (f.position>=f.size) or not ok;
  f.Position:=posini;

  FLoadObjectsMINI:=false;

  setChildNames;
  loadFromStream:=true;

  DacStimInfo:=self;      // ajouté aout 2011 pour XE
end;




procedure TstimInfo.saveToStream(f: Tstream; Fdata: boolean);
var
  i:integer;
begin
  inherited;
  for i:=0 to maxChan-1 do
  begin
    with vecA[i] do
    if IsModified then saveToStream(f,Fdata);
  end;
end;

function TstimInfo.getVector(logCh: integer): Tvector;
begin
  if (logCh>=1) and (logCh<=length(vecA))
    then result:=vecA[logCh-1]
    else result:=nil;
end;

procedure TstimInfo.RefreshVectors;
var
  i:integer;
  deltaX:float;
begin
  for i:=1 to channelCount do
  begin
    with vector[i] do
    begin
      deltaX:=Icount*dxu;
      while Xmin<=Xstart-deltaX do
      begin
        Xmin:=Xmin+deltaX;
        Xmax:=Xmax+deltaX;
      end;
      while Xmax>=Xend+deltaX do
      begin
        Xmin:=Xmin-deltaX;
        Xmax:=Xmax-deltaX;
      end;
    end;
    vector[i].invalidate;
  end;
end;

{**************************** Méthodes Stm ******************************}


procedure controleReadOnly(var pu:typeUO);
begin
  verifierObjet(pu);
  if  TstimInfo(pu).ReadOnly then sortieErreur('Tstimulator is ReadOnly');
end;

procedure controleReadOnlyCh(pu:PoutPut);
begin
  if  pu^.ReadOnly then sortieErreur('Tstimulator is ReadOnly');
end;

   {Les méthodes stimChannel reçoivent directement l'adresse de typeOutPut}

procedure proTstimChannel_Device(w:integer;pu:PoutPut);
begin
  controleReadOnlyCh(pu);
  if (w<0) or (w>=board.deviceCount)
    then sortieErreur('TstimChannel: invalid device number');
  pu^.Device:=w;
end;

function fonctionTstimChannel_Device(pu:PoutPut):integer;
begin
  result:=pu^.Device;
end;

procedure proTstimChannel_PhysNum(w:integer;pu:PoutPut);
var
  max:integer;
begin
  controleReadOnlyCh(pu);
  with pu^ do
  case tpOut of
    TO_analog: max:=board.DACcount(device);
    TO_digiBit,TO_digi8,TO_digi16: max:=board.DigiOutCount(device);
    else max:=1000;
  end;

  if (w<0){ or (w>=max) }
    then sortieErreur('TstimChannel: invalid physical number');

  pu^.PhysNum:=w;
end;

function fonctionTstimChannel_PhysNum(pu:PoutPut):integer;
begin
  result:=pu^.PhysNum;
end;

procedure proTstimChannel_ChannelType(w:integer;pu:PoutPut);
begin
  controleReadOnlyCh(pu);
  if (w<ord(low(ToutPutType))) or (w>ord(high(ToutPutType)))
    then sortieErreur('TstimChannel: invalid channelType');
  pu^.tpOut:=ToutPutType(w);
end;

function fonctionTstimChannel_ChannelType(pu:PoutPut):integer;
begin
  result:=ord(pu^.tpOut);
end;

procedure proTstimChannel_BitNum(w:integer;pu:PoutPut);
begin
  controleReadOnlyCh(pu);
  if (w<0) or (w>=board.BitOutCount(pu^.device))
    then sortieErreur('TstimChannel: invalid Bit number');
  pu^.bitNum:=w;
end;

function fonctionTstimChannel_BitNum(pu:PoutPut):integer;
begin
  result:=pu^.bitNum;
end;

function fonctionTstimChannel_Dy(pu:PoutPut):float;
begin
  with pu^ do
  begin
    if jru1<>jru2
    then result:=(Yru2-Yru1)/(jru2-jru1)
    else result:=1;
  end;
end;

function fonctionTstimChannel_y0(pu:PoutPut):float;
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

procedure proTstimChannel_unitY(w:AnsiString;pu:PoutPut);
begin
  controleReadOnlyCh(pu);
  pu^.unitY:=w;
end;

function fonctionTstimChannel_unitY(pu:PoutPut):AnsiString;
begin
  result:=pu^.unitY;
end;

procedure proTstimChannel_setScale(j1,j2:integer;y1,y2:float;pu:PoutPut);
begin
  controleReadOnlyCh(pu);
  if (j1=j2) then sortieErreur('TstimChannel.setScale : invalid parameter' );

  with pu^ do
  begin
    jru1:=j1;
    jru2:=j2;
    Yru1:=y1;
    Yru2:=y2;
  end;
end;

procedure proTstimChannel_buildEp(w:integer;pu:PoutPut);
begin
  controleReadOnlyCh(pu);
  with pu^ do
  begin
    BuildEp.setAd(w);
  end;

end;

function fonctionTstimChannel_buildEp(pu:PoutPut):integer;
begin
  with pu^ do
  begin
    result:=BuildEp.Ad;
  end;

end;

procedure proTstimChannel_NrnSymbolName(w:AnsiString;pu:PoutPut);
begin
  paramstim.NrnName[pu.logch0]^:=w;
end;

function fonctionTstimChannel_NrnSymbolName(pu:PoutPut):AnsiString;
begin
  result:=paramstim.NrnName[pu.logch0]^;
end;

procedure proTstimulator_ChannelCount(w:integer;var pu:typeUO);
begin
  verifierObjet(pu);
  controleReadOnly(pu);
  with TstimInfo(pu) do
  begin
    if (w<0) or (w>length(Fchannel))
      then sortieErreur('Tstimulator: invalid ChannelCount');
    channelCount:=w;
  end;
end;

function fonctionTstimulator_ChannelCount(var pu:typeUO):integer;
begin
  verifierObjet(pu);
  result:=TstimInfo(pu).channelCount;
end;

function fonctionTstimulator_Channels(n:integer;var pu:typeUO):pointer;
begin
  with TstimInfo(pu) do
  begin
    if (n<1) or (n>maxChan)
      then sortieErreur('Tstimulator.Channel : index out of range');
    result:=@Fchannel[n-1];
  end;
end;


procedure proTstimulator_BufferCount(w:integer;var pu:typeUO);
begin
  if w<0 then sortieErreur('Tstimulator.BufferCount must be positive');
  TstimInfo(pu).BufferCountU:=w;
end;

function fonctionTstimulator_BufferCount(var pu:typeUO):integer;
begin
  result:= TstimInfo(pu).BufferCountU;
end;

procedure proTstimulator_BufferSize(w:integer;var pu:typeUO);
begin
  TstimInfo(pu).bufferSizeU:=w;
end;

function fonctionTstimulator_BufferSize(var pu:typeUO):integer;
begin
  result:= TstimInfo(pu).bufferSizeU;
end;


procedure proTstimulator_CurrentBuffer(w:integer;var pu:typeUO);
var
  i:integer;
begin
  with TstimInfo(pu) do
  begin
    CurrentBufferU:=w mod FstoredEp;

    for i:=1 to channelCount do
    with vecA[i-1] do
    begin
      if RTmode
        then data.modifyData(buffer1[i,CurrentBufferU+1])
        else data.modifyData(buffer[i,CurrentBufferU+1]);
      x0u:=0;
    end;
  end;

end;

function fonctionTstimulator_CurrentBuffer(var pu:typeUO):integer;
begin
  result:= TstimInfo(pu).CurrentBufferU;
end;


function fonctionTstimulator_vector(num:integer;var pu:typeUO):Tvector;
begin
  with TstimInfo(pu) do
  begin
    if (num<1) or (num>length(vecA))
      then sortieErreur('Tstimulator.vector : index out of range');

    result:=@vecA[num-1];
  end;
end;



function fonctionTstimulator_setValue(Device,tpOut,physNum,value:integer;var pu:typeUO):boolean;
begin
  if assigned(board)
    then result:=board.setValue(Device,tpOut,physNum,value);
end;

function fonctionTstimulator_getValue(Device,tpIn,physNum:integer;var value:smallint;var pu:typeUO):boolean;
begin
  if assigned(board)
    then result:=board.getValue(Device,tpIn,physNum,value);
end;


procedure proTstimulator_initVectors(var pu:typeUO);
begin
  with TstimInfo(pu) do
  begin
    initStimBuffers(false);
    {acqInf.StepStim:=true;}
  end;
end;

procedure proTstimulator_SetByProg(w:boolean;var pu:typeUO);
begin
  TstimInfo(pu).setByProgU:=w;
end;

function fonctionTstimulator_SetByProg(var pu:typeUO):boolean;
begin
  result:=TstimInfo(pu).setByProgU;
end;

procedure proTstimulator_AlwaysUpdateBuffers(w:boolean;var pu:typeUO);
begin
  TstimInfo(pu).AlwaysUpdateBuffers:=w;
end;

function fonctionTstimulator_AlwaysUpdateBuffers(var pu:typeUO):boolean;
begin
  result:=TstimInfo(pu).AlwaysUpdateBuffers;
end;



procedure TstimInfo.setRTmode;
begin
  if assigned(board) and (board.RTmode<>RTmode) then
  begin
    RTmode:=board.RTmode;
    freeStimBuffers;
  end;
end;

Initialization
AffDebug('Initialization StimInf2',0);


registerObject(TacqInfo,sys);
registerObject(TstimInfo,sys);


end.

