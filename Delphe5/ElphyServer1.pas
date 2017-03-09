unit ElphyServer1;

interface
{$IFDEF FPC} {$mode delphi} {$DEFINE AcqElphy2} {$A1} {$Z1} {$ENDIF}

uses sysutils,
     util1,Dtrace1,stmdef,stmobj,nsAPItypes,stmTCPIP1,
     {$IFDEF FPC} Gedit5fpc {$ELSE} Gedit5 {$ENDIF} ,
     stmPG, stmdf0, stmVec1;

var
  ElphyServer:TserverA;

procedure ProcessElphyServerMessages;

function GetEntityInfo(df:TdataFile;id:integer;var info:ns_EntityInfo):ns_Result;
function GetAnalogInfo(df:TdataFile;id:integer;var info:ns_AnalogInfo):ns_Result;
function GetAnalogData(df:TdataFile;Id,StartIndex,IndexCount:integer;var pdata:pointer;var dataCount:integer):integer;

implementation

uses mdac;




procedure DisplayMem;
begin
//  statuslineTxt('Mem='+Istr(getHeapStatus.totalAllocated) );
end;


{ nb contient les nombres de points par épisode
  i est un indice global ( 0<=i<nmax )
  On calcule le numéro d'épisode et l'indice dans l'épisode
  Tous les indices commencent à zéro
}
procedure getEpIp(var nb: TarrayOfInteger;i:integer;var ep,ip:integer);
begin
  ep:=0;
  ip:=i;
  while (ep<high(nb)) and (ip>=nb[ep]) do
  begin
    ip:=ip-nb[ep];
    inc(ep);
  end;

  if ip>=nb[ep] then ip:=nb[ep]-1;
end;

function EntityCount(df:TdataFile):integer;
var
  i:integer;
begin
  with df do
  begin
    result:=0;
    for i:=1 to channelCount do
      if NsVflag[i] then inc(result);
    result:=result+2*SpkCount;
    for i:=1 to VtagCount do
      if NsVtagflag[i] then inc(result);
  end;
end;


{ id est le numéro d'entité, de 0 à entityCount
  IdToCat renvoie:
    cat=1  num = num channel pour les voies analog (ou evt ordinaires)
    cat=2  num = num channel pour les voies Vspk
    cat=3  num = num channel pour les voies Wspk
    cat=4  num = num channel pour les voies Vtag
    cat=0 si erreur
}
procedure IdToCat(df:TdataFile;id:integer;var cat,num:integer);
var
  i,id0:integer;
begin
  with df do
  begin
    id0:=-1;
    num:=0;
    cat:=1;
    for i:=1 to channelCount do
    begin
      if NsVflag[i] then inc(id0);
      inc(num);
      if id=id0 then exit;
    end;

    cat:=2;
    num:=id-id0;
    if (num>=1) and (num<=SpkCount) then exit;

    cat:=3;
    num:=id-id0-spkCount;
    if (num>=1) and (num<=SpkCount) then exit;

    cat:=4;
    id0:=id0+2*SpkCount;
    num:=0;
    for i:=1 to VtagCount do
    begin
      if NsVtagflag[i] then inc(id0);
      inc(num);
      if id=id0 then exit;
    end;

    cat:=0;  { error }
  end;

end;

function GetFileInfo(df:TdataFile;var info:ns_FileInfo):ns_Result;
var
  dd:TdateTime;
  year,month,day,hour,mn,sec,ms:word;
  i:integer;
