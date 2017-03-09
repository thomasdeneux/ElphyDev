unit stmNI;

interface

uses math, sysutils,
     util1, stmdef, stmObj,NcDef2,stmPG,
     NIdaqmx0, NiBrd1,
     stmvec1 ;


type
  TNIchanType = (NI_type_AO,
                 NI_type_DO,
                 NI_type_AI,
                 NI_type_DI,
                 NI_type_Counter
                 );
type
  TNIinterface = class(typeUO)
               devName: Ansistring;
               taskHandle: TtaskHandle;
               AuxTaskHandle: TtaskHandle;

               UseAO: boolean;
               AuxNum:integer;
               ChanType: TNIchanType;
               vec: Tvector;
               Dy,y0: float;

               idleState: integer;
               initialDelay: double;
               lowTime: double;
               highTime: double;
               FrepeatPulse: boolean;
               OldCounterOut: AnsiString;

               PhysNum:integer;
               BitNum:integer;
               OutNum:Integer;
               rate:float;
               status:integer;
               stError: Ansistring;
               ContinuousMode:boolean;
               unitY:Ansistring;

               stClock: AnsiString;  // ajouté le 28 08 16

               constructor create;override;
               destructor destroy;override;

               procedure setChildNames;override;

               function StopError(const n:integer=0):boolean;
               procedure StopTask;
               procedure setAnalogOutput(physnum1:integer; PeriodeMS:float; durationMS:float; Fcont:boolean );
               procedure setDigitalOutput(physnum1,BitNum1:integer; PeriodeMS:float; durationMS:float; Fcont:boolean; Const AOaux: integer=-1);

               procedure setCounter( counter1: integer; IdleStateHigh: boolean; initialDelay1,lowTime1,highTime1: double;Frepeat:boolean; outNum1:integer);

               procedure startAODO(trigName: Ansistring);
               procedure startCtrl(trigname:AnsiString);
               procedure start(trigName: Ansistring);
               procedure setscale( y1,y2: float; unitY1:Ansistring);

             end;

procedure proTNIinterface_create(devName1:AnsiString; var pu: typeUO);pascal;
procedure proTNIinterface_setScale(ymin,ymax:float;unitY:AnsiString; var pu: typeUO);pascal;

procedure proTNIinterface_setAnalogOutput(PhysNum1:integer;PeriodeMS,DurationMS:float; Fcont:boolean ; var pu: typeUO);pascal;
procedure proTNIinterface_setDigitalOutput(PhysNum1,BitNum1:integer;PeriodeMS,DurationMS:float; Fcont:boolean ; var pu: typeUO);pascal;
procedure proTNIinterface_setDigitalOutput_1(PhysNum1,BitNum1:integer;PeriodeMS,DurationMS:float; Fcont:boolean;AOaux:integer ; var pu: typeUO);pascal;
procedure proTNIinterface_setCounterOutput(counter1: integer;IdleStateHigh: boolean; initialDelay1,highTime1,LowTime1: double;Frepeat: boolean; outNum1:integer ; var pu: typeUO);pascal;

procedure proTNIinterface_Start(trigName: AnsiString; var pu: typeUO);pascal;
procedure proTNIinterface_Stop(var pu: typeUO);pascal;
function fonctionTNIinterface_vector(var pu: typeUO): Tvector;pascal;

procedure proTNIinterface_SetClock(st: AnsiString; var pu: typeUO);pascal;

function fonctionTNIinterface_DIn(stchan:AnsiString; var DataValue:integer;var pu:typeUO):Integer;pascal;
function fonctionTNIinterface_DOut(stchan:AnsiString; DataValue:integer;var pu:typeUO):Integer;pascal;

function fonctionTNIinterface_AOut(stchan:AnsiString; DataValue:float;var pu:typeUO):Integer;pascal;
function fonctionTNIinterface_Ain(stchan:AnsiString; mode:integer;var DataValue:float;var pu:typeUO):Integer;pascal;

function fonctionTNIinterface_getLastError(var pu:typeUO):AnsiString;pascal;


implementation


