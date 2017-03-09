unit RTneuronBrd;

interface
{$IFDEF FPC} {$mode delphi} {$DEFINE AcqElphy2} {$A1} {$Z1} {$ENDIF}

uses windows,classes,
     util1,varconf1,
     debug0,
     stmdef,stmObj,AcqBrd1,
     dataGeneFile,FdefDac2,
     Ncdef2, ntx, RTcom2, RTdef0,
     acqCom1, AcqInterfaces,
     acqDef2,acqInf2,StimInf2,
     stmvec1;



{ Driver RT neuron + NI 6251


}

{ TRTneuron contient les paramètres de la carte d'acquisition tels qu'ils sont saisis par l'utilisateur
}
type
  { Si l'on veut garder la compatibilité, il ne faut pas modifier TRchannel et TRTdigiChannel.
    On peut seulement allonger TRTparams (Exemple: DacEndValue ).
  }

  TRTChannel = object
                    jru1,jru2:integer;
                    yru1,yru2:single;
                    SymbName:string[64];
                    unitY:string[10];
                    procedure default;
                    function dyu:float;
                    function y0u:float;
                  end;

  TRTdigiChannel = object
                     SymbName:string[64];
                     IsInput:boolean;
                   end;

  TRTparams = object
                  AdcChan:array[0..15] of TRTChannel;
                  DacChan:array[0..1] of TRTchannel;
                  DigiChan:array[0..7] of TRTdigiChannel;
                  FadvanceON:boolean;
                  DacEndValue: array[0..1] of double;
                  UseEndValue: array[0..1] of boolean;
                  CurNum:integer;                      { Permet de transmettre le numéro de canal }
                  BaseInt: integer;
                  AImode: integer;
                  procedure Defaults;
                  function nbAdc:integer;
                  function nbDac:integer;
                  function nbDin:integer;
                  function nbDout:integer;
                end;

  PRTparams=^TRTparams;

var
  {Les paramètres sont déclarés en dehors de TRTNIinterface afin de pouvoir les charger alors que
   l'objet n'est pas encore créé
  }
  RTparams0: PRTparams;
  RTparamsSize:integer;

