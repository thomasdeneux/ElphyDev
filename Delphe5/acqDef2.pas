unit AcqDef2;

{ AcqDef1 est devenue AcqDef2 + AcqInf2 + StimInf2

  AcqDef2 contient uniquement les variables globales et les anciennes structures
  AcqInf2 contient TacqInfo
  StimInf2 contient TstimInfo
}

INTERFACE
{$IFDEF FPC} {$mode delphi} {$DEFINE AcqElphy2} {$A1} {$Z1} {$ENDIF}

uses classes, sysutils,
     util1,debug0,cyberK2, PCL0;


{ Ces constantes ne servent qu'à imposer une limite globale aux paramètres }     
const
  maxADC0=128;
  maxDAC0=128;
  maxDigiPort0=16;
  maxSeg=20;


{******************** Variables globales **************************************}
var
  DriverAcqOK:boolean;





  mainBuf:ptabEntier;    { adresse du buffer principal }
  mainBufSize:integer;   { sa taille en octets }

var
  nbAg0:integer;         { nombre d'agrégats du buffer principal
                         }

  nbSeq0:integer;        { nombre de séquences contenues dans mainBuf}

  MainBufIndex:integer;  { indice du dernier échantillon disponible dans MainBuf.
                           Est positionné par le thread d'acquisition.
                           Est utilisé par le thread d'affichage et par le
                           thread de traitement/stimulation.
                         }
  MainBufIndex0:integer; { reçoit MainBufIndex en fin d'acquisition.
                           Permet la reprise.
                         }
  MainSaveIndex:integer; { indice du dernier point sauvé }

  FlagStop:boolean;      { est positionné:
                            - quand l'utilisateur choisit Stop dans le menu
                            - en cas d'erreur d'exécution
                            - quand le programme pg1 appelle la procédure Stop
                           est testé par le thread d'acquisition qui positionne
                           alors FlagStop2
                         }
  FlagStopPanic:boolean; { Permet l'arrêt immédiat en mode Panique }
  FlagStop2:boolean;     { est positionné par le thread d'acquisition.
                           est testé par les threads d'affichage et de traitement, ce
                           qui provoque leur terminaison.
                         }

  maxDiffProcess:integer;{Différence maximale autorisée pour le thread de traitement
                          en nombre d'échantillons}

  BaseIndex:integer;     {Indice de la prochaine stimulation dans MainDacBuf
                          Mis à zéro par initVarAcq;
                         }


  FmultiMainBuf:boolean;            { 01-2009 Implementation d'un mainBuf pour chaque voie }
                                    { Utilisé par CyberK }
                                    { pourrait être utilisé par ITC }

  FPCLbuf:boolean;       { Imagerie PCL
                          }
Const
  MaxMultiEvt = 10000;  {  Taille des buffers Vspk et VspkWave     ==> 10000
                           En mode épisode, c'est le nombre max de spikes par électrode du cyberK

                           En fixant 100000, on alloue environ 100000*128*2*32 = 800 MegaOctets !!!    Saturation mémoire assurée
                           On revient à 10000 . 11 janvier 2011

                         }
  MaxSimpleEvt= 100000;  {  Taille des buffers Evt
                            En mode épisode, c'est le nombre max d'événements détectés sur une voie
                         }
  MaxPhoton = 1000000;   {  Taille du buffer EvtPCL et du buffer Digital Event
                            En mode épisode, c'est le nombre max d'événements détectés sur une voie
                         }

  MaxCyberTag = 100000;
type

  TMultiMainBuf = class
                    Buf:pointer;          // Le buffer
                    BufAtt:PtabOctet;     // Le buffer d'attributs
                    BufWave:PtabOctet;    // Le buffer des formes de spikes
                    
                    nbPtSpk:integer;      // Le nombre de points (smallint) par waveForm
                    BufSize:integer;      // La taille des buffers en nombre d'échantillons (longints, octets, waveforms )
                    waveSize:integer;     // taille des waveforms en octets;
                    BufType:typetypeG;    // type de données: smallint, longint ou single
                    Index:integer;        // index de stockage
                    IndexT:integer;       // index de traitement
                    OldIndexT:integer;    // index de traitement précédent
                    LastW: word;          // dernier mot stocké (pour StoreDins)

                    Dxu:double;           // periode
                    EpNum:integer;

                    BufTag: PtabCybTag;   // Buffer contenant les transitions sur les digital inputs
                    IndexTag:integer;     // index de stockage
                    IndexTagT:integer;    // index de traitement
                    OldIndexTagT:integer;  // index de traitement précédent

                    constructor create(tp:typetypeG;Sz:integer; dx:double);
                    constructor createWithAtt(tp:typetypeG;Sz:integer; dx:double);
                    constructor createWithWaves(tp:typetypeG;Sz,nbPtSpk1:integer; dx:double);
                    constructor createWithCybTag(tp:typetypeG;Sz:integer; dx:double);

                    destructor destroy;override;

                    function BufSmall:PtabEntier;
                    function BufSingle:PtabSingle;
                    function BufLong:PtabLong;

                    function getSmall(i:integer):smallint;
                    function getLong(i:integer):longint;
                    function getSingle(i:integer):single;

                    procedure StoreSmall(w:smallint);
                    procedure StoreLong( w:longint);
                    procedure StoreSingle( w:single);
                    procedure StoreLongAtt(w:longint;att:byte);
                    procedure StoreSpike(p:PcbPKT_SPK;w:longint;att:byte);

                    procedure SetInitDins(w:word);
                    procedure StoreDins(w:word; time, seqTime:integer);
                    procedure SetLastDins(time,seqTime:integer);

                    function GetSpikeCount(tmax:double):integer;
                    function ProcessSpikes(ep: integer; var indexT1,oldIndexT1:integer): integer;
                    procedure SaveLastData(f:Tstream);
                    procedure SaveLastWaves(f:Tstream);
                    procedure SaveLastTags(f:Tstream;Imax:integer;Const All:boolean=true);

                    function getNextLong(nmax:integer;var n:integer):boolean;
                    Procedure NextEpisode;

                    function BufTagFull:boolean;

                    procedure SaveAllData(f: Tstream);
                  end;

 { TPCLrecord est la structure d'un photon dans un fichier PCL
  Les nombres sont stockés en Big Endian format
  Convert rétablit l'ordre des octets .
 }

type
  TPCLbuf=        class
                    buf:pointer;
                    nbrec:integer;
                    Index:integer;        // index de stockage
                    IndexT:integer;       // index de traitement
                    OldIndexT:integer;    // index de traitement précédent

                    DxTime: double;       // scale parameter
                    constructor create(nb:integer; Dxu: double);
                    procedure storeRec(tt1:float;x1,y1:integer;const z1:integer=0);
                    function GetRecCount(tmax:double):integer;
                    function GetRecCountExtra(tmax:double):integer;
                    function GetRecCountPCL(tmax:double):integer;
                    function NbAvailable:integer;
                    procedure saveLastData(f:Tstream);

                    function getDataPhoton(i1,i2:integer): typeDataPhotonB;
                  end;

var
  MultiMainbuf:array of TmultiMainBuf;
  MultiEvtBuf: array of TmultiMainBuf;
  MultiCyberTagBuf: TmultiMainBuf;

  FlagFullMulti: boolean; { set by StoreSpike when buffer is half filled
                            reset by SaveEvtContMulti
                          }
  FlagFullEvt: boolean;   { set by StoreLong when buffer is half filled
                            reset by SaveEvtCont
                          }

  PCLbuf: TPCLbuf;
  DigEvtBuf:TmultiMainBuf;

{********** Types communs aux anciens et au nouveau format *******************}

type
  TdataFileFormat=(Dac2format,ElphyFormat1,ABFformat);
  TmodeSync=(MSimmediat,MSclavier,MSanalogAbs,MsAnalogDiff,
             MSnumPlus,MSnumMoins,MSinterne,
             MSprogram,
             MSanalogNI);

const
  TrigType:array[TmodeSync] of AnsiString=
    ('Immediate','Keyboard','Analog absolute','Analog differential',
    'Digital (rising edge)','Digital (falling edge)','Internal','Program','NI Analog');

function TrigString:AnsiString;

{************************  Anciens formats ***********************************}
type
  TacqRecord=record
               continu:boolean;
               Qnbvoie:smallint;             { nombre de voies analogiques}
               Qnbpt:integer;                { nombre de points par voie }
               Qnbav:integer;                { nombre de pts avant trigger }
               DureeSeqU:single;             { Durée séquence en ms}
               periodeCont:single;           { période en continu en ms }

               ModeSynchro:TmodeSync;
               voieSynchro:smallint;         {numéro logique =voie d'acq ou
                                              voie d'acq= voie max+1 }
               seuilPlus,seuilMoins:single;
               IntervalTest:smallint;

               unitY:array[1..16] of string[10];
               jru1,jru2:array[1..16] of smallint;
               yru1,yru2:array[1..16] of single;
               QvoieAcq:array[1..16] of byte;{ numéros des voies physiques }
               Qgain:array[1..16] of byte;   { gain pour chaque voie
                                                      1 correspond à G=1
                                                      2                2
                                                      3                4
                                                      4                8
                                               }

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

               bidEvtInput:array[1..16] of byte;
               bidEvtOn:array[1..16] of boolean;
               EvtThreshold:array[1..16] of single;
               bidEvtGain:array[1..16] of byte;

               maxEpCount:integer;
               maxDuration:single;

               FileInfoSize:integer;
               EpInfoSize:integer;
               MiniCommentSize:integer;

               StepStim:boolean;

               bid3: single;

               RecSound:boolean;
               bid2:array[1..41] of boolean;

               FControlPanel:boolean;
               FtriggerPos:boolean;
               WaitMode:boolean;

               QKS:array[1..16] of word;
               DFformat:TdataFileFormat;
               ChannelType:array[1..16] of byte;
               EvtHysteresis:array[1..16] of single;
               FRising:array[1..16] of boolean;
             end;
  PacqRecord=^TacqRecord;


  typeSegmentAnaOld=
                 record
                   mode:byte;
                   duree,amp,incAmp,incDuree,Vinit,Vfinale:single;
                   rep1,rep2:word;
                 end;

  typeSortieAnaOld=
                record
                  seg:array[1..20] of typeSegmentAnaOld;
                  Jru1,Jru2:integer;
                  Yru1,Yru2:single;
                  unitY:string[10];
                  active:boolean;
                end;

  typePulseNumOld=
                record
                  date,duree,incDate,incDuree:single;
                  rep1,rep2:word;
                end;

  typeSortieNumOld=
                record
                  mode:byte;
                  pulse:array[1..20] of typePulseNumOld;
                  largeurPulse,cadencePulse,cadenceSalve:single;
                  NbSalve, NbPulse:integer;
                  DelaiTrain: single;
                end;

  {Format de paramStim avant le 2 juillet 2002}
  TparamStimOld=
            record
              id:string[15];
              tailleInfo:Integer;

              sAna:array[0..1] of typeSortieAnaOld;

              SNum:array[0..7] of typeSortieNumOld;

              bid2:single;
              bid0:boolean;
              DigiActive:boolean;
              SetByProgU:boolean;
              SetByProgP:boolean;

              bid3:single;
              bid4:single;    

              bid1:boolean;
            end;

  PparamStimOld=^TparamStimOld;

  {Format de ParamStim après le 2 juillet 2002, avant février 2004 }
  {Passage à 16 bits pour les sorties DIO }

  TParamStim=
            record
              id:string[15];
              tailleInfo:Integer;

              sAna:array[0..1] of typeSortieAnaOld;

              SNum:array[0..15] of typeSortieNumOld;

              DigiActive:boolean;
              SetByProgU:boolean;
              SetByProgP:boolean;
           end;

  PparamStim=^TparamStim;


{*****************************************************************************}


var
  AcqDriver1:string[30];

  count2:integer;
  ADCMaxSample:integer;



type
  TElphyEvt1=array of integer;
  TElphyEvtTab=array of TElphyEvt1;

  TelphyIsEvt=array of boolean;

var
  EvtBuf:array[0..63] of TmultiMainBuf;

  FUpEvt:array[0..63] of boolean;


var
  AcqInfOld:TacqRecord;
  paramStimOld:TparamStimOld;
  paramStimOld2:TparamStim;
var
  AcqComment:AnsiString; {ne sert que pour la sauvegarde}




implementation

uses ElphyFormat;
{ TMultiMainBuf }

function TMultiMainBuf.BufLong: PtabLong;
begin
  result:=Buf;
end;

function TMultiMainBuf.BufSingle: PtabSingle;
begin
  result:=Buf;
end;

function TMultiMainBuf.BufSmall: PtabEntier;
begin
  result:=Buf;
end;

constructor TMultiMainBuf.create(tp: typetypeG; Sz: integer; dx:double);
begin
  BufType:=tp;
  BufSize:=Sz;
  getmem(Buf,TailleTypeG[tp]*Sz);
  fillchar(Buf^,TailleTypeG[tp]*Sz,0);

  IndexT:=-1;
  oldIndexT:=-1;
  Dxu:=dx;
end;

constructor TMultiMainBuf.createWithCybTag(tp: typetypeG; Sz: integer; dx: double);
begin
  create(tp,sz,dx);
  getMem(BufTag,maxCyberTag*Sizeof(TcybTag));
  fillchar(BufTag^,maxCyberTag*sizeof(TcybTag),0);
end;

constructor TMultiMainBuf.createWithAtt(tp: typetypeG; Sz: integer; dx:double);
begin
  create(tp,sz,dx);
  getmem(BufAtt,Sz);
  fillchar(BufAtt^,Sz,0);
end;

constructor TMultiMainBuf.createWithWaves(tp: typetypeG; Sz, nbPtSpk1: integer; dx:double);
begin
  createWithAtt(tp,sz,dx);
  nbptSpk:=nbptSpk1;
  WaveSize:=ElphySpkPacketFixedSize + nbptSpk*2;
  getmem(BufWave,WaveSize*sz);
end;

destructor TMultiMainBuf.destroy;
begin
  freemem(Buf);
  freemem(BufAtt);
  freemem(BufWave);
  freemem(BufTag);
  inherited;
end;

function TMultiMainBuf.getLong(i: integer): longint;
begin
  result:=PtabLong(Buf)^[i mod BufSize];
end;

function TMultiMainBuf.getSingle(i: integer): single;
begin
  result:=PtabSingle(Buf)^[i mod BufSize];
end;

function TMultiMainBuf.getSmall(i: integer): smallint;
begin
  result:=PtabEntier(Buf)^[i mod BufSize];
end;

function TMultiMainBuf.GetSpikeCount(tmax: double): integer;
var
  i,w:integer;
  Imax:integer;
begin
  Imax:=round(tmax/Dxu);

  { Imax est le temps relatif au début de la séquence
    Si on stocke un spike avec t>tmax , indexT reste bloqué.
  }

  OldIndexT:=IndexT;
  if (OldIndexT<index-1) and (Ptablong(buf)^[(OldIndexT+1) mod BufSize]<0) then
  begin
    inc(oldIndexT);
    inc(indexT);
  end;

  for i:=OldIndexT+1 to index-1 do
  begin
    w:=Ptablong(buf)^[i mod BufSize];
    if (w<=Imax) and (w>=0)
      then indexT:=i
      else break;
  end;

  result:=indexT-OldIndexT;
  if result<0 then result:=0;
end;

function TMultiMainBuf.ProcessSpikes(ep:integer; var indexT1,oldIndexT1:integer): integer;
var
  i,w:integer;
begin
  OldIndexT1:=IndexT1;
  if (OldIndexT1<index-1) and (Ptablong(buf)^[(OldIndexT1+1) mod BufSize]<0)  then { sauter le nombre négatif }
  begin
    inc(oldIndexT1);
    inc(IndexT1);
    inc(EpNum);
  end;

  if ep=EpNum then
  begin
    for i:=OldIndexT1+1 to index-1 do
    begin
      w:=Ptablong(buf)^[i mod BufSize];
      if w>=0
        then indexT1:=i
        else break;                {S'arrêter avant le négatif }
    end;
  end
  else indexT1:=oldIndexT1;

  result:=indexT1-OldIndexT1;
  if result<0 then result:=0;   {oldIndexT et indexT pointent sur des spikes valides}
end;


procedure TMultiMainBuf.SaveLastData(f: Tstream);
var
  n1,n2:integer;
begin
  if indexT>OldIndexT then
  begin
    n1:=(OldIndexT+1) mod BufSize;
    n2:=indexT mod BufSize;
    if n2>=n1 then
    begin
      f.Write(BufLong^[n1],(n2-n1+1)*4);
      if assigned(BufAtt) then f.Write(BufAtt^[n1],n2-n1+1);
    end
    else
      begin
        f.Write(BufLong^[n1],(BufSize-n1)*4);
        f.Write(BufLong^[0],(n2+1)*4);
        if assigned(BufAtt) then
        begin
          f.Write(BufAtt^[n1],BufSize-n1);
          f.Write(BufAtt^[0],n2+1);
        end;
      end;
  end;
end;


procedure TMultiMainBuf.SaveLastWaves(f: Tstream);
var
  n1,n2:integer;
begin
  if indexT>OldIndexT then
  begin
    n1:=(OldIndexT+1) mod BufSize;
    n2:=indexT mod BufSize;
    if n2>=n1 then
    begin
      f.Write(BufWave^[n1*waveSize],(n2-n1+1)*waveSize);
    end
    else
      begin
        f.Write(BufWave^[n1*waveSize],(BufSize-n1)*waveSize);
        f.Write(BufWave^[0],(n2+1)*waveSize);
      end;
  end;
end;




procedure TMultiMainBuf.StoreLong(w: Integer);
begin
  PtabLong(Buf)^[index mod BufSize]:=w;
  inc(index);
  if index-indexT >= BufSize div 2 then FlagFullEvt:=true;
end;

procedure TMultiMainBuf.StoreLongAtt(w: Integer; att: byte);
begin
  PtabLong(Buf)^[index mod BufSize]:=w;
  BufAtt^[index mod BufSize]:=att;
  inc(index);
end;

procedure TMultiMainBuf.StoreSingle(w: single);
begin
  PtabSingle(Buf)^[index mod BufSize]:=w;
  inc(index);
end;

procedure TMultiMainBuf.StoreSmall(w: smallint);
begin
  PtabEntier(Buf)^[index mod BufSize]:=w;
  inc(index);
end;


{ 28 avril 2010 : les champs de cbPKT_SPK on changé dans la nouvelle version de Cbwhlib
  On ignore désormais fpattern, nPeak, nValley  .
}
procedure TMultiMainBuf.StoreSpike(p: PcbPKT_SPK; w: Integer; att: byte);
var
  p1:PelphySpkPacket;
begin
  PtabLong(Buf)^[index mod BufSize]:=w;
  BufAtt^[index mod BufSize]:=att;

  if assigned(p) then
  begin
    p1:=@BufWave^[(index mod BufSize)*waveSize];
    p1^.ElphyTime:=w;

    p1^.time:=p^.time;
    p1^.chid:=p^.chid;
    p1^.unit1:=p^.unit1;

    move(p^.wave,p1^.wave,nbptSpk*2);
  end;

  inc(index);
  if index-indexT >= BufSize div 2 then FlagFullMulti:=true;

end;

function TrigString:AnsiString;
var
  i:TmodeSync;
begin
  result:=trigType[MSimmediat];
  for i:=succ(low(trigType)) to high(trigType) do
    result:=result+'|'+trigType[i];
end;

function TMultiMainBuf.getNextLong(nmax:integer;var n: integer): boolean;
begin
  n:=getLong(indexT+1);
  result:=(indexT<index) and (n>=0) and (n<=nmax) ;
  if result then inc(indexT);
end;

procedure TMultiMainBuf.NextEpisode;
begin
  while (indexT<index) and (getLong(indexT)>=0) do inc(indexT);
  if (indexT<index) and (getLong(indexT)<0) then inc(indexT);
end;


procedure TMultiMainBuf.SetInitDins(w: word);
begin
  LastW:=w;

  with BufTag^[indexTag mod maxCyberTag] do
  begin
    tt:=0;
    wt:=w;
  end;
  inc(indexTag);

end;

procedure TMultiMainBuf.SetLastDins(time, seqTime: integer);
var
  i:integer;
begin
  if time<=index then exit;
  for i:=index to time-1 do PtabEntier(buf)^[i mod BufSize]:=LastW;
  index:=time-1;

  with BufTag^[indexTag mod maxCyberTag] do
  begin
    tt:=seqTime;
    wt:=lastW;
  end;
  inc(indexTag);
end;

procedure TMultiMainBuf.StoreDins(w: word; time,SeqTime: integer);
var
  i:integer;
begin
  if time<=index then exit;

  if w<>lastW then
  begin
    with BufTag[indexTag mod maxCyberTag] do
    begin
      tt:=seqTime;
      wt:=w;
    end;
    inc(indexTag);
//    Affdebug('StoreDins='+Istr1(w,8)+'  t= '+Istr(Time),79);
  end;

  for i:=index to time-1 do PtabEntier(buf)^[i mod BufSize]:=LastW;
  PtabEntier(buf)^[time mod BufSize]:=w;
  lastW:=w;
  index:=time;
end;

procedure TMultiMainBuf.SaveLastTags(f: Tstream; Imax: integer; Const All:boolean=true);
var
  i,nb,size:integer;
  Atag:TcybTag;
  n1,n2,w:integer;
  Ind: integer;
  IstartTest:integer;
begin
  ind:=IndexTag;

  OldIndexTagT:=IndexTagT;

  // On veut garder le premier zéro mais s'arrêter au zéro suivant
  IstartTest:= OldIndexTagT+1;
  if (IstartTest<ind) and (buftag^[IstartTest mod MaxCyberTag].tt=0) then  inc(IstartTest);

  for i:=IstartTest to ind-1 do
  begin
    w:=BufTag^[i mod MaxCyberTag].tt;
    if (w<=Imax) and (w>0)
      then indexTagT:=i
      else break;
  end;

  nb:=indexTagT-OldIndexTagT;
  if nb<0 then nb:=0;

  { nb est le nb de tags à sauver }

  size:=nb*sizeof(TcybTag);
  WriteRCyberTagHeader(f,size+sizeof(TcybTag)*ord(all) ,now,false);

  if nb>0 then
  begin
    n1:=(OldIndexTagT+1) mod MaxCyberTag;
    n2:=indexTagT mod MaxCyberTag;
    if n2>=n1 then
    begin
      f.Write(BufTag^[n1],(n2-n1+1)*sizeof(TcybTag));
    end
    else
      begin
        f.Write(BufTag^[n1],(MaxCyberTag-n1)*sizeof(TcybTag));
        f.Write(BufTag^[0],(n2+1)*sizeof(TcybTag));
      end;
  end
  else n2:=indexTagT mod MaxCyberTag;

  if All then
  begin
    Atag.tt:=Imax;
    Atag.wt:=buftag^[n2].wt;   //lastW
    f.Write(Atag,sizeof(Atag));
  end;

//  Affdebug('SaveLastTags ='+ Istr1(Atag.tt,8)+'  t= '+Istr(Atag.wt),79);
end;


function TMultiMainBuf.BufTagFull: boolean;
begin
  result:= IndexTag - IndexTagT> maxCyberTag div 2;
end;


procedure TMultiMainBuf.SaveAllData(f: Tstream);
begin
  f.write(buf^,index*TailleTypeG[BufType]);
end;

{ TPCLbuf }

constructor TPCLbuf.create(nb: integer; Dxu: double);
begin
  nbrec:=nb;
  getmem(Buf,nbrec*sizeof(TPCLrecord));
  fillchar(Buf^,nbrec*sizeof(TPCLrecord),0);

  IndexT:=-1;
  oldIndexT:=-1;

  DxTime:=Dxu;
end;


function TPCLbuf.getDataPhoton(i1,i2:integer): typeDataPhotonB;
begin
  result:=TypeDataPhotonT.create(Buf,nbrec, i1,0,i2-i1 );
end;

function TPCLbuf.GetRecCount(tmax: double): integer;
var
  i:integer;
  w:double;
begin
  OldIndexT:=IndexT;
  if (OldIndexT<index-1) and (PtabPCLrecord(buf)^[(OldIndexT+1) mod nbrec].time<0) then
  begin
    inc(oldIndexT);
    inc(indexT);
  end;

  for i:=OldIndexT+1 to index-1 do
  begin
    w:=PtabPCLrecord(buf)^[i mod nbrec].time;
    if (w<=tmax) and (w>=0)
      then indexT:=i
      else break;
  end;

  result:=indexT-OldIndexT;
  if result<0 then result:=0;

end;

function TPCLbuf.GetRecCountExtra(tmax: double): integer;
var
  i:integer;
  w:double;
begin

  if (IndexT<index-1) and (PtabPCLrecord(buf)^[(IndexT+1) mod nbrec].time<0) then exit;

  OldIndexT:=IndexT;
  for i:=OldIndexT+1 to index-1 do
  begin
    w:=PtabPCLrecord(buf)^[i mod nbrec].time;
    if (w<=tmax) and (w>=0)
      then indexT:=i
      else break;
  end;

  result:=indexT-OldIndexT;
  if result<0 then result:=0;

end;

function TPCLbuf.GetRecCountPCL(tmax: double): integer;
var
  i:integer;
  w:double;
begin
  OldIndexT:=IndexT;
  while (OldIndexT<index-1) and (PtabPCLrecord(buf)^[(OldIndexT+1) mod nbrec].time>=0) do
  begin
    inc(oldIndexT);
    inc(indexT);
  end;

  if (OldIndexT<index-1) and (PtabPCLrecord(buf)^[(OldIndexT+1) mod nbrec].time<0) then
  begin
    inc(oldIndexT);
    inc(indexT);
  end;

  for i:=OldIndexT+1 to index-1 do
  begin
    w:=PtabPCLrecord(buf)^[i mod nbrec].time;
    if (w<=tmax) and (w>=0)
      then indexT:=i
      else break;
  end;

  result:=indexT-OldIndexT;
  if result<0 then result:=0;

end;


function TPCLbuf.NbAvailable:integer;
begin
  result:=index-indexT;
end;

procedure TPCLbuf.saveLastData(f: Tstream);
var
  n1,n2:integer;
begin
  if indexT>OldIndexT then
  begin
    n1:=(OldIndexT+1) mod nbrec;
    n2:=indexT mod nbrec;
    if n2>=n1 then
    begin
      f.Write(PtabPCLrecord(buf)^[n1],(n2-n1+1)*sizeof(TPCLrecord));
    end
    else
      begin
        f.Write(PtabPCLrecord(buf)^[n1],(nbrec-n1)*sizeof(TPCLrecord));
        f.Write(PtabPCLrecord(buf)^[0],(n2+1)*sizeof(TPCLrecord));
      end;
  end;
end;


procedure TPCLbuf.storeRec(tt1:float;x1,y1:integer;const z1:integer=0); // tt1 en secondes
begin
  if tt1>=0 then tt1:=tt1*DxTime;                    // Le temps est stocké en secondes ou millisecondes
  with PtabPCLrecord(buf)^[index mod nbrec] do
  begin
    time:=tt1;
    x:=x1;
    y:=y1;
    z:=z1;
  end;
  inc(index);

  affdebug(' storeRec '+Estr1(tt1,10,3) ,82);
end;

end.