function fonctionTNIinterface_DIn(stchan:AnsiString; var DataValue:integer;var pu:typeUO):Integer;
var
  taskHandle: integer;
  data:word;
  nbread:integer;
  status:integer;
begin
  EnterNi;
  status:=DAQmxCreateTask('Din',@taskHandle);
  if status=0 then status:=DAQmxCreateDIChan(taskHandle,Pansichar(stChan),'',DAQmx_Val_ChanForAllLines);
  if status=0 then status:=DAQmxStartTask(taskHandle);

  if status=0 then status:= DAQmxReadDigitalU16(taskHandle,1,10.0,DAQmx_Val_GroupByChannel,@data,1,@NbRead,nil);

  if taskHandle<>0 then
  begin
    DAQmxStopTask(taskHandle);
    DAQmxClearTask(taskHandle);
  end;
  DataValue:=data;
  result:=status;
  LeaveNI;
end;

function fonctionTNIinterface_DOut(stchan:AnsiString; DataValue:integer;var pu:typeUO):Integer;
var
  taskHandle: integer;
  data:word;
  nbread:integer;
  status:integer;
begin
  EnterNI;
  data:=dataValue;
  status:=DAQmxCreateTask('Dout',@taskHandle);
  if status=0 then status:=DAQmxCreateDOChan(taskHandle,Pansichar(stChan),'',DAQmx_Val_ChanForAllLines);
  if status=0 then status:=DAQmxStartTask(taskHandle);

  if status=0 then status:= DAQmxWriteDigitalU16(taskHandle,1,true,10.0,DAQmx_Val_GroupByChannel,@data,@NbRead,nil);

  if taskHandle<>0 then
  begin
    DAQmxStopTask(taskHandle);
    DAQmxClearTask(taskHandle);
  end;

  result:=status;
  LeaveNI;
end;



function fonctionTNIinterface_AOut(stchan:AnsiString; DataValue:float;var pu:typeUO):Integer;
var
  taskHandle: integer;
  data:double;
  nbread:integer;
  status:integer;
begin
  EnterNI;
  data:=dataValue;
  status:=DAQmxCreateTask('Aout',@taskHandle);
  if status=0 then status:=DAQmxCreateAOVoltageChan(taskHandle,Pansichar(stChan),'',-10.0,10.0,DAQmx_Val_Volts,'');
  if status=0 then status:=DAQmxStartTask(taskHandle);

  if status=0 then status:= DAQmxWriteAnalogF64(taskHandle,1,true,10.0,DAQmx_Val_GroupByChannel,@data,Nil,Nil);
  if taskHandle<>0 then
  begin
    DAQmxStopTask(taskHandle);
    DAQmxClearTask(taskHandle);
  end;

  result:=status;
  LeaveNI;
end;


function fonctionTNIinterface_Ain(stchan:AnsiString;mode:integer; var DataValue:float;var pu:typeUO):Integer;
var
  taskHandle: integer;
  data:double;
  nbread:integer;
  status:integer;
  cfg:integer;
begin
  EnterNI;
  case mode of
    1:  cfg:= DAQmx_Val_RSE ;
    2:  cfg:= DAQmx_Val_NRSE;
    3:  cfg:= DAQmx_Val_Diff;
    4:  cfg:= DAQmx_Val_PseudoDiff;
  end;

  status:=DAQmxCreateTask('Ain',@taskHandle);
  if status=0 then status:=DAQmxCreateAIVoltageChan(taskHandle,Pansichar(stChan),'', cfg,-10.0,10.0,DAQmx_Val_Volts,'');
  if status=0 then status:=DAQmxStartTask(taskHandle);

  if status=0 then status:= DAQmxReadAnalogF64(taskHandle,-1,10.0,DAQmx_Val_GroupByChannel,@data,1,@nbread,Nil);
  if taskHandle<>0 then
  begin
    DAQmxStopTask(taskHandle);
    DAQmxClearTask(taskHandle);
  end;
  DataValue:=data;

  result:=status;
  LeaveNI;
end;





{ TNIinterface }