type
  TRTNIinterface = class(TacqInterface)
   protected
      status:integer;
      StatusStep:integer;
      LastErrorStatus:integer;
      stError:AnsiString;

      HasTag:boolean;

      GItrig:integer;
      FlagStopProg:boolean;

      recInfo: TRTrecInfo;
      FlagRestart:boolean;

      function getCount:integer;override;
      function getCount2:integer;override;

      procedure doContinuous;
      procedure doInterne;
      procedure doProgram;

      procedure TransferAg; virtual;
      procedure readAg;     virtual;
      function StopError(n: integer):boolean;

      procedure storeDACRT(x:single);

      function execute(st: AnsiString): boolean; virtual;
      procedure getTestData( Vnb,Vt:Tvector);    virtual;
      procedure getTestData2( Vnb,Vt:Tvector);    virtual;

      function getNrnValue(st:string):float;     virtual;
      function getNrnStepDuration:float;         virtual;

      function GetAcqBufferAd:pointer;    virtual;
      function GetAcqBufferSize:integer;  virtual;

      function GetStimBufferAd:pointer;   virtual;
      function GetStimBufferSize:integer; virtual;


   public
      stExeFile:AnsiString; {  'D:\VSprojects\nrnVS6\rtdebug\NrnRT1.rta'; }
      stBinFile:AnsiString; {  'D:\nrn60-RT2\bin\nrn.exe'; }
      stHocFile:AnsiString; {  'D:\nrn60-RT2\lib\hoc\nrngui.hoc'; }

      NIbusNumber:integer;
      NIdeviceNumber:integer;

      RTparams: PRTparams;
      StartFlag:boolean;  { True après le chargement du fichier RTA
                            Doit être mis à false par l'utilisateur }

      constructor create(var st1:driverString);override;
      destructor destroy;override;

      procedure init0;override;
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

      procedure GetOptions;override;

      procedure initcfgOptions(conf:TblocConf);override;

      function TagMode:TtagMode;override;
      function tagShift:integer;override;
      function TagCount:integer;override;

      function getMinADC:integer;override;
      function getMaxADC:integer;override;


      function nbVoieAcq(n:integer):integer;override;

      procedure setVSoptions;override;

      function getNrnSymbolNames(cat:integer):TstringList;override;
      procedure GetPeriods(PeriodU: float; nbADC,nbDI,nbDAC,nbDO: integer;var periodIn,periodOut: float);override;

      procedure setDoAcq(var procInt:ProcedureOfObject);override;
      function PhysicalOutputString:AnsiString;override;
      procedure GetPhysicalInfo(num:integer;var tp:ToutputType; var Outnum:integer;var BitNum:integer);override;

      procedure loadDmaDac;
      procedure ReLoadDmaDac;

      function RTmode:boolean;override;
      function HasDigInputs:boolean;

      procedure RestartNeuron;virtual;
      procedure BuildInfo(var conf:TblocConf;lecture:boolean);override;

      procedure RTNeuronDialog;

      procedure FillRTrecInfo;
      procedure installRTrecInfo;
      procedure ProgRestart;override;

      procedure ShowRTconsole;override;
    end;





function fonctionTRTchannel_Dy(var pu:TRTchannel):float;pascal;
function fonctionTRTchannel_y0(var pu:TRTchannel):float;pascal;

procedure proTRTchannel_unitY(w:AnsiString;var pu:TRTchannel);pascal;
function fonctionTRTchannel_unitY(var pu:TRTchannel):AnsiString;pascal;

procedure proTRTchannel_setScale(j1,j2:integer;y1,y2:float;var pu:TRTchannel);pascal;

function fonctionTRTchannel_NrnSymbolName(var pu:TRTchannel):AnsiString;pascal;
procedure proTRTchannel_NrnSymbolName(w:AnsiString;var pu:TRTchannel);pascal;

function fonctionTRTchannel_HoldingValue(var pu:TRTchannel):float;pascal;
procedure proTRTchannel_HoldingValue(w:float;var pu:TRTchannel);pascal;

function fonctionTRTchannel_UseHoldingValue(var pu:TRTchannel):boolean;pascal;
procedure proTRTchannel_UseHoldingValue(w:boolean;var pu:TRTchannel);pascal;


function fonctionTRTdigiChannel_NrnSymbolName(var pu:TRTdigichannel):AnsiString;pascal;
procedure proTRTdigiChannel_NrnSymbolName(w:AnsiString;var pu:TRTdigichannel);pascal;
function fonctionTRTdigiChannel_IsInput(var pu:TRTdigiChannel):boolean;pascal;
procedure proTRTdigiChannel_IsInput(w:boolean;var pu:TRTdigiChannel);pascal;

function fonctionRTneuron:pointer;pascal;
procedure proTRTneuron_execute(st:AnsiString;var pu:typeUO);pascal;
procedure proTRTneuron_getTestData(var Vnb,Vt:Tvector;var pu:typeUO);pascal;
procedure proTRTneuron_getTestData2(var Vnb,Vt:Tvector;var pu:typeUO);pascal;

function fonctionTRTneuron_getNrnValue(st:AnsiString;var pu:typeUO):float;pascal;
function fonctionTRTneuron_getNrnStepDuration(var pu:typeUO):float;pascal;

procedure proTRTneuron_resetParams(var pu:typeUO);pascal;
procedure proTRTneuron_ReStart(var pu:typeUO);pascal;

function fonctionTRTNeuron_StartFlag(var pu:typeUO):boolean;pascal;
procedure proTRTNeuron_StartFlag(w:boolean;var pu:typeUO);pascal;

function fonctionTRTneuron_AdcChan(n:integer;var pu:typeUO):pointer;pascal;
function fonctionTRTneuron_DacChan(n:integer;var pu:typeUO):pointer;pascal;
function fonctionTRTneuron_DigiChan(n:integer;var pu:typeUO):pointer;pascal;

function fonctionTRTNeuron_FadvanceON(var pu:typeUO):boolean;pascal;
procedure proTRTNeuron_FadvanceON(w:boolean;var pu:typeUO);pascal;

function fonctionTRTNeuron_BaseClockInt(var pu:typeUO):integer;pascal;
procedure proTRTNeuron_BaseClockInt(w:integer;var pu:typeUO);pascal;


implementation

uses NIRToptions, NIRTdlg1;

{ TRTChannel }

function TRTChannel.dyu: float;
begin
  if jru1<>jru2
    then result:=(Yru2-Yru1)/(jru2-jru1)
    else result:=1;
end;

function TRTChannel.y0u: float;
var
  dyB:float;
begin
  if jru1<>jru2
    then dyB:=(Yru2-Yru1)/(jru2-jru1)
    else dyB:=1;

    result:=Yru1-Jru1*DyB;
end;

procedure TRTchannel.default;
begin
  jru1:=0;
  jru2:=32767;
  yru1:=0;
  yru2:=10000;
  SymbName:='';
  unitY:='mV';

end;

{ TRTneuron }

procedure TRTparams.Defaults;
var
  i:integer;
begin
  for i:=0 to 15 do AdcChan[i].default;
  for i:=0 to 1 do DacChan[i].default;
  for i:=0 to 7 do DigiChan[i].SymbName:='';
  for i:=0 to 7 do DigiChan[i].IsInput:= false;
  FadvanceON:=true;
  for i:=0 to 1 do DacEndValue[i]:=0;
  for i:=0 to 1 do UseEndValue[i]:=false;
  BaseInt:=0;
  AImode:=1;
end;

function TRTparams.nbAdc:integer;
var
  i:integer;
begin
  result:=0;
  for i:=0 to 15 do
  if ADCchan[i].SymbName<>'' then inc(result);
end;

function TRTparams.nbDac:integer;
var
  i:integer;
begin
  result:=0;
  for i:=0 to 1 do
  if DACchan[i].SymbName<>'' then inc(result);
end;


function TRTparams.nbDin: integer;
var
  i:integer;
begin
  result:=0;
  for i:=0 to 7 do
  if (DigiChan[i].SymbName<>'') and DigiChan[i].IsInput then inc(result);
end;


function TRTparams.nbDout: integer;
var
  i:integer;
begin
  result:=0;
  for i:=0 to 7 do
  if (DigiChan[i].SymbName<>'') and not DigiChan[i].IsInput then inc(result);
end;



procedure initRTNIBoards;
begin
  if initNtxDll then RegisterBoard('RT-Neuron NI Mseries',pointer(TRTNIinterface));
end;




var
  JHold1RT:array[0..31] of single;



{ TRTNIinterface }

constructor TRTNIinterface.create(var st1: driverString);
begin
  inherited;

  BoardFileName:='NI-RT';

  stExeFile:=''; {'D:\VSprojects\nrnVS6\rtdebug\NrnRT1.rta';}
  stBinFile:=''; {'D:\nrn60-RT2\bin\nrn.exe'; }
  stHocFile:='';  {'D:\nrn60-RT2\lib\hoc\nrngui.hoc'; }

  if RTparams0=nil then
  begin
    new(RTparams0);
    RTparamsSize:=sizeof(RTparams0^);
    RTparams0^.defaults;
  end;
  RTparams:=RTparams0;
  LoadOptions;

  StartWinEmul(stExeFile,stBinFile,stHocFile);
  StartFlag:=true;
end;

destructor TRTNIinterface.destroy;
begin
  StopWinEmul;

  inherited;
end;


function TRTNIinterface.dacFormat: TdacFormat;
begin
  result:=DacF1322;
end;

function TRTNIinterface.dataFormat: TdataFormat;
begin
  result:=F16bits
end;




function TRTNIinterface.gainLabel: AnsiString;
begin
  result:='';
end;

function TRTNIinterface.getCount: integer;
begin
  result:=RTcom2.GetCount;
end;

function TRTNIinterface.getCount2: integer;
begin
  result:=(getCount div AcqInf.nbVoieAcq-1) * paramStim.ActiveChannels;
end;

function TRTNIinterface.getMaxADC: integer;
begin
  result:=32767
end;

function TRTNIinterface.getMinADC: integer;
begin
  result:=-32767
end;

procedure TRTNIinterface.GetOptions;
begin
  NIRTopt.execution(self);

end;

function TRTNIinterface.inADC(n: integer): smallint;
begin
  result:=0;
end;

function TRTNIinterface.inDIO(dev,port:integer): integer;
begin
  result:=0;
end;

procedure TRTNIinterface.initcfgOptions(conf: TblocConf);
begin
  with conf do
  begin
    setvarconf('UseTagStart',FuseTagStart,sizeof(FuseTagStart));
    setStringConf('ExeFile',stExeFile);
    setStringConf('BinFile',stBinFile);
    setStringConf('HocFile',stHocFile);

    setvarconf('NIbus',NIbusNumber,sizeof(NIbusNumber));
    setvarconf('NIdevice',NIdeviceNumber,sizeof(NIdeviceNumber));
  end;
end;




procedure TRTNIinterface.FillRTrecInfo;
var
  i:integer;
  ag:integer;
begin
  fillchar(recInfo,sizeof(recinfo),0);

  {Remplir RecInfo}
  with recInfo do
  begin
    SampleInt:= round(AcqInf.periodeParVoieMS*1000) ;
    BaseInt:= RTparams.BaseInt;
    AImode:=  RTparams.AImode;

    {ELPHY ACQ}
    NbAcq:= AcqInf.Qnbvoie;
    for i:=1 to nbAcq do setNrnName(AcqSymb[i], AcqInf.NrnAcqName[i-1]);

    {ELPHY TAG}
    NbTag:=0;
    for i:=1 to 16 do
    if AcqInf.NrnTagName[i]<>'' then
    begin
      inc(NbTag);
      setNrnName(TagSymb[NbTag], AcqInf.NrnTagName[i]);
      TagNum[NbTag]:=i-1;
    end;

    {ELPHY STIM}
    if AcqInf.Fstim then
    begin
      NbStim:=paramstim.nbNRN;
      for i:=1 to NbStim do setNrnName(StimSymb[i], paramstim.NrnName[i]^);
    end
    else NbStim:=0;

    {Board ADC }
    nbAdc:=0;
    for i:=0 to 15 do
    if RTparams.AdcChan[i].SymbName<>'' then
    begin
      inc(nbAdc);
      AdcNum[nbAdc]:=i;
      setNrnName(AdcSymb[nbAdc], RTparams.AdcChan[i].SymbName);
      Dyu[nbAdc]:=RTparams.AdcChan[i].dyu;
      Y0u[nbAdc]:=RTparams.AdcChan[i].Y0u;
    end;

    {Board DAC }
    nbDac:=0;
    for i:=0 to 1 do
    if RTparams.DacChan[i].SymbName<>'' then
    begin
      inc(nbDac);
      DacNum[nbDac]:=i;
      setNrnName(DacSymb[nbDac] , RTparams.DacChan[i].SymbName);
      DacDyu[nbDac]:=RTparams.DacChan[i].dyu;
      DacY0u[nbDac]:=RTparams.DacChan[i].Y0u;
      DacEnd[nbDac]:=RTparams.DacEndValue[i];
      UseDacEnd[nbDac]:=RTparams.UseEndValue[i];

    end;

    {Board DIO }
    nbDin:=0;
    nbDout:=0;
    for i:=0 to 7 do
    if RTparams.DigiChan[i].SymbName<>'' then
    begin
      if RTparams.DigiChan[i].IsInput then
      begin
        inc(nbDin);
        DinNum[nbDin]:=i;
        setNrnName(DinSymb[nbDin] , RTparams.DigiChan[i].SymbName);
      end
      else
      begin
        inc(nbDout);
        DoutNum[nbDout]:=i;
        setNrnName(DoutSymb[nbDout], RTparams.DigiChan[i].SymbName);
      end;
    end;

    FNeuron:=RTparams.FadvanceON;

    HasTag:= recInfo.NbTag>0;
    ag:=4*(recInfo.nbAcq+ ord(HasTag) ); { La taille de l'agrégat dans le buffer DMA est différente de celle
                                           de l'agrégat dans le buffer principal }

    AcqSize:=getAcqBufferSize div ag* ag;
    if NbStim>0
      then StimSize:= 60000 div (4*NbStim)*(4*NbStim)
      else StimSize:= 60000;

    NIbusNumber:=self.NIbusNumber;
    NIdeviceNumber:=self.NIdeviceNumber;
  end;
end;

procedure TRTNIinterface.installRTrecInfo;
begin
  FillRTrecInfo;
  setRTrecInfo(recInfo);
end;

procedure TRTNIinterface.init0;
begin
  GItrig:=0;
end;

procedure TRTNIinterface.init;
begin
  InstallRTrecInfo;

  nbVoie:=AcqInf.nbVoieAcq;

  tabDMA1:=getAcqBufferAd;
  nbpt0DMA:= recInfo.AcqSize div 2;

  tabDMA2:=getStimBufferAd;
  FnbptDacDMA:=recInfo.StimSize div 4;

  InitPadc;

  GI1:=-1;

  GI1x:=-1;

  cntStim:=0;
  cntStoreDac:=0;

  PtabDac0:=tabDMA2;
  PtabDacFin:=tabDMA2;
  inc(intG(PtabDacFin),recInfo.StimSize);
  PtabDac:=tabDMA2;

  loadDmaDAC;
  FlagRestart:=false;
end;


procedure TRTNIinterface.loadDmaDac;
var
  i,j,k,index:integer;
  isiStim1,nbptStim:integer;
  nbdac:integer;

begin
  if not acqInf.Fstim then exit;

  if (AcqInf.ModeSynchro in [MSinterne,MSimmediat,MSprogram]) and
      not (acqInf.waitmode)
    then isiStim1:=paramStim.IsiPts
    else isiStim1:=maxEntierLong;

  nbptStim:=paramStim.nbpt1;
  nbdac:=paramStim.ActiveChannels;

  initPmainDacRT;

  if acqInf.continu then
    for i:=0 to nbptDACDMA-1000 do storeDacRT(nextSampleDacRT)
  else
    for i:=0 to nbptDACDMA-1000 do
     begin
       j:=i mod nbdac;
       k:=i mod isiStim1;
       if (k>=0) and (k<nbptStim)
         then Jhold1RT[j]:=nextSampleDacRT;
       storeDacRT(Jhold1RT[j]);
     end;

//  SaveArrayAsDac2File('d:\delphe5\tab.dat',tabDma2^,NbPtDacDMA,1,g_single);
end;


procedure TRTNIinterface.ReloadDmaDac;
begin
end;


procedure TRTNIinterface.lancer;
begin
  //FlagStop:=true;
  //FlagStopPanic:=true;

  status:=StartRT;
  if StopError(101) then exit;

//  FlagStopPanic:=true;
end;

procedure TRTNIinterface.terminer;
begin
  status:= StopRT;
  if StopError(102) then exit;
end;


function TRTNIinterface.MultiGain: boolean;
begin
  result:=false;
end;

function TRTNIinterface.nbGain: integer;
begin
  result:=1;
end;

function TRTNIinterface.nbVoieAcq(n: integer): integer;
begin
  result:=n + ord(FuseTagStart and HasDigInputs);
end;


procedure TRTNIinterface.outdac(num, j: word);
begin

end;

function TRTNIinterface.outDIO(dev,port,value: integer): integer;
begin

end;

function TRTNIinterface.PeriodeElem: float;
begin
  result:=1;
end;

function TRTNIinterface.PeriodeMini: float;
begin
  result:=5;
end;


function TRTNIinterface.RAngeString: AnsiString;
begin
  result:='-10 to +10 Volts|-5 to +5 Volts|-2.5 to +2.5 Volts|-1.25 to +1.25 Volts';
end;



procedure TRTNIinterface.setVSoptions;
begin
  inherited;

end;

function TRTNIinterface.TagCount: integer;
begin
  result:=8;
end;

function TRTNIinterface.TagMode: TtagMode;
begin
  if HasDigInputs
    then result:= tmITC
    else result:=tmNone;
end;

function TRTNIinterface.tagShift: integer;
begin
  result:=0;
end;

{La procédure appelante doit libérer la stringList obtenue }
function TRTNIinterface.getNrnSymbolNames(cat: integer): TstringList;
begin
  result:=getSymList(cat,1000);
end;

procedure TRTNIinterface.GetPeriods(PeriodU: float; nbADC,nbDI,nbDAC,nbDO: integer;var periodIn,periodOut: float);
var
  p:float;
begin
  {En mode Burst, nbADC n'intervient pas }
  {periodU est la période par canal souhaitée}

  p:=periodU*1000;                      { période souhaitée en microsecondes}
  p:=round(p/periodeElem)*periodeElem;  { doit être un multiple de periodeElem }
  if p<periodeMini then p:=periodeMini; { doit être supérieure à periodeMini }
  periodIn:=p/1000;                     { période calculée en millisecondes }
  periodOut:=periodIn;
end;


procedure TRTNIinterface.setDoAcq(var procInt: ProcedureOfObject);
begin
  with acqInf do
  begin
    if continu then
    begin
      ProcInt:=DoContinuous;
    end
    else
      case AcqInf.modeSynchro of
        MSinterne,MSimmediat: ProcInt:=doInterne;

        MSprogram: Procint:=doProgram;
        else ProcInt:=nil;
      end;
  end;

end;

procedure TRTNIinterface.doContinuous;
var
  i:integer;

begin
  GI2:=getCount-1;

  for i:=GI1+1 to GI2 do
    if i mod nbvoie=nbvoie-1
      then transferAg;

  GI1:=GI2;

  if withStim then
  begin
    GI2x:=getCount2;
    for i:=GI1x+1 to GI2x do storeDacRT(nextSampleDacRT);
    GI1x:=GI2x;
  end;

end;



procedure TRTNIinterface.doInterne;
var
  k,index,ideb:integer;
  i,j:integer;

const
  flag:boolean=false;

begin
  GI2:=getCount-1;

  for i:=GI1+1 to GI2 do
  if (i+1) mod nbvoie=0 then
  begin
    k:=i mod isi;
    if (k>=0) and (k<nbpt) and ((i+1) mod nbvoie=0)
      then transferAg
      else readAg;
  end;

  if withStim then
    begin
      GI2x:=getCount2;

      for i:=GI1x+1 to GI2x do
        begin
          j:=cntStoreDac mod nbdac;
          k:= cntStoreDac mod isiStim;
          if (k>=0) and (k<nbptStim) then Jhold1RT[j]:=nextSampleDacRT;
          storeDacRT(Jhold1RT[j]);
        end;

      GI1x:=GI2x;
    end;

  GI1:=GI2;
end;

procedure TRTNIinterface.doProgram;
var
  k,index,ideb:integer;
  i,j:integer;
  nbptA:integer;
  kprog:integer;

begin
  nbptA:=nbpt div nbvoie;

  if FlagRestart then
  begin
    setRTflagStim(false);

    PtabDac:=PtabDac0;
    baseindex:=0;
    cntStim:=0;
    loadDMAdac;


    setPstimOffset(0);
    setRTflagStim(true);

    GI2:=getCount div nbvoie-1;
    for i:=GI1+1 to GI2 do readAG;

    GItrig:= GI2+1;
    FlagRestart:=false;
  end
  else
  begin
    GI2:=getCount div nbvoie-1;
    for i:=GI1+1 to GI2 do
    begin
      kprog:=i-GItrig;

      if (kprog>=0) and (kprog<nbptA) then
      begin
        transferAg;

        if withStim then
          for j:=0 to nbDac-1 do Jhold1RT[j]:=nextSampleDacRT;

        inc(kprog);
      end
      else readAg;


      if WithStim then
        for j:=0 to nbDac-1 do storeDacRT(Jhold1RT[j]);
     end;
  end;
  GI1:=GI2;


end;


procedure TRTNIinterface.storeDACRT(x:single);
var
  w:single absolute x;
begin
  Psingle(PtabDac)^:=x;
  inc(intG(PtabDac),4);
  if intG(PtabDac)>=intG(PtabDacFin) then PtabDac:=PtabDac0;
  inc(cntStoreDac);
  //affdebug('store '+Estr(w,3),78);
end;

procedure TRTNIinterface.TransferAg;
var
  i:integer;
begin
  if not HasTag then
  begin
    for i:=1 to nbvoie do
    begin
      move(Ptab^,Pmain^,4);
      inc(intG(Ptab),4);
      inc(intG(Pmain),4);
    end;
  end
  else
  begin
    for i:=1 to nbvoie-1 do
    begin
      move(Ptab^,Pmain^,4);
      inc(intG(Ptab),4);
      inc(intG(Pmain),4);
    end;

    move(Ptab^,Pmain^,2);
    inc(intG(Ptab),4);
    inc(intG(Pmain),2);
  end;

  if intG(Ptab)>=intG(PtabFin) then Ptab:=Ptab0;
  if intG(Pmain)>=intG(PmainFin) then Pmain:=Pmain0;

  inc(cntDisp,nbvoie);

end;


procedure TRTNIinterface.ReadAg;
begin
  inc(intG(Ptab),4*nbvoie);
  if intG(Ptab)>=intG(PtabFin) then Ptab:=Ptab0;
end;



function TRTNIinterface.PhysicalOutputString: AnsiString;
begin
  result:='None |Analog 0 |Analog 1 |Digi0|'+
          'Digi0-Bit0|Digi0-Bit1|Digi0-Bit2|Digi0-Bit3|Digi0-Bit4|Digi0-Bit5|Digi0-Bit6|Digi0-Bit7';
end;


procedure TRTNIinterface.GetPhysicalInfo(num: integer;var tp: ToutputType; var Outnum, BitNum: integer);
begin
  case num of
    1,2: begin
           tp:=TO_analog;
           Outnum:=num-1;
         end;
    3:   begin
           tp:=TO_digi8;
           Outnum:=0;
         end;

    4..11:
         begin
           tp:=TO_digibit;
           OutNum:=0;
           BitNum:=num-4;
         end;
    else begin
           byte(tp):=255;
           OutNum:=0;
           BitNum:=0;
         end;
  end;
end;

function TRTNIinterface.StopError(n: integer):boolean;
var
  errBuf:array[0..2047] of char;
  st:AnsiString;

begin
  result:=(status<>0);
  if result and (LastErrorStatus=0) then
  begin
    statusStep:=n;
    LastErrorStatus:=status;
    FlagStop:=true;
    FlagStopPanic:=true;
    stError:='RT error Step='+Istr(StatusStep);
  end;
end;


function TRTNIinterface.RTmode:boolean;
begin
  result:=true;
end;


function TRTNIinterface.HasDigInputs: boolean;
var
  i:integer;
begin
  result:=false;
  for i:=1 to 16 do
    if AcqInf.NrnTagName[i]<>'' then result:=true;
end;

procedure TRTNIinterface.RestartNeuron;
begin
  StopWinEmul;

  if stExeFile='' then loadOptions;
  StartWinEmul(stExeFile,stBinFile,stHocFile);
  StartFlag:=true;
end;


procedure TRTNIinterface.BuildInfo(var conf: TblocConf; lecture: boolean);
begin

end;


procedure TRTNIinterface.RTNeuronDialog;
begin
  NIRTparams.execute(RTparams^);
end;


function TRTNIinterface.execute(st: AnsiString): boolean;
begin
  result:= RTcom2.sendTextCommand(st, 2000);
end;

procedure TRTNIinterface.getTestData( Vnb,Vt:Tvector);
begin
  RTcom2.getTestData(Vnb,Vt);
end;

procedure TRTNIinterface.getTestData2( Vnb,Vt:Tvector);
begin
  RTcom2.getTestData2(Vnb,Vt);
end;

function TRTNIinterface.getNrnValue(st:string):float;
begin
   result:=RTcom2.getNrnValue(st);
end;

function TRTNIinterface.getNrnStepDuration:float;
begin
  InstallRTrecInfo;
  result:=RTcom2.getNrnStepDuration;
end;

function TRTNIinterface.GetAcqBufferAd: pointer;
begin
  result:=RTcom2.GetAcqBufferAd;
end;

function TRTNIinterface.GetAcqBufferSize: integer;
begin
  result:=RTcom2.GetAcqBufferSize;
end;

function TRTNIinterface.GetStimBufferAd: pointer;
begin
  result:=RTcom2.GetStimBufferAd;
end;

function TRTNIinterface.GetStimBufferSize: integer;
begin
  result:=RTcom2.GetStimBufferSize;
end;


{****************************** TRTneuron *******************************}

function fonctionRTneuron:pointer;
begin
  if (board is TRTNIinterface)
    then result:=@board
    else result:=nil;
end;

procedure proTRTneuron_execute(st:AnsiString;var pu:typeUO);
begin
  verifierObjet(pu);
  with TRTNIinterface(pu) do
    if not execute(st) then sortieErreur('RTneuron unable to execute '+'"'+st+'"') ;
end;

procedure proTRTneuron_getTestData(var Vnb,Vt:Tvector;var pu:typeUO);
begin
  verifierObjet(pu);
  verifierVecteurTemp(Vnb);
  verifierVecteurTemp(Vt);

  TRTNIinterface(pu).getTestData(Vnb,Vt);
end;

procedure proTRTneuron_getTestData2(var Vnb,Vt:Tvector;var pu:typeUO);
begin
  verifierObjet(pu);
  verifierVecteurTemp(Vnb);
  verifierVecteurTemp(Vt);

  TRTNIinterface(pu).getTestData2(Vnb,Vt);
end;

function fonctionTRTneuron_getNrnValue(st:AnsiString; var pu:typeUO):float;
begin
  verifierObjet(pu);
  result:=TRTNIinterface(pu).getNrnValue(st);
end;

function fonctionTRTneuron_getNrnStepDuration(var pu:typeUO):float;
begin
  verifierObjet(pu);
  result:=TRTNIinterface(pu).GetNrnStepDuration;
end;



function fonctionTRTneuron_AdcChan(n:integer;var pu:typeUO):pointer;
begin
  verifierObjet(pu);
  with TRTNIinterface(pu).RTparams^ do
  begin
    if (n<0) or (n>15) then sortieErreur('TRTneuron.AdcChan : index out of range');
    curNum:=n;
    result:=@AdcChan[n];
  end;

end;

function fonctionTRTneuron_DacChan(n:integer;var pu:typeUO):pointer;
begin
  verifierObjet(pu);
  with TRTNIinterface(pu).RTparams^ do
  begin
    if (n<0) or (n>1) then sortieErreur('TRTneuron.AdcChan : index out of range');
    curNum:=n;
    result:=@DacChan[n];
  end;
end;

function fonctionTRTneuron_DigiChan(n:integer;var pu:typeUO):pointer;
begin
  verifierObjet(pu);
  with TRTNIinterface(pu).RTparams^ do
  begin
    curnum:=n;
    if (n<0) or (n>7) then sortieErreur('TRTneuron.DigiChan : index out of range');
    result:=@DigiChan[n];
  end;
end;


function fonctionTRTchannel_Dy(var pu:TRTchannel):float;
begin
  with pu do
  begin
    if jru1<>jru2
    then result:=(Yru2-Yru1)/(jru2-jru1)
    else result:=1;
  end;
end;


function fonctionTRTchannel_y0(var pu:TRTchannel):float;
var
  dyB:float;
begin
  with pu do
  begin
    if jru1<>jru2
      then DyB:=(Yru2-Yru1)/(jru2-jru1)
      else DyB:=1;
    result:=Yru1-Jru1*DyB;
  end;
end;

procedure proTRTchannel_unitY(w:AnsiString;var pu:TRTchannel);
begin
  pu.unitY:=w;
end;

function fonctionTRTchannel_unitY(var pu:TRTchannel):AnsiString;
begin
  result:=pu.unitY;
end;

procedure proTRTchannel_setScale(j1,j2:integer;y1,y2:float;var pu:TRTchannel);
begin
  if (j1=j2) then sortieErreur('TRTchannel_setScale : invalid parameter' );

  with pu do
  begin
    jru1:=j1;
    jru2:=j2;
    Yru1:=y1;
    Yru2:=y2;
  end;
end;

function fonctionTRTchannel_NrnSymbolName(var pu:TRTchannel):AnsiString;
begin
  result:=pu.SymbName;
end;

procedure proTRTchannel_NrnSymbolName(w:AnsiString;var pu:TRTchannel);
begin
  pu.SymbName:=w;
end;

function fonctionTRTchannel_HoldingValue(var pu:TRTchannel):float;
begin
  with RTparams0^ do              { On utilise RTparams0 : pas très propre ! }
    result:=DacEndValue[curNum];
end;

procedure proTRTchannel_HoldingValue(w:float;var pu:TRTchannel);
begin
  with RTparams0^ do              { On utilise RTparams0 : pas très propre ! }
    DacEndValue[curNum]:=w;
end;

function fonctionTRTchannel_UseHoldingValue(var pu:TRTchannel):boolean;
begin
  with RTparams0^ do              { On utilise RTparams0 : pas très propre ! }
    result:=UseEndValue[curNum];
end;


procedure proTRTchannel_UseHoldingValue(w:boolean;var pu:TRTchannel);
begin
  with RTparams0^ do              { On utilise RTparams0 : pas très propre ! }
    UseEndValue[curNum]:=w;
end;

procedure proTRTneuron_resetParams(var pu:typeUO);
var
  i:integer;
begin
  verifierObjet(pu);
  with TRTNIinterface(pu).RTparams^ do
  begin
    Defaults;
  end;
end;




function fonctionTRTdigiChannel_NrnSymbolName(var pu:TRTdigichannel):AnsiString;
begin
  result:=pu.SymbName;
end;

procedure proTRTdigiChannel_NrnSymbolName(w:AnsiString;var pu:TRTdigichannel);
begin
  pu.SymbName:=w;
end;

function fonctionTRTdigiChannel_IsInput(var pu:TRTdigiChannel):boolean;
begin
  result:=pu.IsInput;
end;

procedure proTRTdigiChannel_IsInput(w:boolean;var pu:TRTdigiChannel);
begin
  pu.IsInput:=w;
end;

procedure proTRTneuron_ReStart(var pu:typeUO);
begin
  verifierObjet(pu);
  TRTNIinterface(pu).ReStartNeuron;
end;

function fonctionTRTNeuron_StartFlag(var pu:typeUO):boolean;
begin
  verifierObjet(pu);
  result:=TRTNIinterface(pu).StartFlag;
end;

procedure proTRTNeuron_StartFlag(w:boolean;var pu:typeUO);
begin
  verifierObjet(pu);
  TRTNIinterface(pu).StartFlag := w;
end;

function fonctionTRTNeuron_FadvanceON(var pu:typeUO):boolean;
begin
  verifierObjet(pu);
  result:= TRTNIinterface(pu).RTparams^.FadvanceON;
end;

procedure proTRTNeuron_FadvanceON(w:boolean;var pu:typeUO);
begin
  verifierObjet(pu);
  TRTNIinterface(pu).RTparams^.FadvanceON := w;
end;


procedure TRTNIinterface.ProgRestart;
begin
  if acqinf.ModeSynchro=msProgram then FlagRestart:=true;

end;

procedure TRTNIinterface.ShowRTconsole;
begin
  RTconsole.Show;
end;

function fonctionTRTNeuron_BaseClockInt(var pu:typeUO):integer;
begin
  verifierObjet(pu);
  result:=TRTNIinterface(pu).RTparams^.BaseInt;
end;

procedure proTRTNeuron_BaseClockInt(w:integer;var pu:typeUO);
begin
  verifierObjet(pu);
  TRTNIinterface(pu).RTparams^.BaseInt := w;
end;


initialization
Affdebug('Initialization RTneuronBrd',0);
initRTNIBoards;

end.
