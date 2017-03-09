unit SimRTneuronBrd;

interface
{$IFDEF FPC} {$mode delphi} {$DEFINE AcqElphy2} {$A1} {$Z1} {$ENDIF}

uses windows,classes, sysutils, forms,
     util1,varconf1,
     debug0,
     stmdef,stmObj,AcqBrd1,
     dataGeneFile,FdefDac2,
     Ncdef2,  RTdef0,
     acqCom1, AcqInterfaces, RTneuronBrd,
     acqDef2,acqInf2,StimInf2,
     stmvec1;



{ Driver Simulation RT neuron

}


type

  TRTNIsimInterface = class(TRTNIinterface)
    private

      hMapFile: Thandle;
      hEvent: Thandle;
      pBuf: PcomBuffer;

      processInfo:TprocessInformation;
      FlagErrorDLL, FlagQuitDLL, FlagTimeOut: boolean;

    protected
      time0:integer;
      pms:float;            {Période globale en millisecondes }


      function getCount:integer;override;

      function execute(st: AnsiString): boolean; override;
      procedure getTestData( Vnb,Vt:Tvector);    override;
      function getNrnValue(st:string):float;     override;
      function getNrnStepDuration:float;         override;

      function GetAcqBufferAd:pointer;    override;
      function GetAcqBufferSize:integer;  override;

      function GetStimBufferAd:pointer;   override;
      function GetStimBufferSize:integer; override;

      function ProcessAg:boolean;
      procedure doContinuous;
      procedure doInterne;
      procedure doProgram;

      procedure setDoAcq(var procInt:ProcedureOfObject);override;
      procedure InitAcqNrnPointer;


    public
      constructor create(var st1:driverString);override;
      destructor destroy;override;

      procedure init0;override;
      procedure init;override;
      procedure lancer;override;
      procedure terminer;override;


      procedure initcfgOptions(conf:TblocConf);override;


      function getNrnSymbolNames(cat:integer):TstringList;override;


      procedure loadDmaDac;
      procedure ReLoadDmaDac;

      procedure RestartNeuron;override;
      procedure BuildInfo(var conf:TblocConf;lecture:boolean);override;


      procedure installRTrecInfo;

      procedure ShowRTconsole;override;

      procedure initNrnDLL;
      procedure DoneNrnDll;

      function Gnrn_val_pointer(p: Pansichar): Pdouble;
      procedure Gnrn_fixed_step;

      function WaitCommand(n:integer): boolean;
      function GetSymList(code: integer):boolean;
      procedure NrnSendString(const st: ShortString);

      procedure DisplayErrorMsg;override;
    end;


implementation

uses NIRToptions, NIRTdlg1, evalvar1;

Const
  ComDelay0=1000;


procedure initRTNIsimBoards;
begin
  RegisterBoard('RT-Neuron Simulation',pointer(TRTNIsimInterface));
end;




var
  JHold1RT:array[0..31] of single;



{ TRTNIsimInterface }

constructor TRTNIsimInterface.create(var st1: driverString);
var
  i:integer;
begin
  BoardFileName:='NI-RT-Sim';

  if RTparams0=nil then
  begin
    new(RTparams0);
    RTparamsSize:=sizeof(RTparams0^);
    RTparams0^.defaults;
  end;
  RTparams:=RTparams0;
  LoadOptions;

  InitNrnDLL;

  StartFlag:=true;
end;

destructor TRTNIsimInterface.destroy;
begin
   DoneNrnDll;
end;



function TRTNIsimInterface.getCount: integer;
begin
   result:=roundL((getTickCount-time0)/pms);
end;


procedure TRTNIsimInterface.initcfgOptions(conf: TblocConf);
begin
  inherited;
end;



procedure TRTNIsimInterface.installRTrecInfo;
begin
  fillRTrecInfo;
  Pbuf^.rec:= recInfo;
end;

procedure TRTNIsimInterface.init0;
begin
//  GItrig:=0;
end;

procedure TRTNIsimInterface.init;
begin
  pms:=AcqInf.periodeUS/1000;

  InstallRTrecInfo;

  nbVoie:=AcqInf.nbVoieAcq;

  InitPadc;
  InitAcqNrnPointer;

  GI1:=-1;

  GI1x:=-1;

  cntStim:=0;
  cntStoreDac:=0;

  loadDmaDAC;
  FlagRestart:=false;
end;


procedure TRTNIsimInterface.loadDmaDac;
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


//  SaveArrayAsDac2File('d:\delphe5\tab.dat',tabDma2^,NbPtDacDMA,1,g_single);
end;


procedure TRTNIsimInterface.ReloadDmaDac;
begin
end;