constructor TNIinterface.create;
begin
  inherited;
  vec:= Tvector.create(g_single,0,999);
  AddTochildList(vec);
  Dy:=1000;
  unitY:='mV';
end;

destructor TNIinterface.destroy;
begin
  stopTask;
  vec.Free;
  inherited;

  if stError<>'' then sortieErreur(stError);
end;

procedure TNIinterface.setAnalogOutput(physnum1: integer; PeriodeMS: float; durationMS:float ; Fcont:boolean);
var
  nb:integer;
begin
  ChanType:=NI_type_AO;
  nb:= round(durationMS/ PeriodeMS);
  vec.modify(g_single,0,nb-1);
  physNum:= PhysNum1;
  rate:=1000/PeriodeMS;
  vec.Dxu:= PeriodeMS;
  vec.unitY:= unitY;
  ContinuousMode:= Fcont;
end;

procedure TNIinterface.setDigitalOutput(physnum1,BitNum1: integer; PeriodeMS: float; durationMS:float ; Fcont:boolean; Const AOaux: integer=-1);
var
  nb:integer;
begin
  ChanType:=NI_type_DO;
  nb:= round(durationMS/ PeriodeMS);
  vec.modify(g_single,0,nb-1);
  physNum:= PhysNum1;
  BitNum:= BitNum1;
  rate:=1000/PeriodeMS;
  vec.Dxu:= PeriodeMS;
  vec.unitY:= unitY;
  ContinuousMode:= Fcont;
  UseAO:=(AOaux>=0);
  AuxNum:=AOaux;
end;

procedure TNIinterface.setCounter(counter1: integer;IdleStateHigh: boolean;  initialDelay1, lowTime1, highTime1: double; Frepeat:boolean; outNum1:integer);
begin
  ChanType:= NI_type_Counter;
  PhysNum:= counter1;

  if IdleStateHigh
    then idleState:= DAQmx_Val_High
    else idleState:= DAQmx_Val_Low;

  initialDelay:= initialDelay1;
  lowTime:= lowTime1;
  highTime:= highTime1;
  OutNum:=OutNum1;

  FrepeatPulse:= Frepeat;
end;


function TNIinterface.StopError(const n:integer=0):boolean;
var
  errBuf:array[0..2047] of Ansichar;
begin
  result:=(status<0);
  if result  then
  begin
    fillchar(errBuf,sizeof(errBuf),0);
    EnterNI;
    DAQmxGetExtendedErrorInfo(errBuf,2048);
    LeaveNI;
    stError:= 'TNIinterface Error ('+istr(n)+') = '+PAnsichar(@errBuf);
  end;
end;

procedure TNIinterface.startAODO(trigName: AnsiString);
var
  stOut,stOutAux:AnsiString;
  sampsPerChanWritten: integer;
  bufAO: array of double;
  bufAOAux: array of double;
  bufDO: array of word;
  i:integer;
  sampleMode: integer;
  stTask: AnsiString;

Const
  cntTask: integer=0;