begin
  if not assigned(df.FileDesc) then
  begin
    result:=ns_FILEERROR;
    exit;
  end;
  with Info do
  begin
    StringToPchar('Elphy Data File',32,szFileType);                  // Manufacturer's file type descriptor

    dwEntityCount := entityCount(df);                                // Number of entities in the data file.

    if df.FileDesc.nbSpk>0 then dTimeStampResolution := 1/30000      // CyberK     // Minimum timestamp resolution
    else
    begin
      dTimeStampResolution := 1E9;
      for i:=1 to df.channelCount do
      if not (df.channel(i).modeT in [DM_EVT1,DM_EVT2]) then
      begin
        if df.channel(i).dxu< dTimeStampResolution then dTimeStampResolution:=df.channel(i).dxu;
        if df.channel(1).unitX<>'sec' then dTimeStampResolution:=dTimeStampResolution/1000;
      end;
    end;
    dTimeSpan :=df.FileDesc.getTimeSpan;                             // Time span covered by the data file in seconds

    StringToPchar('ELPHY',64,szAppName);    // Name of the application that created the file

    dd:=df.fileDesc.FileAgeD;
    decodeDate(dd,year,month,day);
    decodeTime(dd,hour,mn,sec,ms);

    dwTime_Year :=year;                   // Year the file was created
    dwTime_Month := month;                // Month (0-11; January = 0)
    dwTime_DayofWeek :=0;                 // Day of the week (0-6; Sunday = 0)
    dwTime_Day := day;                    // Day of the month (1-31)
    dwTime_Hour:= hour;                   // Hour since midnight (0-23)
    dwTime_Min :=mn;                      // Minute after the hour (0-59)
    dwTime_Sec :=sec;                     // Seconds after the minute (0-59)
    dwTime_MilliSec := ms;	          // Milliseconds after the second (0-1000)

    StringToPchar('',256,szFileComment);  // Comments embedded in the source file
  end;
  result:=0;
end;

function GetEntityInfo(df:TdataFile;id:integer;var info:ns_EntityInfo):ns_Result;
var
  st:AnsiString;
  ep,tp,nb:integer;
  cat,ch:integer;
begin
  if not assigned(df.FileDesc) then
  begin
    result:=ns_FILEERROR;
    exit;
  end;

  IdToCat(df,id,cat,ch);

  with df,FileDesc do
  begin
    setEpNum(1);
    case cat of
      1: begin
           st:='V'+Istr(ch);
           if channel(ch).modeT=DM_EVT1
             then tp:=ns_ENTITY_EVENT
             else tp:=ns_ENTITY_ANALOG;
           nb:=getVtotCount(ch);
         end;
      2: begin
           st:='VSpk'+Istr(ch);
           tp:=ns_ENTITY_NEURALEVENT;
           nb:=getVspkTotCount(ch);
         end;
      3: begin
           st:='WSpk'+Istr(ch);
           tp:=ns_ENTITY_SEGMENT;
           nb:=getWspkTotCount(ch);
         end;
      4: begin
           st:='Vtag'+Istr(ch);
           tp:=ns_ENTITY_ANALOG;
           nb:=getVtagTotCount;
         end;
    end;
  end;

  with info do
  begin
    StringToPchar(st,32,szEntityLabel); // Specifies the label or name of the entity
    dwEntityType :=tp;                  // One of the ns_ENTITY_* types defined above
    dwItemCount :=nb;                   // Number of data items for the specified entity in the file
  end;

  result:=0;
end;

function GetEventInfo(df:TdataFile;id:integer;var info:ns_EventInfo):ns_Result;
var
  st:AnsiString;
  ch,ep,tp,nb:integer;
begin
  if not assigned(df.FileDesc) then
  begin
    result:=ns_FILEERROR;
    exit;
  end;

  fillchar(info,sizeof(info),0);
  info.dwEventType:=ns_Event_Dword;
  info.dwMinDataLength:=4;
  info.dwMaxDataLength:=4;

  result:=0;
end;

function GetEventData(df:TdataFile; Id:integer; StartIndex:integer; var TimeStamp:double): ns_result;
var
  cat,ch,ep,ip:integer;
  nbSamps:TarrayOfInteger;
begin
  if not assigned(df.FileDesc) then
  begin
    result:=ns_FILEERROR;
    exit;
  end;

  IdToCat(df,id,cat,ch);
  with df,FileDesc do
  begin
    if cat=1 then
    begin
      getVnbsamps(ch,nbSamps);

      getEpIp(nbSamps,StartIndex,ep,ip);
      SetEpNum(ep+1);
      with channel(ch) do
        TimeStamp:= Yvalue[Istart +ip];

      result:=0;
    end

    else  result:=ns_FILEERROR;
  end;
end;


function GetAnalogInfo(df:TdataFile;id:integer;var info:ns_AnalogInfo):ns_Result;
var
  st:AnsiString;
  cat,ch,ep,tp,nb:integer;
  maxi1,mini1:float;