procedure TRTNIsimInterface.lancer;
begin
  time0:=getTickCount;
  //status:=StartRT;
  if StopError(101) then exit;

end;

procedure TRTNIsimInterface.terminer;
begin
  //status:= StopRT;
  if StopError(102) then exit;
end;





{La procédure appelante doit libérer la stringList obtenue }
function TRTNIsimInterface.getNrnSymbolNames(cat: integer): TstringList;
var
  buf:PtabOctet;
  nmax:integer;
  p:integer;  // pointeur de lecture

function PopInt:integer;
begin
  result:=Plongint(@buf[p])^;
  inc(p,4);
end;

function PopString: AnsiString;
var
  nb:integer;
begin
  nb:=Plongint(@buf[p])^;
  inc(p,4);

  setLength(result,nb);
  move(buf[p],result[1],nb);
  inc(p,nb);
end;

procedure getStL(stL:TstringList;RootName:AnsiString);
var
  i,nb:integer;
  st:AnsiString;
begin
  nb:=PopInt;
  stL.AddObject(RootName,pointer(nb));

  for i:=1 to nb do
  begin
    st:=PopString;
    if (length(st)>0) and (st[length(st)]='.')
      then getStL(stL,st)
      else stL.Add(st);
  end;
end;

begin
  result:=TstringList.create;
  if getSymList(cat) then
  begin
    buf:=@Pbuf^.data;
    p:=0;
    getStL(result,'Root');
  end;
end;






procedure TRTNIsimInterface.RestartNeuron;
begin
  NrnSendString('quit()');
  WaitCommand(0);
  doneNrnDLL;
  InitNrnDLL;
  StartFlag:=true;
end;


procedure TRTNIsimInterface.BuildInfo(var conf: TblocConf; lecture: boolean);
begin

end;


function TRTNIsimInterface.execute(st: AnsiString): boolean;
begin
  NrnSendString(st);
  result:=true;
end;

function TRTNIsimInterface.GetAcqBufferAd: pointer;
begin
  result:=nil;
end;

function TRTNIsimInterface.GetAcqBufferSize: integer;
begin
  result:=0;
end;

function TRTNIsimInterface.getNrnStepDuration: float;
begin
  result:=0;
end;

function TRTNIsimInterface.getNrnValue(st: string): float;
var
  p: Pdouble;
begin
  if WaitCommand(0) then
  begin
    st:=st+#0;
    move(st[1], pBuf^.data,length(st));
    pBuf^.command:=nc_getNrnValue;
    setEvent(hEvent);
    WaitCommand(0);
    result:=pBuf^.Dresult;
  end
  else result:=0;
end;

function TRTNIsimInterface.GetStimBufferAd: pointer;
begin
  result:=nil;
end;

function TRTNIsimInterface.GetStimBufferSize: integer;
begin
  result:=0;
end;

procedure TRTNIsimInterface.getTestData(Vnb, Vt: Tvector);
begin
  inherited;

end;


function TRTNIsimInterface.ProcessAg: boolean;
var
  i:integer;
  DIOvalue:word;
begin
  result:=true;

  for i:=1 to recInfo.NbStim do
    Pbuf^.OutBuffer[i]:= NextSampleDacRT;

  if WaitCommand(0) then
  begin
    pBuf^.command:=nc_ProcessAg;
    setEvent(hEvent);
    WaitCommand(0);
  end;

  if FlagErrorDLL or FlagQuitDLL or FlagTimeOut then
  begin
    result:=false;
    exit;
  end;

  for i:=1 to nbvoie-ord(HasTag) do
  begin
    PSingle(Pmain)^:=Pbuf^.InBuffer[i];
    inc(intG(Pmain),4);
  end;

  if HasTag then
  begin
    Pword(Pmain)^:= Pbuf^.TagBuffer;
    inc(intG(Pmain),2);
  end;

  if intG(Pmain)>=intG(PmainFin) then Pmain:=Pmain0;

  inc(cntDisp,nbvoie);


end;


procedure TRTNIsimInterface.doContinuous;
var
  i,j:integer;

begin
  GI2:=getCount-1;

  for i:=GI1+1 to GI2 do
    if i mod nbvoie=nbvoie-1 then
    begin
      if not ProcessAg then
      begin
        FlagStop:=true;
        FlagStopPanic:=true;
        exit;
      end;

    end;
  GI1:=GI2;

end;

procedure TRTNIsimInterface.doInterne;
begin

end;

procedure TRTNIsimInterface.doProgram;
begin

end;

procedure TRTNIsimInterface.setDoAcq(var procInt: ProcedureOfObject);
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