begin
  stError:='';
  inc(cntTask);  // provisoire

  case chantype of
    NI_type_AO: begin
                  setlength(bufAO, vec.Icount);
                  for i:= 0 to length(bufAO)-1 do bufAO[i]:= (vec[i]-y0)/Dy;
                end;
    NI_type_DO: begin
                  setlength(bufDO, vec.Icount);
                  if UseAO then
                  begin
                    setlength(bufAOaux, vec.Icount);
                    fillchar(bufAOaux[0],vec.Icount*8,0);
                  end;
                  for i:= 0 to length(bufDO)-1 do bufDO[i]:= ord(vec[i]<>0)*$FFFF;
                end;
  end;
  if ContinuousMode
    then SampleMode:= DAQmx_Val_ContSamps
    else SampleMode:= DAQmx_Val_FiniteSamps;

  case ChanType of
    NI_Type_AO: stOut:= devName+'/ao'+Istr(physNum);
    NI_Type_DO: stOut:= devName+'/port'+Istr(physNum)+'/line'+Istr(BitNum);
  end;
  stOutAux:=devName+'/ao'+Istr(AuxNum);
  EnterNI;
  stTask:= 'NIint Task '+Istr(CntTask);
  status:= DAQmxCreateTask(@stTask[1], @taskHandle);  { Créer la tâche  }
  if UseAO then status:= DAQmxCreateTask('NIintAux Task', @AuxTaskHandle);  { Créer la tâche  }
  LeaveNI;
  if StopError then exit;

  EnterNI;
  case ChanType of
    NI_Type_AO: status:= DAQmxCreateAOVoltageChan(taskHandle,Pansichar(stOut),'',-10.0,10.0,DAQmx_Val_Volts,Nil); { Les canaux }
    NI_Type_DO:
      begin
        if UseAO then status:= DAQmxCreateAOVoltageChan(AuxtaskHandle,Pansichar(stOutAux),'',-10.0,10.0,DAQmx_Val_Volts,Nil); { Les canaux }
        status:= DAQmxCreateDOChan(taskHandle, Pansichar(stOut),'',DAQmx_Val_ChanForAllLines);
      end;
  end;
  LeaveNI;
  if StopError  then exit;

  EnterNI;
  if UseAO then
  begin
    status:= DAQmxCfgSampClkTiming(AuxTaskHandle, '',rate,DAQmx_Val_Rising,SampleMode,vec.Icount);
    status:= DAQmxCfgSampClkTiming(TaskHandle, Pansichar(DevName+'/ao/SampleClock'),rate,DAQmx_Val_Rising,SampleMode,vec.Icount);
  end
  else
  case ChanType of
    NI_Type_AO:  status:= DAQmxCfgSampClkTiming(taskHandle, nil,rate,DAQmx_Val_Rising,SampleMode,vec.Icount);

    NI_Type_DO:  if stClock=''
                   then status:= DAQmxCfgSampClkTiming(taskHandle, nil,rate,DAQmx_Val_Rising,SampleMode,vec.Icount)
                   else status:= DAQmxCfgSampClkTiming(taskHandle, Pansichar(DevName+'/'+stClock+'/SampleClock') ,rate,DAQmx_Val_Rising,SampleMode,vec.Icount);

    // OK pour utiliser AO-clock sur DO mais une seule sortie utilisable
    // todo: remplacer useAO par AOclock ??
  end;
  LeaveNI;
  if StopError  then exit;
  { Si la source est nil, on utilise l'horloge principale
    Si la source est Pansichar('/'+DevName+'/ai/SampleClock') , on utilise l'horloge AI mais dans ce cas, le paramètre rate est ignoré
   }
  if trigName<>'' then
  begin
    EnterNI;
    if UseAO
      then DAQmxCfgDigEdgeStartTrig(AuxTaskHandle,Pansichar(devName+'/'+TrigName),DAQmx_Val_Rising)   { Le trigger éventuel }
      else DAQmxCfgDigEdgeStartTrig(taskHandle,Pansichar(devName+'/'+TrigName),DAQmx_Val_Rising);
    LeaveNI;
  end;

  EnterNI;
  if useAO then status:=DAQmxSetBufOutputBufSize(AuxTaskHandle, vec.Icount) ;
  status:=DAQmxSetBufOutputBufSize(taskHandle, vec.Icount) ;
  LeaveNI;

  EnterNI;
  case ChanType of
    NI_Type_AO: status:= DAQmxWriteAnalogF64(taskHandle, vec.Icount,false, 1, DAQmx_Val_GroupByChannel, @bufAO[0],  @sampsPerChanWritten, nil);
    NI_Type_DO:
      begin
        if UseAO then status:= DAQmxWriteAnalogF64(AuxTaskHandle, vec.Icount,false, 1, DAQmx_Val_GroupByChannel, @bufAOaux[0],  @sampsPerChanWritten, nil);
        status:= DAQmxWriteDigitalU16 (taskHandle, vec.Icount,false, 1, DAQmx_Val_GroupByChannel, @bufDO[0],  @sampsPerChanWritten, nil);
      end;
  end;
  LeaveNI;
  if stopError then exit;

  EnterNI;
  if UseAO then status:=DAQmxStartTask(AuxTaskHandle);
  status:=DAQmxStartTask(taskHandle);   { lancer la tâche  }
  LeaveNI;