begin
  if not assigned(df.FileDesc) then
  begin
    result:=ns_FILEERROR;
    exit;
  end;

  IdToCat(df,id,cat,ch);
  df.setEpNum(1);

  fillchar(info,sizeof(info),0);

  if (cat=1) and (df.channel(ch).modeT<>DM_evt1) then
  with info,df.channel(ch) do
  begin
    dSampleRate:=1/dxu;                   // The sampling rate in Hz used to digitize the analog values
    if unitX<>'sec' then dSampleRate:=dSampleRate*1000;

    dMinVal:= { data.mini(0,data.indiceMin);} -32767*Dyu;            // Minimum possible value of the input signal
    dMaxVal:= { data.maxi(0,data.indiceMax);} 32768*Dyu ;            // Maximum possible value of the input signal


    StringToPchar(unitY,16, szUnits);     // Specifies the recording units of measurement
    dResolution:=Dyu;                     // Minimum resolvable step (.0000305 for a +/-1V 16-bit ADC)
    result:=0;
  end
  else
  if (cat=4) then
  with info,df.Vtag[1] do
  begin
    dSampleRate:=1/dxu;                   // The sampling rate in Hz used to digitize the analog values
    if unitX<>'sec' then dSampleRate:=dSampleRate*1000;

    dMinVal:= -10000;            // Minimum possible value of the input signal
    dMaxVal:=  10000;            // Maximum possible value of the input signal


    StringToPchar('mV',16, szUnits);     // Specifies the recording units of measurement
    dResolution:=10000/32768;            // Minimum resolvable step (.0000305 for a +/-1V 16-bit ADC)
    result:=0;
  end
  else result:=ns_BadEntity;
end;

function GetAnalogData(df:TdataFile;Id,StartIndex,IndexCount:integer;var pdata:pointer;var dataCount:integer):integer;
var
  cat,ch,ep,ip, nbtot,i:integer;
  nbSamps:TarrayofInteger;
begin
  if not assigned(df.FileDesc) then
  begin
    result:=ns_FILEERROR;
    exit;
  end;

  IdToCat(df,id,cat,ch);

  with df,FileDesc do
  begin
    if (cat=1) and (channel(ch).modeT<>DM_evt1) then
    begin
      nbtot:=getVtotCount(ch);
      getVnbsamps(ch,nbSamps);

      if StartIndex+IndexCount-1>=nbTot
          then dataCount:=nbtot-startIndex
          else dataCount:=IndexCount;
      if dataCount<0 then dataCount:=0;

      getmem(pdata,dataCount*8);


      getEpIp(nbSamps,StartIndex,ep,ip);
      SetEpNum(ep+1);
      with channel(ch) do
      for i:=0 to dataCount-1 do
      begin
        PtabDouble(pdata)^[i]:= Yvalue[Istart +ip];
        inc(ip);
        if ip>nbSamps[ep] then
        begin
          inc(ep);
          setEpNum(ep+1);
          ip:=0;
        end;
      end;
      result:=0;
    end
    else
    if (cat=4) then
    begin
      nbtot:=getVtagTotCount;
      getVtagNbsamps(nbSamps);

      if StartIndex+IndexCount-1>=nbTot
          then dataCount:=nbtot-startIndex
          else dataCount:=IndexCount;
      if dataCount<0 then dataCount:=0;

      getmem(pdata,dataCount*8);

      getEpIp(nbSamps,StartIndex,ep,ip);
      SetEpNum(ep+1);
      with Vtag[ch] do
      for i:=0 to dataCount-1 do
      begin
        PtabDouble(pdata)^[i]:= Yvalue[Istart +ip];
        inc(ip);
        if ip>nbSamps[ep] then
        begin
          inc(ep);
          setEpNum(ep+1);
          ip:=0;
        end;
      end;
      result:=0;
    end
    else
    begin
      result:=ns_BadEntity;
      exit;
    end;
  end;

end;

function GetSegmentInfo(df:TdataFile;id:integer;var info:ns_SegmentInfo):ns_Result;
var
  cat,ch:integer;
begin
  if not assigned(df.FileDesc) then
  begin
    result:=ns_FILEERROR;
    exit;
  end;

  IdToCat(df,id,cat,ch);

  if cat=3 then
  begin
    fillchar(info,sizeof(info),0);
    with info,df.Wspk(ch) do
    begin
      dwSourceCount:=1;             // Number of sources in the Segment Entity, e.g. 4 for a tetrode
      dwMinSampleCount:=Icount;     // Minimum number of samples in each Segment data item
      dwMaxSampleCount:=Icount;     // Maximum number of samples in each Segment data item
      dSampleRate:=1/dxu*1000;      // The sampling rate in Hz used to digitize source signals
      StringToPchar(unitY,32,szUnits); // Specifies the recording units of measurement
    end;
    result:=0;
  end
  else result:=ns_BadEntity;