var
  DumVar:array[1..50] of double;
  NdumVar:integer;


procedure TRTNIsimInterface.InitAcqNrnPointer;
begin
  if WaitCommand(0) then
  begin
    pBuf^.command:=nc_initAcqNrnPointer;
    setEvent(hEvent);
    WaitCommand(0);
  end;
end;

procedure TRTNIsimInterface.ShowRTconsole;
begin
  WaitCommand(0);
  pbuf^.command:=nc_ShowConsole;
  setEvent(hEvent);

end;

procedure TRTNIsimInterface.initNrnDLL;
var
  
  startUp:TstartUpInfo;
  flags:Dword;
  st1,st2: String;
  stBin, stHoc: string;
  i:integer;
begin
  stBin:=FsupespaceDebutEtFin(stBinFile);
  for i:=1 to length(stBin) do
  if stBin[i]='\' then stBin[i]:='/';


  stHoc:=FsupespaceDebutEtFin(stHocFile);
  if stHoc<>'' then
  begin
    for i:=1 to length(stHoc) do
      if stHoc[i]='\' then stHoc[i]:='/';
  end;

  hMapFile := CreateFileMapping(
                 INVALID_HANDLE_VALUE,    // use paging file
                 Nil,                     // default security
                 PAGE_READWRITE,          // read/write access
                 0,                       // maximum object size (high-order DWORD)
                 sizeof(TcomBuffer),      // maximum object size (low-order DWORD)
                 stDrvBuffer);         // name of mapping object

  if hMapFile = 0 then exit;
  pBuf := MapViewOfFile(hMapFile,   // handle to map object
                        FILE_MAP_ALL_ACCESS, // read/write permission
                        0,
                        0,
                        sizeof(TcomBuffer));

  if pBuf = Nil then
  begin
    CloseHandle(hMapFile);
    exit;
  end;

  hEvent:= CreateEvent(nil,false,false, stDrvEvent );

  flags:=0;
  fillchar(startUp,sizeof(startUp),0);
  startUp.cb:=sizeof(startUp);

  st1:= AppDir+'NrnDrv2.exe';
  st2:= st1+' '+stBin+' '+stHoc;
  if not createProcess(Pchar(st1),PChar(st2),nil,nil,false,Flags,nil,nil,startUp,processInfo)  then exit;

end;

procedure TRTNIsimInterface.doneNrnDll;
begin
//  NrnSendString('quit()');
  TerminateProcess(processInfo.hProcess,0);

  if WaitForSingleObjectEx(processInfo.hprocess,1000,false)=WAIT_TIMEOUT
    then messageCentral('Please, kill the Neuron process then press OK ');


  UnmapViewOfFile(pBuf);
  pBuf:=nil;
  CloseHandle(hMapFile);
  hMapFile:=0;
  CloseHandle(hEvent);
  hEvent:=0;

end;

function TRTNIsimInterface.WaitCommand(n:integer): boolean;
var
  tick0:integer;
begin
  tick0:=getTickCount;
  repeat
    FlagErrorDLL:=(pBuf^.command=nc_DLLerror);
    FlagQuitDLL:= (pBuf^.command=nc_DLLQuit);
    FlagTimeOut:= (getTickCount-tick0>ComDelay0)
  until (pBuf^.command=n) or FlagErrorDLL or FlagQuitDLL  or FlagTimeOut;
  result:= (pBuf^.command=n);
end;


function TRTNIsimInterface.GetSymList(code: integer): boolean;
begin
  result:=false;
  if WaitCommand(0) then
  begin
    pBuf^.command:=nc_GetSymList;
    Pinteger(@pBuf^.data)^:=code;
    setEvent(hEvent);

    if not WaitCommand(0) then exit;
    result:=true;
  end;
end;

procedure TRTNIsimInterface.Gnrn_fixed_step;
begin

end;

function TRTNIsimInterface.Gnrn_val_pointer(p: Pansichar): Pdouble;
begin

end;

procedure TRTNIsimInterface.NrnSendString(Const st: ShortString);
begin
  if WaitCommand(0) then
  begin
    move(st,pBuf^.data,length(st)+1);
    pBuf^.command:=nc_SendString;
    setEvent(hEvent);
  end;
end;

procedure TRTNIsimInterface.DisplayErrorMsg;
begin
  if FlagQuitDLL then messageCentral('User has closed NEURON')
  else
  if FlagErrorDLL then messageCentral('Error In NEURON')
  else
  if FlagTimeOut then messageCentral('NEURON TimeOut Error');

end;

initialization
Affdebug('Initialization RTneuronBrd',0);
initRTNIsimBoards;

end.