end;

procedure TNIinterface.startCtrl(trigname:AnsiString);
var
  stOut: AnsiString;
  stPFI: AnsiString;
  buffer: array[0..1000] of AnsiChar;
begin
  stOut:= devName+'/ctr'+Istr(physNum);
  stPFI:= devName+'/PFI'+Istr(OutNum);

  (*
  EnterNI;
  status:= DAQmxTristateOutputTerm(PansiChar(stPFI));
  LeaveNI;
  if stopError then exit;
  *)

  if taskHandle<>0 then stopTask;

  EnterNI;
  status:=DAQmxCreateTask('NI Counter Task',@taskHandle);
  LeaveNI;
  if stopError then exit;

  EnterNI;               // Horloge à 1 MHz
  status:=DAQmxCreateCOPulseChanTime (TaskHandle, PansiChar(stOut),'',DAQmx_Val_Seconds  , idleState,  initialDelay, lowTime, highTime);
  LeaveNI;
  if stopError(1) then exit;



  //status:= DAQmxExportSignal (TaskHandle, DAQmx_Val_CounterOutputEvent , PansiChar(stPFI));

  //status:=DAQmxGetCOPulseTerm(taskHandle, PansiChar(stOut), @buffer, 1000);
  //OldCounterOut:=Pansichar(@buffer);
  //status:=DAQmxReSetCOPulseTerm(taskHandle, PansiChar(stOut));


  EnterNI;
  status:=DAQmxSetCOPulseTerm(taskHandle, PansiChar(stOut), PansiChar(stPFI));
  LeaveNI;
  if stopError(2) then exit;                                               { doit être appelé après DAQmxCreateCOPulseChanFreq }

  if trigname<>'' then
  begin
    EnterNI;
    status:=DAQmxCfgDigEdgeStartTrig(taskHandle,Pansichar(devName+'/'+TrigName),DAQmx_Val_Rising);
    LeaveNI;
    if stopError(3) then exit;
  end;


  if FrepeatPulse then
  begin
    EnterNI;
    status:=DAQmxCfgImplicitTiming(taskHandle,DAQmx_Val_ContSamps,1000);
    LeaveNI;
    if stopError(4) then exit;
  end;

  EnterNI;
  status:=DAQmxStartTask(taskHandle);
  LeaveNI;
  if stopError(5) then exit;

end;

procedure TNIinterface.start(trigName: Ansistring);
begin
  if chanType= NI_Type_Counter
    then startCtrl(trigname)
    else startAODO(trigName);
end;


procedure TNIinterface.StopTask;
var
  stOut, stPFI: AnsiString;
begin
  EnterNI;
  DAQmxStopTask(TaskHandle);      // No error
  LeaveNI;


  if ChanType= NI_type_Counter then
  begin
    stOut:= devName+'/ctr'+Istr(physNum);

    EnterNI;
    //status:= DAQmxExportSignal (TaskHandle, DAQmx_Val_CounterOutputEvent , nil);
    //status:=DAQmxSetCOPulseTerm(taskHandle, PansiChar(stOut), '');
    //status:=DAQmxReSetCOPulseTerm(taskHandle, PansiChar(stOut));
    LeaveNI;
    if stopError(10) then exit;
  end;

  EnterNI;
  DAQmxClearTask(TaskHandle);     // No Error
  LeaveNI;

  if ChanType= NI_type_Counter then
  begin
    stPFI:= devName+'/PFI'+Istr(OutNum);
    EnterNI;
    status:= DAQmxTristateOutputTerm (PansiChar(stPFI));
    LeaveNI;
    if stopError(11) then exit;
  end;


  if UseAO then
  begin
    EnterNI;
    DAQmxStopTask(AuxTaskHandle);      // No error
    DAQmxClearTask(AuxTaskHandle);     // No Error
    LeaveNI;
  end;

  TaskHandle:=0;
  AuxTaskHandle:=0;


end;