end;


function GetSegSourceInfo(df:TdataFile;id,idSource:integer;var info:ns_SegSourceInfo):ns_Result;
var
  cat,ch:integer;
begin
  if not assigned(df.FileDesc) then
  begin
    result:=ns_FILEERROR;
    exit;
  end;

  IdToCat(df,id,cat,ch);

  if cat=3 then
  begin
    fillchar(info,sizeof(info),0);
    with info,df.Wspk(ch) do
    begin
      dMinVal:=-128*Dyu;                        // Minimum possible value of the input signal
      dMaxVal:= 128*Dyu;                        // Maximum possible value of the input signal
      dResolution:=   Dyu;                        // Minimum input step size that can be resolved
    end;
    result:=0;
  end
  else result:=ns_BadEntity;
end;

function GetSegmentData(df:TdataFile;Id,Index:integer;
                        var pdata:pointer;var dataSize:integer;
                        var timeStamp:double;var UnitId:integer):integer;
var
  st:AnsiString;
  cat,ch,ep,ip,i:integer;
  nbSamps:TarrayOfInteger;

begin
  if not assigned(df.FileDesc) then
  begin
    result:=ns_FILEERROR;
    exit;
  end;

  IdToCat(df,id,cat,ch);

  if cat=3 then
  with df,FileDesc do
  begin
    getVSpkNbsamps(ch,nbSamps);

    getEpIp(nbSamps,Index,ep,ip);
    setEpNum(ep+1);

    with Wspk(ch) do
    begin
      dataSize:=Icount*8;
      getmem(pdata,dataSize);
      setIndex(Ip+1);
      for i:=Istart to Iend do
        PtabDouble(pdata)^[i-Istart]:=Yvalue[i];

      timeStamp:=curWRec.ElphyTime*Dxu/1000 + CyberTime(ep+1)-CyberTime(1);
      UnitId:=1 shl curWrec.unit1;
    end;
    result:=0;
  end
  else result:=ns_BadEntity;
end;


function GetNeuralInfo(df:TdataFile;id:integer;var info:ns_NeuralInfo):ns_Result;
var
  cat,ch:integer;
begin
  if not assigned(df.FileDesc) then
  begin
    result:=ns_FILEERROR;
    exit;
  end;

  IdToCat(df,id,cat,ch);
  if cat=2 then
  begin
    fillchar(info,sizeof(info),0);
    with info do
    begin
      dwSourceEntityID:=0;            // Optional ID number of a source entity
      dwSourceUnitID:=0;              // Optional sorted unit ID number used in the source entity
      StringToPchar('',128,szProbeInfo);
    end;
    result:=0;
  end
  else result:=ns_BadEntity;
end;

function GetNeuralData(df:TdataFile;Id,StartIndex,IndexCount:integer;var pdata:pointer):integer;
var
  vec:Tvector;
  i,tpNS:integer;
  cat,ch,ep,ip,nbtot:integer;
  nbSamps:TarrayOfInteger;
  dt:double;
begin
  if not assigned(df.FileDesc) then
  begin
    result:=ns_FILEERROR;
    exit;
  end;

  IdToCat(df,id,cat,ch);

  with df,FileDesc do
  begin
    if cat=1 then
    begin
      nbtot:=getVtotCount(ch);
      getVnbsamps(ch,nbSamps);

      getmem(pdata,IndexCount*8);


      getEpIp(nbSamps,StartIndex,ep,ip);
      SetEpNum(ep+1);
      with channel(ch) do
      for i:=0 to IndexCount-1 do
      begin
        PtabDouble(pdata)^[i]:= Yvalue[Istart +ip];
        inc(ip);
        if ip>nbSamps[ep] then
        begin
          inc(ep);
          setEpNum(ep+1);
          ip:=0;
        end;
      end;

      result:=0;
    end
    else
    if cat=2 then
    begin
      nbtot:=getVspkTotCount(ch);
      getVspkNbsamps(ch,nbSamps);

      getmem(pdata,IndexCount*8);

      getEpIp(nbSamps,StartIndex,ep,ip);
      SetEpNum(ep+1);
      dt:= CyberTime(ep+1)-CyberTime(1);
      with Vspk(ch) do                                { Ne marche que pour les Vspk }
      for i:=0 to IndexCount-1 do
      begin
        PtabDouble(pdata)^[i]:= Yvalue[Istart +ip] + dt;
        inc(ip);
        if ip>nbSamps[ep] then
        begin
          inc(ep);
          setEpNum(ep+1);
          dt:= CyberTime(ep+1)-CyberTime(1);
          ip:=0;
        end;
      end;
      result:=0;
    end
    else result:=ns_BadEntity;
  end;
