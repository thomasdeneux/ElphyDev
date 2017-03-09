unit AcqDef1;

INTERFACE
{$IFDEF FPC} {$mode delphi} {$DEFINE AcqElphy2} {$A1} {$Z1} {$ENDIF}

uses windows,classes,forms,graphics,controls,
     util1,Ddosfich,debug0,clock0,stmdef,syncObjs,dtf0,

     acqBrd1;


var
  FmultiMainBuf:boolean;                           { Toujours false dans Elphy }
  MultiMainBuf : array of PtabEntier;              { Inutilisé }

  MultiMainBufSize:array of integer;               { taille de chaque buffer en nombre d'échantillons }
  MultiMainBufType:array of typetypeG;             { type de chaque buffer }

  MultiMainBufIndex: array of integer;


type
  TdataFileFormat=(Dac2format,ElphyFormat1,ABFformat);

const

  DriverAcqOK:boolean=false;


  mainBuf:ptabEntier=nil;{ adresse du buffer principal }
  mainBufSize:integer=0; { sa taille en octets }

  mainDACbuf:PtabEntier=nil;
  mainDACsize:integer=0;

var
  nbpt0:integer;         { nombre de points (words) du buffer principal }

  nbptDAC:integer;       { nombre de points (words) du buffer DAC principal }

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

  BaseIndex:integer;     {Indice de la prochaine stimulation dans mainDACbuf
                          Mis à zéro par initVarAcq;
                         }

type
  TmodeSync=(MSimmediat,MSclavier,MSanalogAbs,MsAnalogDiff,
             MSnumPlus,MSnumMoins,MSinterne);

const
  TrigType:array[TmodeSync] of string=
    ('Immediate','Keyboard','Analog absolute','Analog differential',
    'Numerical (rising edge)','Numerical (falling edge)','Internal');
type
  {AcqInf de type TacqRecord contient tous les paramètres d'acquisition. AcqInf est
  destiné à l'enregistrement sur disque de tous ces paramètres
  }

  {TinputType est repris dans Elphy2}
  TinputType=(TI_analog,TI_anaEvent,TI_Digi8,TI_digi16,TI_digiBit,TI_digiEvent, TI_Neuron );

  TacqRecord=object
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
               ChannelType:array[1..16] of TinputType;    {0 .. 1}
               EvtHysteresis:array[1..16] of single;
               FRising:array[1..16] of boolean;

               procedure init;

               function periodeParVoieMS:float;  {Période en millisecondes. La référence }

               function dureeSeq:float;
               function dureeSeqApres:float;

               function periodeUS:float; { période  en microsecondes }
               function periodeVS(base:float):float; { période en ms pour stimVS}

               function periodeParVoie:float;
                   { période  par voie en unités réelles: ms ou sec}

               function PeriodOutOfRAnge:boolean;

               function nbVoieAcq:integer;  { Nombre de voies rangées dans MainBuf}
               function nbVoieEvt:integer;  { nombre de voies Evt }

               function Dxu:float;
               function x0u:float;
               function Dyu(v:integer):float;
               function y0u(v:integer):float;
               function unitX:string;

               function Xend:float;
               function maxPts:integer;

               function IsiPts:integer;

               function getSeuilPlusPts:integer;
               function getSeuilMoinsPts:integer;
               procedure setSeuilPlusPts(n:integer);
               procedure setSeuilMoinsPts(n:integer);

               property SeuilPlusPts:integer read getSeuilPlusPts write setSeuilPlusPts;
               property SeuilMoinsPts:integer read getSeuilMoinsPts write setSeuilMoinsPts;


               function Qnbpt1:integer;

               procedure initEvtParams;

               procedure controle;
               function getInfo:string;

               function MaxAdcSamples:integer;
               function immediateDisplay:boolean;

               function SampleSize(n:integer):integer;
               function SampleOffset(n:integer):integer;
               function AgTotSize:integer;
               function ChannelNumType(n:integer):typetypeG;
             end;

  PacqRecord=^TacqRecord;

  {
  StepStim: pas de mise à jour de mainDACbuf pendant l'acquisition
            pas d'incrément de BaseIndex

            Une seule séquence dans mainDACbuf est remplie par programme avec
              Stimulator.clearBuffers
              Stimulator.setDacVectorParams
              Stimulator.setDigiVectorParams
              Stimulator.setDacVector
              Stimulator.setDigiVector

            LoadDmaDac remplit DacDMA avec une seule séquence suivie de Jhold

  WaitMode: Un flag est positionné à la fin du process pour autoriser le démarrage de
            la séquence suivante

            En mode MSInterne + WaitMode, on utilise un timer pour lancer la
            séquence suivante
            La routine d'int est alors doNumPlusStim

  }


  TacqRecordF=object
                stGenAcq:String;
                stDat:String;
                stEvt:string;
                stGenHis:string;

                procedure init;
                function verifierGen:boolean;
              end;

var
  AcqInf:TacqRecord;
  AcqInfF:TacqRecordF;

const
  UacqInf:PacqRecord=@AcqInf;

var
  AcqComment:string; {ne sert que pour la sauvegarde}

type
  typeSegmentAna=record
                   mode:byte;
                   duree,amp,incAmp,incDuree,Vinit,Vfinale:single;
                   rep1,rep2:word;
                 end;

  typeSortieAna=record
                  seg:array[1..20] of typeSegmentAna;
                  Jru1,Jru2:integer;
                  Yru1,Yru2:single;
                  unitY:string[10];
                  active:boolean;
                end;

  typePulseNum= record
                  date,duree,incDate,incDuree:single;
                  rep1,rep2:word;
                end;

  typeSortieNum=record
                  mode:byte;
                  pulse:array[1..20] of typePulseNum;
                  largeurPulse,cadencePulse,cadenceSalve:single;
                  NbSalve, NbPulse:integer;
                  DelaiTrain: single;
                end;

  {Format de paramStim avant le 2 juillet 2002}
  TparamStimOld=      record
                        id:string[15];
                        tailleInfo:Integer;

                        sAna:array[0..1] of typeSortieAna;

                        SNum:array[0..7] of typeSortieNum;

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

  {Format de ParamStim après le 2 juillet 2002}
  {Passage à 16 bits pour les sorties DIO }

  TParamStim=         object
                        id:string[15];
                        tailleInfo:Integer;

                        sAna:array[0..1] of typeSortieAna;

                        SNum:array[0..15] of typeSortieNum;

                        DigiActive:boolean;
                        SetByProgU:boolean;
                        SetByProgP:boolean;

                        procedure Init;
                        function ActiveChannels:integer;
                        function Dyu(v:integer):float;
                        function y0u(v:integer):float;

                        function dxu:float;
                        function x0u:float;

                        function nbpt:integer;
                        function nbpt1:integer;
                        function unitX:string;
                        function nbav:integer;

                        function periodeParDac:float;{période en ms}
                        function periodeUSstim:float;{periode globale en microsecondes}
                        function periodeGlobaleStim:float; {période en ms ou sec}

                        function Isi:float;
                        function IsiPts:integer;

                        function setByProg:boolean;

                        function stimDuration:float;

                        Procedure OldToNew(var p:TparamStimOld);
                        {Conversion d'un ancien paramStim en nouveau}

                        function nbDigi:integer;
                        function nbDac:integer;
                     end;

  PparamStim=^TparamStim;

  TDisplayParamStim= object
                       colorAna:array[0..1] of integer;
                       Xmin,Xmax:single;
                       Ymin,Ymax:array[0..1] of single;

                       DispAna:array[0..1] of boolean;

                       DispDigi:boolean;
                       procedure init;
                     end;

var
  paramStimOld:TparamStimOld;
  paramStim:TParamStim;
const
  UparamStim:PparamStim=@paramStim;

var
  DisplayParamStim:TDisplayParamStim;


var
  AcqDriver1:string[30];

  count2:integer;
  ADCMaxSample:integer;


const
  maxEvtTab=2000;

type
  TElphyEvt1=array of integer;
  TElphyEvtTab=array of TElphyEvt1;

  TelphyIsEvt=array of boolean;

var
  EvtTab:array[0..1] of TElphyEvtTab;

  IevtTab,IevtTabOld:array[0..15] of integer;

  FUpEvt:array[0..15] of boolean;

implementation

uses acqCom1;


{************************* Méthodes de TacqRecord **************************}

procedure TacqRecord.init;
var
  i:integer;
begin
  continu:=true;
  Qnbvoie:=1;
  Qnbpt:=1000;
  Qnbav:=0;
  DureeSeqU:=1000;
  periodeCont:=1;

  ModeSynchro:=MSinterne;
  voieSynchro:=0;
  seuilPlus:=0;
  seuilMoins:=0;
  IntervalTest:=2;

  for i:=1 to 16 do
    begin
      unitY[i]:='mV';
      jru1[i]:=0;
      jru2[i]:=2048;
      yru1[i]:=0;
      yru2[i]:=10000;
      QvoieAcq[i]:=i-1;
      Qgain[i]:=1;
      QKS[i]:=1;

      EvtThreshold[i]:=0;
      EvtHysteresis[i]:=0;
      ChannelType[i]:=TI_analog;

      Frising[i]:=true;
    end;


  IsiSec:=1;
  Fstim:=false;


end;


{Période par voie en millisecondes
 C'est la référence pour toutes les durées. On propose periodeCont et
 la carte indique ce qu'elle peut faire.
 }
function TacqRecord.periodeParVoieMS:float;
var
  p,pIn,pOut:float;
begin
  if continu then p:=periodeCont
  else
  if Qnbpt>0 then p:=dureeSeqU/Qnbpt
  else p:=1;

  if assigned(board) then
  begin
    board.GetPeriods(p,Qnbvoie,0,paramStim.nbDac,paramstim.nbDigi,pIn,pOut);
    result:=pIn;
  end
  else result:=1;
end;


function TacqRecord.nbVoieAcq:integer;
begin
  if assigned(board)
    then result:=board.nbVoieAcq(Qnbvoie)
    else result:=Qnbvoie;
end;

function TacqRecord.nbVoieEvt:integer;
var
  i:integer;
begin
  if DFformat=ElphyFormat1 then
    begin
      result:=0;
      for i:=1 to Qnbvoie do
        if ChannelType[i] in [TI_AnaEvent,TI_digiEvent] then inc(result);
    end
  else result:=0;
end;


function TacqRecord.DureeSeq:float;
begin
  result:=periodeParVoieMS*Qnbpt;
end;

function TacqRecord.DureeSeqApres:float;
var
  p:float;
begin
  result:=periodeParVoieMS*(Qnbpt-QnbAv);
end;


function TacqRecord.periodeUS:float;
begin
  result:=periodeParVoieMS/nbvoieAcq*1000;
end;

function TacqRecord.periodeVS(base:float):float;
var
  pIn,pOut:float;
begin
  if assigned(board) then
  begin
    board.GetPeriods(base,Qnbvoie,0,paramStim.nbDac,paramstim.nbDigi,pIn,pout);
    result:=pIn;
  end
  else result:=1;
end;

function TacqRecord.periodeParVoie:float;
begin
  if continu
    then result:=periodeParVoieMS/1000
    else result:=periodeParVoieMS;
end;

function TacqRecord.PeriodOutOfRAnge:boolean;
begin
  result:=assigned(board) and (periodeUS<board.periodeMini);
end;

function TacqRecord.Dxu:float;
begin
  Dxu:=periodeParVoie;
end;

function TacqRecord.x0u:float;
begin
  x0u:=0;
end;

function TacqRecord.Dyu(v:integer):float;
begin
  if jru1[v]<>jru2[v]
    then result:=(Yru2[v]-Yru1[v])/(jru2[v]-jru1[v])
    else result:=1;


  if assigned(board) then
    result:=result*board.GcalibAdc(v);
end;

function TacqRecord.y0u(v:integer):float;
var
  dyB:float;
begin
  if jru1[v]<>jru2[v]
    then dyB:=(Yru2[v]-Yru1[v])/(jru2[v]-jru1[v])
    else dyB:=1;

  result:=Yru1[v]-Jru1[v]*DyB;

  if assigned(board) then
    result:=result+DyB*board.OFFcalibAdc(v);
end;

function TacqRecord.unitX:string;
begin
  if continu
    then unitX:='sec'
    else unitX:='ms';
end;

function TacqRecord.Xend:float;
begin
  if continu
    then result:=1
    else result:=periodeParVoieMS*(Qnbpt-1);
end;

function TacqRecord.maxPts:integer;
begin
  if continu
    then result:=0
    else result:=Qnbpt;
end;


function TacqRecord.IsiPts:integer;
var
  w:float;
begin
  w:=periodeUS;
  if (w>0) and not continu and (modeSynchro in [MSinterne,MSimmediat]) and (maxEpCount<>1)
    then result:=roundL(paramStim.isi*1000000/w)
    else result:=1000000;
end;

function TacqRecord.getSeuilPlusPts:integer;
begin
  case modeSynchro of
    MSanalogAbs: result:=roundI((seuilPlus-Y0u(voieSynchro))/Dyu(voieSynchro));
    MSanalogDiff:result:=roundI(seuilPlus/Dyu(voieSynchro));
    else result:=0;
  end;
end;

procedure TacqRecord.setSeuilPlusPts(n:integer);
begin
  case modeSynchro of
    MSanalogAbs: seuilPlus:=n*Dyu(voieSynchro)+Y0u(voieSynchro);
    MSanalogDiff:seuilPlus:=n*Dyu(voieSynchro);
  end;

  seuilP:=n;
end;

function TacqRecord.getSeuilMoinsPts:integer;
begin
  case modeSynchro of
    MSanalogAbs: result:=roundI((seuilMoins-Y0u(voieSynchro))/Dyu(voieSynchro));
    MSanalogDiff:result:=roundI(seuilMoins/Dyu(voieSynchro));
    else result:=0;
  end;
end;

procedure TacqRecord.setSeuilMoinsPts(n:integer);
begin
  case modeSynchro of
    MSanalogAbs: seuilMoins:=n*Dyu(voieSynchro)+Y0u(voieSynchro);
    MSanalogDiff:seuilMoins:=n*Dyu(voieSynchro);
  end;

  seuilM:=n;
end;


function TacqRecord.Qnbpt1:integer;
begin
  if continu
    then result:=maxEntierLong
    else result:=Qnbpt*Qnbvoie;
end;


procedure TacqRecord.initEvtParams;
begin
end;

procedure TacqRecordF.init;
begin
  stGenAcq:='DATA';
  stDat:='';
  {comment:='';}
end;

function TacqRecordF.verifierGen:boolean;
var
  chemin,nom,num,ext:string;
  ok:boolean;
begin
  stGenAcq:=FsupespaceDebut(stGenAcq);
  stGenAcq:=FsupespaceFin(stGenAcq);

  stGenAcq:=Fmaj(stGenAcq);
  DecomposerNomFichier(stGenAcq,chemin,nom,num,ext);
  if nom='' then nom:='DATA'
  else
  if nom[1]='$' then nom:=copy(nom,1,2);
  stGenAcq:=chemin+copy(nom,1,5);
  if (length(chemin)>0) and (chemin[length(chemin)]='\')
    then delete(chemin,length(chemin),1);
  ok:= repertoireExiste(chemin);

  result:=ok;
end;

procedure TacqRecord.controle;
var
  i:integer;
begin
   if (Qnbvoie<1) or (Qnbvoie>16) then Qnbvoie:=1;
   if (Qnbpt<1) then Qnbpt:=1000;
   if (Qnbav<0) or (Qnbav>Qnbpt) then Qnbav:=0;
   if DureeSeqU<0.001 then DureeSeqU:=1000;
   if periodeCont<0.001 then periodeCont:=1;

   if (ModeSynchro<msImmediat) or (ModeSynchro>msInterne)
     then ModeSynchro:=msInterne;
   if (voieSynchro<1) or (voieSynchro>16) then voieSynchro:=1;

   if (IntervalTest<1) or (IntervalTest>1000) then IntervalTest:=2;

   for i:=1 to 16 do
     begin
       if (jru1[i]=jru2[i]) or (yru1[i]=yru2[i]) then
         begin
           jru1[i]:=0;
           jru2[i]:=2048;

           yru1[i]:=0;
           yru2[i]:=10000;
         end;

       if (QvoieAcq[i]<0) or (QvoieAcq[i]>15) then QvoieAcq[i]:=i-1;
       if assigned(board) then
         if (Qgain[i]<1) or (Qgain[i]>board.nbGain) then Qgain[i]:=1;
     end;


   if maxEpCount<0 then maxEpCount:=0;
   if maxDuration<0 then maxDuration:=0;

   if FileInfoSize<0 then FileInfoSize:=0;
   if EpInfoSize<0 then EpInfoSize:=0;
end;

function TacqRecord.getInfo:string;
var
  i:integer;
begin
  result:=
  'Continuous='+Bstr(continu)+CRLF+
  'Channel count='+Istr(Qnbvoie)+CRLF+
  'Samples per channel='+Istr(Qnbpt)+CRLF+
  'Samples before trigger='+Istr(Qnbav)+CRLF+
  'Episode duration='+Estr(DureeSeqU,3)+CRLF+
  'Period per channel='+Estr(periodeCont,6)+CRLF+
  'Trigger mode='+trigtype[ModeSynchro]+CRLF+
  'Sync. channel='+Istr(voieSynchro)+CRLF+
  'Upper threshold='+Estr(seuilPlus,3)+CRLF+
  'Lower threshold='+Estr(seuilMoins,3)+CRLF+
  'Test interval='+Istr(IntervalTest)+CRLF;

  for i:=1 to Qnbvoie do
    result:=result+'Scaling factors ch'+Istr(i)+'='
                   +Istr(jru1[i])+'('+Estr(yru1[i],3)+' '+unitY[i]+')'+' '+
                    Istr(jru2[i])+'('+Estr(yru2[i],3)+' '+unitY[i]+')'+CRLF;

  result:=result+'Physical channels=';
  for i:=1 to Qnbvoie do result:=result+Istr(QvoieAcq[i])+' ';
  result:=result+CRLF;
  result:=result+'Gains=';
  for i:=1 to Qnbvoie do result:=result+Istr(Qgain[i])+' ';
  result:=result+CRLF;

   {            Fdisplay:boolean;
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


               EvtInput:array[1..16] of byte;
               EvtOn:array[1..16] of boolean;
               EvtThreshold:array[1..16] of single;
               EvtGain:array[1..16] of byte;

               maxEpCount:integer;
               maxDuration:single;

               FileInfoSize:integer;
               EpInfoSize:integer;
               MiniCommentSize:integer;

               bid1:boolean;

               TrigDelay: single;

               bid2:array[1..42] of boolean; 

               FControlPanel:boolean;
               FtriggerPos:boolean;
               WaitMode:boolean;
  }

end;

function TacqRecord.MaxAdcSamples:integer;
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
        then result:=maxEp*Qnbpt*Qnbvoie-1
        else result:=maxEntierLong;
    end;

end;

function TacqRecord.immediateDisplay:boolean;
begin
  result:=Continu or Fimmediate and (dureeSeqU>200);
end;

function TacqRecord.AgTotSize: integer;
begin
  result:=2*nbvoieAcq;
end;

function TacqRecord.SampleSize(n:integer):integer;
begin
  result:=2;
end;

function TacqRecord.SampleOffset(n:integer):integer;
var
  i:integer;
begin
  result:=2*(n-1);
end;

function TacqRecord.ChannelNumType(n:integer):typetypeG;
begin
  result:=G_smallint;
end;

{************************* Méthodes de TparamStim *************************}

procedure TparamStim.init;
var
  i,j:integer;
begin

  id:='ELPHYSTIM';             {Remplace DAC2STIM}
  tailleInfo:=sizeof(TparamStim);

  fillchar(sana,sizeof(sana),0);
  fillchar(snum,sizeof(snum),0);

  for i:=0 to 1 do
    with sana[i] do
    begin
      Jru2:=2048;
      Yru2:=10000;
      unitY:='mV';
      active:=true;
    end;

    DigiActive:=true;
    SetByProgU:=false;
    SetByProgP:=false;

end;

function TparamStim.ActiveChannels:integer;
begin
  if sana[1].active
    then result:=2
    else result:=1;

  if assigned(board) and (board.DacFormat=dacF1322) and digiActive then inc(result);
end;

function TparamStim.Dyu(v:integer):float;
begin
  with sana[v] do
  if jru1<>jru2
    then Dyu:=(Yru2-Yru1)/(jru2-jru1)
    else Dyu:=1;

  if assigned(board) then
    result:=result*board.GcalibDac(v);

end;

function TparamStim.y0u(v:integer):float;
var
  dyB:float;
begin
  with sana[v] do
  begin
    if jru1<>jru2
      then DyB:=(Yru2-Yru1)/(jru2-jru1)
      else DyB:=1;

    y0u:=Yru1-Jru1*DyB;

    if assigned(board) then
      result:=result+DyB*board.OFFcalibDac(v);
  end;
end;


function TparamStim.dxu:float;
begin
  if acqInf.continu
    then result:=PeriodeParDac/1000
    else result:=PeriodeParDac;
end;

function TparamStim.x0u:float;
begin
  if acqInf.modeSynchro in [MSinterne,MSimmediat]
    then result:=0
    else result:=dxu/ActiveChannels;
end;


function TparamStim.stimDuration:float;
begin
  if acqInf.modeSynchro=MSnumPlus
    then result:=acqInf.dureeSeqApres
    else result:=acqInf.dureeSeq;
end;

function TparamStim.nbpt:integer;
begin
  {En continu,nbpt1 donne la taille d'une pseudo-séquence}
  if AcqInf.continu then
    begin
      result:=round(200/periodeParDac);
      if result<100 then result:=100;
    end
  else result:=roundL(stimDuration/periodeGlobaleStim/ActiveChannels);
end;

function TparamStim.nbpt1:integer;
begin
  result:=nbpt*ActiveChannels;
end;

function TparamStim.nbav:integer;
begin
  result:=roundL((acqInf.dureeSeq-acqInf.dureeSeqApres)/periodeGlobaleStim/ActiveChannels);
end;


function TparamStim.unitX:string;
begin
  if AcqInf.continu then unitX:='sec' else unitX:='ms';
end;

function TparamStim.periodeParDac:float;
begin
  result:=periodeUSstim*ActiveChannels/1000;
end;

function TparamStim.periodeUSstim:float;
var
  pIn,pOut:float;
begin
  if assigned(board) then
  begin
    board.GetPeriods(acqInf.periodeParVoieMS,acqInf.nbVoieAcq,0,nbDAC,nbDigi,pIn,pOut);
    result:=pOut;
    {Période par voie en ms}
  end
  else result:=1;

  result:=result*1000/ActiveChannels;
  {Entourloupe provisoire pour ne pas modifier davantage Elphy
   Le futur, c'est Elphy2
  }

  {
  result:=acqInf.periodeUS;
  if assigned(board) and board.SimultaneousDAC then result:=result/ActiveChannels;
  }
end;


function TparamStim.periodeGlobaleStim:float;
begin
  if AcqInf.continu
    then result:=periodeUSstim/1E6
    else result:=periodeUSstim/1000;
end;

function TparamStim.isi:float;
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

function TparamStim.isiPts:integer;
begin
  result:=roundL(isi*1000000/periodeUSstim);
  if acqInf.maxEpCount=1 then result:=result+10000;
end;


function TparamStim.setByProg:boolean;
begin
  result:=setByProgU or setByProgP;
end;

Procedure TparamStim.OldToNew(var p:TparamStimOld);
var
  i:integer;
begin
  init;
  id:=p.id;
  for i:=0 to 1 do
    sAna[i]:=p.Sana[i];

  for i:=0 to 7 do
    SNum[i]:=p.Snum[i];

  DigiActive:=p.DigiActive;
  SetByProgU:=p.SetByProgU;
  SetByProgP:=false;
end;

{********************* Méthodes de TDisplayParamStim *************************}

procedure TDisplayParamStim.init;
begin
  colorAna[0]:=clYellow;
  colorAna[1]:=clBlue;

  Xmin:=0;
  Xmax:=1000;

  Ymin[0]:=-1000;
  Ymax[0]:=1000;

  Ymin[1]:=-1000;
  Ymax[1]:=1000;

end;


function TParamStim.nbDigi: integer;
begin
  if AcqInf.Fstim
    then result:=ord(digiActive)
    else result:=0;
end;

function TParamStim.nbDac: integer;
begin
  if AcqInf.Fstim
    then result:=1+ ord(sana[1].active)
    else result:=0;
end;



Initialization
AffDebug('Initialization AcqDef1',0);

setLength(evtTab[0],16);
setLength(evtTab[1],16);


end.