procedure TNIinterface.setscale( y1,y2: float;unitY1:AnsiString);
begin
  Dy:= (Y2-Y1)/20;
  y0:=  Y1 + 10*Dy;
  unitY:=unitY1;
end;

procedure TNIinterface.setChildNames;
begin
  vec.ident:= ident+'.Vector';
end;

procedure proTNIinterface_create(devName1:AnsiString; var pu: typeUO);
var
  i:integer;
  ok: boolean;
begin
  ok:= false;
  with NiDevNames do
  for i:=0 to count-1 do
    if Fmaj(strings[i])= Fmaj(devName1) then
    begin
      ok:=true;
      break;
    end;

  if not ok then sortieErreur('TNIinterface.create : device not found');
  CreatePGobject('',pu, TNIinterface);
  TNIinterface(pu).devName:='/'+ devName1;
end;

procedure proTNIinterface_setScale(ymin,ymax:float;unitY:AnsiString; var pu: typeUO);
begin
  verifierObjet(pu);
  TNIinterface(pu).setscale(ymin,ymax,unitY);
end;

procedure proTNIinterface_setAnalogOutput(PhysNum1:integer;PeriodeMS, DurationMS:float; Fcont: boolean ; var pu: typeUO);
begin
  verifierObjet(pu);
  if periodeMS<=0 then sortieErreur('TNIinterface.setAnalogOutput : Periode out of range');
  if DurationMS<=0 then sortieErreur('TNIinterface.setAnalogOutput :  Duration out of range');
  TNIinterface(pu).setAnalogOutput(PhysNum1,PeriodeMS,DurationMS, Fcont);
end;


procedure proTNIinterface_setDigitalOutput(PhysNum1,BitNum1:integer;PeriodeMS,DurationMS:float; Fcont:boolean ; var pu: typeUO);
begin
  verifierObjet(pu);
  if periodeMS<=0 then sortieErreur('TNIinterface.setDigitalOutput : Periode out of range');
  if DurationMS<=0 then sortieErreur('TNIinterface.setDigitalOutput :  Duration out of range');
  TNIinterface(pu).setDigitalOutput(PhysNum1,BitNum1,PeriodeMS,DurationMS, Fcont);
end;

procedure proTNIinterface_setDigitalOutput_1(PhysNum1,BitNum1:integer;PeriodeMS,DurationMS:float; Fcont:boolean;AOaux:integer ; var pu: typeUO);
begin
  verifierObjet(pu);
  if periodeMS<=0 then sortieErreur('TNIinterface.setDigitalOutput : Periode out of range');
  if DurationMS<=0 then sortieErreur('TNIinterface.setDigitalOutput :  Duration out of range');
  TNIinterface(pu).setDigitalOutput(PhysNum1,BitNum1,PeriodeMS,DurationMS, Fcont,AOaux);
end;

procedure proTNIinterface_setCounterOutput(counter1: integer;IdleStateHigh: boolean;initialDelay1,highTime1,LowTime1: double; Frepeat: boolean; outNum1:integer; var pu: typeUO);
begin
  verifierObjet(pu);
  TNIinterface(pu).setCounter( counter1,idleStateHigh,initialDelay1,lowTime1,highTime1,Frepeat, outNum1);
end;



procedure proTNIinterface_Start(trigName: AnsiString; var pu: typeUO);
begin
  verifierObjet(pu);
  with TNIinterface(pu) do
  begin
    start(trigName);
    if stError<>'' then sortieErreur(stError);
  end;
end;

procedure proTNIinterface_Stop( var pu: typeUO);
begin
  verifierObjet(pu);
  TNIinterface(pu).stopTask;
end;


function fonctionTNIinterface_vector(var pu: typeUO): Tvector;
begin
  verifierObjet(pu);
  with TNIinterface(pu) do result:= @vec.myAd;
end;

function fonctionTNIinterface_getLastError(var pu:typeUO):AnsiString;
begin
  result:= getNIerrorString;
end;


procedure proTNIinterface_SetClock(st: AnsiString; var pu: typeUO);
begin
  verifierObjet(pu);
  TNIinterface(pu).stClock:= lowercase(st);
end;




end.