end;

function GetIndexByTime(df:TdataFile;Id:integer;tt:double;flag:integer;var index:integer): integer;
var
  vec:Tvector;
  tpNS:integer;
  tm:float;
  seq:integer;
  cat,ch:integer;
begin
  if not assigned(df.FileDesc) then
  begin
    result:=ns_FILEERROR;
    exit;
  end;

  IdToCat(df,id,cat,ch);

  case cat of
    1: vec:=df.channel(ch);
    2: vec:=df.Vspk(ch);
    3: vec:=df.Vspk(ch);   { Si Wspk, regarder Vspk }
    4: vec:=df.Vtag[ch];
    else
    begin
      result:=ns_FILEERROR;
      exit;
    end;
  end;

  with Vec do
  begin
    if unitX<>'sec' then tt:=tt*1000;
    if (cat=1) and not (modeT in [DM_evt1,DM_evt2]) then {analog}
    begin
      index:=invconvx(tt);
      if index<Istart then index:=Istart
      else
      if index>Iend then index:=Iend;
    end
    else
    if (cat=1) and (modeT in [DM_evt1,DM_evt2]) or (cat=2) or (cat=3) then
    with df,fileDesc do                                   {Event}
    begin
      tm:=0;
      for seq:=1 to nbSeqDat do
      begin
       setEpNum(seq);
       tm:=tm+dureeSeq;
       if tm>=tt then break;
      end;

      if (tt<0) or (tt>tm) then
      begin
       result:=ns_badIndex;
       exit;
      end;

      index:=getFirstEvent(tt);
      case Flag of
       -1 : if (Yvalue[index]>tt) and (index>Istart) then dec(index);
        0 : if (index<Iend) and (tt-Yvalue[index]>Yvalue[index+1]-tt) then inc(index);
        1 : begin end;
      end;
      index:=index-Istart;
    end;
  end;
  result:=0;
end;

function GetTimeByIndex(df:TdataFile;Id:integer;index:integer;var tt: double): integer;
var
  vec:Tvector;
  tpNS:integer;
  nbSamps:TarrayOfInteger;
  cat,ch,ep,ip:integer;
begin
  if not assigned(df.FileDesc) then
  begin
    result:=ns_FILEERROR;
    exit;
  end;

  IdToCat(df,id,cat,ch);

  case cat of
    1: vec:=df.channel(ch);
    2: vec:=df.Vspk(ch);
    3: vec:=df.Vspk(ch);   { Si Wspk, regarder Vspk }
    4: vec:=df.Vtag[ch];
    else
    begin
      result:=ns_FILEERROR;
      exit;
    end;
  end;

  with Vec do
  begin
    tt:=0;

    if (cat=1) and not (modeT in [DM_evt1,DM_evt2]) then 
    begin                                      {analog}
      index:=Istart+index;
      tt:=convx(index);
    end
    else
    if (cat=1) and (modeT in [DM_evt1,DM_evt2]) or (cat=2) or (cat=3) then
    begin                                      {Event ou neuralEvent}
      df.fileDesc.getVnbsamps(id+1,nbSamps);
      getEpIp(nbSamps,Index,ep,ip);
      df.setEpNum(ep+1);

      index:=Istart+index;
      if (index>=Istart) and (index<=Iend)  then tt:=Yvalue[index]
      else
      begin
        result:=ns_badIndex;
        exit;
      end;
    end;

    if unitX<>'sec' then tt:=tt/1000;
  end;
  result:=0;
end;

procedure InstallNsFlagList;
begin
end;

procedure ProcessElphyServerMessages;
var
  buffer:Tbuffer;
  st,stF:AnsiString;
  NSresult:integer;
  idNum:integer;
  df:TdataFile;
  i:integer;

  fileInfo:ns_FileInfo;
  EntityInfo: ns_EntityInfo;
  EventInfo: ns_EventInfo;
  AnalogInfo: ns_AnalogInfo;
  segmentInfo: ns_segmentInfo;
  segSourceInfo: ns_segSourceInfo;
  NeuralInfo: ns_NeuralInfo;

  size:integer;
  EntityId:integer;
  index, StartIndex,IndexCount,dataCount:integer;
  pdata:pointer;
  SourceId:integer;
  timeStamp: double;
  EventDataSize,EventDataRetSize:integer;
  flags,UnitId:integer;

  ii1,ii2:integer;
const
  diff:integer=0;
  cnt:integer=0;

begin
  with Elphyserver do
  repeat
    buffer:=getBuffer;
    if assigned(buffer) then
    try
      st:=buffer.ident;
      idNum:=buffer.idNum;

      if st=Sys_Command then
      case idNum of
        Sys_Reset:  mainDac.Programreset1Click(nil);
        Sys_PgExec:
          begin
            buffer.ResetIndex;
            st:=buffer.readShortString;

            if assigned(dacPg) then Tpg2(dacPg).executePgCommand(st);
          end;
        Sys_PgInstall:
          begin
            buffer.ResetIndex;
            st:=buffer.readShortString;
            if assigned(dacPg) then Tpg2(dacPg).LoadAndInstallPrimary(st);
          end;
        Sys_LoadConfig:
          begin
            buffer.ResetIndex;
            st:=buffer.readShortString;
            mainDac.newGfc(st);
          end;
        Sys_Quit: mainDac.Close;
      end;

      if st=NS_Command then
      case idNum of
        Kns_openFile:
          begin
            buffer.ResetIndex;
            stF:=buffer.readString;

            df:=nil;
            with MainObjList do
            for i:=0 to count-1 do
            if typeUO(items[i]) is TdataFile then
              if Fmaj(TdataFile(items[i]).stFichier) = Fmaj(stF) then
              begin
                df:=items[i];
                break;
              end;

            if df=nil then
            begin
              df:=TdataFile.create;
              df.initialise(NomParDefaut0(TdataFile.STMClassName));
              MainObjList.add(df,UO_temp);
              df.installFile0(stF,false,true);
            end;

            if assigned(df.FileDesc) then
            begin
              nsResult:=0;
            end
            else
            begin
              MainObjList.Remove(df);
              df:=nil;
              nsResult:=ns_fileError;
            end;

            df.getNSflags;


            OutputBuffer.clear;
            OutputBuffer.ident:=NS_Query;
            OutputBuffer.idNum:=Kns_openFile;

            OutputBuffer.write(df,4);              { File Handle }

            OutputBuffer.write(NSresult,4);        { nsResult }
            PutBuffer;
          end;

        Kns_CloseFile:
          begin
            buffer.ResetIndex;
            buffer.readInt(intG(df));

            i:=MainObjList.IndexOf(df);
            if i>=0 then
            begin
              df.Free;
              MainObjList.supprime(df);
              nsResult:=0;
            end
            else nSResult:=ns_BadFile;

            OutputBuffer.init(NS_Query,Kns_openFile,false);
            OutputBuffer.write(NSresult,4);         { nsResult }
            PutBuffer;
          end;

        Kns_GetFileInfo:
          begin
            buffer.ResetIndex;
            buffer.readInt(intG(df));

            i:=MainObjList.IndexOf(df);
            if i>=0
              then nsResult:=GetFileInfo(df,fileInfo)
              else nSResult:=ns_BadFile;

            OutputBuffer.init(NS_Query,Kns_getFileInfo,false);
            OutputBuffer.write(fileInfo,sizeof(fileInfo));
            OutputBuffer.write(NSresult,4);         { nsResult }
            PutBuffer;
          end;


        Kns_GetEntityInfo:
          begin
            buffer.ResetIndex;
            buffer.readInt(intG(df));
            buffer.readInt(EntityId);

            i:=MainObjList.IndexOf(df);
            if i>=0
              then nsResult:=GetEntityInfo(df,EntityId,EntityInfo)
              else nSResult:=ns_BadFile;

            OutputBuffer.init(NS_Query,Kns_getEntityInfo,false);
            OutputBuffer.write(EntityInfo,sizeof(EntityInfo));
            OutputBuffer.write(NSresult,4);         { nsResult }
            PutBuffer;
          end;
        Kns_GetEventInfo:
          begin
            buffer.ResetIndex;
            buffer.readInt(intG(df));
            buffer.readInt(EntityId);

            i:=MainObjList.IndexOf(df);
            if i>=0
              then nsResult:=GetEventInfo(df,EntityId,EventInfo)
              else nSResult:=ns_BadFile;

            OutputBuffer.init(NS_Query,Kns_getEventInfo,false);
            OutputBuffer.write(EventInfo,sizeof(EventInfo));
            OutputBuffer.write(NSresult,4);         { nsResult }
            PutBuffer;
          end;
        Kns_GetEventData:
          begin
            buffer.ResetIndex;
            buffer.readInt(intG(df));
            buffer.readInt(EntityId);
            buffer.readInt(StartIndex);
            buffer.readInt(EventDataSize);

            i:=MainObjList.IndexOf(df);
            if i>=0 then
            begin
              nsResult:=GetEventData(df,EntityId,StartIndex,TimeStamp);
            end
            else
            begin
              pdata:=nil;
              nSResult:=ns_BadFile;
              EventDataRetSize:=0;
            end;

            OutputBuffer.init(NS_Query,Kns_getEventdata,false);
            OutputBuffer.write(TimeStamp,8);
            OutputBuffer.writeInt(4);               {dataRetSize}

            OutputBuffer.writeInt(0);               { data }
            OutputBuffer.write(NSresult,4);         { nsResult }
            PutBuffer;

          end;
        Kns_GetAnalogInfo:
          begin
            buffer.ResetIndex;
            buffer.readInt(intG(df));
            buffer.readInt(EntityId);

            i:=MainObjList.IndexOf(df);
            if i>=0 then
            begin
              GetAnalogInfo(df,EntityId,AnalogInfo);
              nsResult:=0;
            end
            else nSResult:=ns_BadFile;

            OutputBuffer.init(NS_Query,Kns_getAnalogInfo,false);
            OutputBuffer.write(AnalogInfo,sizeof(AnalogInfo));
            OutputBuffer.write(NSresult,4);         { nsResult }
            PutBuffer;
          end;

        Kns_GetAnalogData:
          begin
            //ii1:=getHeapStatus.TotalAllocated;
            buffer.ResetIndex;
            buffer.readInt(intG(df));
            buffer.readInt(EntityId);
            buffer.readInt(StartIndex);
            buffer.readInt(IndexCount);

            try
            i:=MainObjList.IndexOf(df);
            if i>=0 then
            begin
              nsResult:=GetAnalogData(df,EntityId,StartIndex,IndexCount,pdata,dataCount);
              //nsResult:=123;
              //dataCount:=IndexCount;
              //getmem( pdata, 8*IndexCount);
            end
            else
            begin
              pdata:=nil;
              nSResult:=ns_BadFile;
              dataCount:=0;
            end;

            OutputBuffer.init(NS_Query,Kns_getAnalogdata,false);
            OutputBuffer.writeInt(dataCount);
            OutputBuffer.write(pdata^,dataCount*8); {  }
            OutputBuffer.write(NSresult,4);         { nsResult }
            PutBuffer;

            finally
            freemem(pdata);
            end;
          end;

        Kns_GetSegmentInfo:
          begin
            buffer.ResetIndex;
            buffer.readInt(intG(df));
            buffer.readInt(EntityId);

            i:=MainObjList.IndexOf(df);
            if i>=0 then
            begin
              nsResult:=GetSegmentInfo(df,EntityId,SegmentInfo);
            end
            else nSResult:=ns_BadFile;

            OutputBuffer.init(NS_Query,Kns_getSegmentInfo,false);
            OutputBuffer.write(SegmentInfo,sizeof(SegmentInfo));
            OutputBuffer.write(NSresult,4);         { nsResult }
            PutBuffer;
          end;

        Kns_GetSegSourceInfo:
          begin
            buffer.ResetIndex;
            buffer.readInt(intG(df));
            buffer.readInt(EntityId);
            buffer.readInt(SourceId);

            i:=MainObjList.IndexOf(df);
            if i>=0 then
            begin
              nsResult:=GetSegSourceInfo(df,EntityId,sourceId,SegSourceInfo);
            end
            else nSResult:=ns_BadFile;

            OutputBuffer.init(NS_Query,Kns_getSegSourceInfo,false);
            OutputBuffer.write(SegSourceInfo,sizeof(SegSourceInfo));
            OutputBuffer.write(NSresult,4);         { nsResult }
            PutBuffer;
          end;

        Kns_GetSegmentData:
          begin
            buffer.ResetIndex;
            buffer.readInt(intG(df));
            buffer.readInt(EntityId);
            buffer.readInt(StartIndex);
            buffer.readInt(size);

            try
            i:=MainObjList.IndexOf(df);
            if i>=0 then
            begin
              nsResult:=GetSegmentData(df,EntityId,StartIndex,pdata,Size,timeStamp,UnitId);
            end
            else
            begin
              nSResult:=ns_BadFile;
              Size:=0;
            end;

            OutputBuffer.init(NS_Query,Kns_getAnalogInfo,false);
            OutputBuffer.write(timeStamp,8);
            OutputBuffer.writeInt(size div 8);       { }
            OutputBuffer.writeInt(UnitId);           { }
            OutputBuffer.write(pdata^,size);         { }
            OutputBuffer.write(NSresult,4);          { nsResult }
            PutBuffer;

            finally
            freemem(pdata);
            end;
          end;

        Kns_GetNeuralInfo:
          begin
            buffer.ResetIndex;
            buffer.readInt(intG(df));
            buffer.readInt(EntityId);

            i:=MainObjList.IndexOf(df);
            if i>=0
              then nsResult:=GetNeuralInfo(df,EntityId,NeuralInfo)
              else nSResult:=ns_BadFile;

            OutputBuffer.init(NS_Query,Kns_getNeuralInfo,false);
            OutputBuffer.write(NeuralInfo,sizeof(NeuralInfo));
            OutputBuffer.write(NSresult,4);         { nsResult }
            PutBuffer;

          end;

        Kns_GetNeuralData:
          begin
            buffer.ResetIndex;
            buffer.readInt(intG(df));
            buffer.readInt(EntityId);
            buffer.readInt(StartIndex);
            buffer.readInt(IndexCount);

            try
            pdata:=nil;
            i:=MainObjList.IndexOf(df);
            if i>=0 then
            begin
              getmem(pdata,IndexCount*8);
              nsResult:=GetNeuralData(df,EntityId,StartIndex,IndexCount,pdata);
            end
            else nSResult:=ns_BadFile;

            OutputBuffer.init(NS_Query,Kns_getNeuralData,false);
            OutputBuffer.write(pData^,IndexCount*8);
            OutputBuffer.write(NSresult,4);         { nsResult }
            PutBuffer;

            finally
            freemem(pdata);
            end;
          end;

        Kns_GetIndexByTime:
          begin
            buffer.ResetIndex;
            buffer.readInt(intG(df));
            buffer.readInt(EntityId);
            buffer.read( TimeStamp,8);
            buffer.readInt(Flags);

            i:=MainObjList.IndexOf(df);
            if i>=0 then
            begin
              nsResult:=GetIndexByTime(df,EntityId,TimeStamp,flags,index);
            end
            else nSResult:=ns_BadFile;

            OutputBuffer.init(NS_Query,Kns_getIndexByTime,false);
            OutputBuffer.writeInt(index);
            OutputBuffer.writeInt(NSresult);         { nsResult }
            PutBuffer;

          end;

        Kns_GetTimeByIndex:
          begin
            buffer.ResetIndex;
            buffer.readInt(intG(df));
            buffer.readInt(EntityId);
            buffer.readInt( index);

            i:=MainObjList.IndexOf(df);
            if i>=0 then
            begin
              nsResult:=GetTimeByIndex(df,EntityId,index,timeStamp);
            end
            else nSResult:=ns_BadFile;
            {
            nsResult:=0;
            timeStamp:=123;
            }
            OutputBuffer.init(NS_Query,Kns_getTimeByIndex,false);
            OutputBuffer.write(timeStamp,8);
            OutputBuffer.writeInt(NSresult);         { nsResult }
            PutBuffer;

          end;

        Kns_GetLastErrorMsg:
          begin
          end;
      end;
    finally
      buffer.free;
      //displayMem;
      //if idNum=Kns_getAnalogData then
      //begin
      //  ii2:=getHeapStatus.TotalAllocated;
      //  inc(cnt);
      //  if cnt>2 then Diff:=  Diff + ii1-ii2;
      //  statuslineTxt('Buffer='+Istr(intG(buffer))+ ' ii2='+Istr(ii2));
      //end;
    end
  until not assigned(buffer);
end;



end.
