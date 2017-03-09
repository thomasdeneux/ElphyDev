unit NeuroShareElphy1;

interface
{$IFDEF FPC} {$mode delphi} {$DEFINE AcqElphy2} {$A1} {$Z1} {$ENDIF}

uses windows, sysUtils,
     util1,nsAPItypes, stmTCPIP1light ;



var
  Client:TclientA;

function InitNeuroShareElphy:boolean;
procedure EndNeuroShareElphy;

function ns_GetLibraryInfo( LibraryInfo: Pns_LIBRARYINFO;  dwLibraryInfoSize: uint32):ns_result;stdcall;
function ns_OpenFile(pszFilename: Pansichar; var hFile: uint32):ns_Result;stdcall;
function ns_GetFileInfo (  hFile: uint32; FileInfo: Pns_FILEINFO;  dwFileInfoSize: uint32 ):ns_Result;stdcall;
function ns_CloseFile ( hFile: uint32):ns_Result;stdcall;
function ns_GetEntityInfo ( hFile: uint32;  dwEntityID: uint32; EntityInfo: Pns_ENTITYINFO;  dwEntityInfoSize: uint32):ns_Result;stdcall;
function ns_GetEventInfo ( hFile: uint32;  dwEntityID: uint32; EventInfo: Pns_EVENTINFO;  dwEventInfoSize: uint32):ns_Result;stdcall;
function ns_GetEventData ( hFile: uint32;  dwEntityID: uint32;  nIndex: uint32; dTimeStamp: Pdouble; pData: pointer;
                            dwDataBufferSize: uint32; dwDataRetSize: Plongword):ns_Result;stdcall;
function ns_GetAnalogInfo (  hFile: uint32;  dwEntityID: uint32;
                             AnalogInfo: Pns_ANALOGINFO;  dwAnalogInfoSize: uint32 ):ns_Result;stdcall;
function ns_GetAnalogData ( hFile: uint32;  dwEntityID: uint32;
                            dwStartIndex: uint32;  dwIndexCount: uint32;
                            dwContCount: PlongWord; pData: pointer):ns_Result;stdcall;
function ns_GetSegmentInfo (  hFile: uint32;  dwEntityID: uint32;
                              SegmentInfo: Pns_SEGMENTINFO;  dwSegmentInfoSize: uint32):ns_Result;stdcall;
function ns_GetSegmentSourceInfo (  hFile: uint32;  dwEntityID: uint32;  dwSourceID: uint32;
                                    SourceInfo: Pns_SEGSOURCEINFO;
                                    dwSourceInfoSize: uint32):ns_Result;stdcall;
function ns_GetSegmentData (  hFile: uint32;  dwEntityID: uint32;  nIndex: int32;
                              dTimeStamp: Pdouble;  pData: pointer;
                               dwDataBufferSize: uint32; dwSampleCount: Plongword;
                               dwUnitID: Plongword ):ns_Result;stdcall;
function ns_GetNeuralInfo(  hFile: uint32;  dwEntityID: uint32;
                            NeuralInfo: Pns_NEURALINFO;  dwNeuralInfoSize: uint32 ):ns_Result;stdcall;
function ns_GetNeuralData(  hFile: uint32;  dwEntityID: uint32;  dwStartIndex: uint32;
                             dwIndexCount: uint32; pData: pointer ):ns_Result;stdcall;
function ns_GetIndexByTime(  hFile: uint32;  dwEntityID: uint32;  dTime: double;
                             nFlag: int32;  var dwIndex: uint32 ):ns_Result;stdcall;
function ns_GetTimeByIndex( hFile: uint32;  dwEntityID: uint32;  dwIndex: uint32; var dTime: double):ns_Result;stdcall;
function ns_GetLastErrorMsg(pszMsgBuffer: Pansichar;  dwMsgBufferSize: uint32):ns_Result;stdcall;


implementation

Const
  ComDelay=5000; { On attend cinq secondes la réponse de Elphy }

function IntMin(a,b:integer):integer;
begin
  if a<b
    then result:=a
    else result:=b;
end;

function InitNeuroShareElphy:boolean;
var
  processInfo:TprocessInformation;
  startUp:TstartUpInfo;
  flags:Dword;

  stF1,stF2:AnsiString;
  stPath:AnsiString;
  hSem:integer;
begin
  stPath:=extractFilePath(getModuleName(hInstance));

  flags:=0;
  fillchar(startUp,sizeof(startUp),0);
  startUp.cb:=sizeof(startUp);

  stF1:=stPath+'elphy2.exe';
  stF2:=stPath+'elphy2.exe ns_server';

  hsem:=CreateSemaphore(nil,0,1,'Elphy NsServer SEM');

  result:= createProcess(Pansichar(stF1),Pansichar(stF2),nil,nil,false,Flags,nil,nil,startUp,processInfo);
  if not result then exit;

  WaitForSingleObject(hSem,20000);

  client:=TclientA.create;
  client.setup('',DefaultServerPort,true);

end;

procedure EndNeuroShareElphy;
begin
  with client do
  begin
    with currentBuffer do
    begin
      clear;
      ident:=Sys_Command;
      idNum:=sys_Quit;
    end;
    sendBuffer;
  end;
  delay(1000);
end;

function ns_GetLibraryInfo( LibraryInfo: Pns_LIBRARYINFO;  dwLibraryInfoSize: uint32):ns_result;
begin
  result:=ns_libError;
  if not assigned(LibraryInfo) or (libraryInfo=pointer(-1)) then exit;

  result:=ns_OK;
  try
  fillchar(LibraryInfo^,sizeof(LibraryInfo^),0);
  with LibraryInfo^ do
  begin
    dwLibVersionMaj :=1;                           // Major version number of library
    dwLibVersionMin := 1;                          // Minor version number of library
    dwAPIVersionMaj := 1;                          // Major version number of API
    dwAPIVersionMin := 1;	                   // Minor version number of API
    StringToPchar('Elphy Files Management',64,szDescription);  // Text description of the library
    StringToPchar('Gérard Sadoc UNIC-CNRS',64,szCreator);       // Name of library creator
    dwTime_Year := 2009;                           // Year of last modification date
    dwTime_Month := 4;                             // Month (0-11; January = 0) of last modification date
    dwTime_Day :=15 ;                              // Day of the month (1-31) of last modification date
    dwFlags := 0;                                   // Additional library flags
    dwMaxFiles := 1;                                // Maximum number of files library can simultaneously open
    dwFileDescCount := 1;                           // Number of valid description entries in the following array
    StringToPchar('',32,FileDesc[1].szDescription);
    StringToPchar('',8,FileDesc[1].szExtension);
    StringToPchar('',8,FileDesc[1].szMacCodes);
    StringToPchar('',16,FileDesc[1].szMagicCode);
  end;

  except
    result:=ns_libError;
  end;
end;

function ns_OpenFile(pszFilename: Pansichar; var hFile: uint32):ns_Result;
var
  tt:integer;
begin
  with client do
  begin
    with currentBuffer do
    begin
      init(NS_Command, KNS_openFile, false);
      writeString(pszFileName);      { Nom du fichier }
    end;
    sendBuffer;

    tt:=getTickCount;
    repeat
      currentBuffer.init(NS_Query, KNS_openFile, true); { Attendre la réponse }
      sendBuffer;
      if currentBuffer.ident=sys_NONE then delay(10);
    until (currentBuffer.ident<>sys_NONE) or (getTickCount-tt>ComDelay*120);      { Cinq minutes pour ouvrir le dialogue ?}

    if currentBuffer.ident<>sys_NONE then
    begin
      currentBuffer.read(hFile,4);     { Si OK ,lire hFile }
      currentBuffer.read(result,4);    { et NSresult }
    end;
  end;
end;

function ns_GetFileInfo (  hFile: uint32; FileInfo: Pns_FILEINFO;  dwFileInfoSize: uint32 ):ns_Result;
var
  tt:integer;
begin
  result:= ns_libError;
  if not assigned(FileInfo) then exit;

  try
  result:=ns_OK;
  fillchar(FileInfo^,sizeof(FileInfo^),0);

  with client do
  begin
    with currentBuffer do
    begin
      init(NS_Command, KNS_getFileInfo, false);
      writeInt(hFile);
    end;
    sendBuffer;

    tt:=getTickCount;
    repeat
      currentBuffer.init(NS_Query, KNS_getFileInfo, true); { Attendre la réponse }
      sendBuffer;
      if currentBuffer.ident=sys_NONE then delay(10);
    until (currentBuffer.ident<>sys_NONE) or (getTickCount-tt>ComDelay);

    if currentBuffer.ident<>sys_NONE then
    begin
      currentBuffer.ResetIndex;
      currentBuffer.ReadAndSkip(FileInfo^, sizeof(fileInfo^),dwFileInfoSize);
      currentBuffer.read(result,4);    { et NSresult }

    {  messageCentral(Estr(fileInfo^.dTimeStampResolution,3));
    }
    end;


  end;

  except
  result:= ns_libError;
  end;
end;


function ns_CloseFile ( hFile: uint32):ns_Result;
var
  tt:integer;
begin
  try
  with client do
  begin
    with currentBuffer do
    begin
      init(NS_Command, KNS_CloseFile, false);
      writeInt(hFile);
    end;
    sendBuffer;

    tt:=getTickCount;
    repeat
      currentBuffer.init(NS_Query, KNS_CloseFile, true); { Attendre un NS_Query }
      sendBuffer;
      if currentBuffer.ident=sys_NONE then delay(10);
    until (currentBuffer.ident<>sys_NONE) or (getTickCount-tt>ComDelay);

    if currentBuffer.ident<>sys_NONE then
    begin
      currentBuffer.read(result,4);     { Si OK ,lire NSresult }
    end;
  end;

  except
  result:= ns_libError;
  end;
end;


function ns_GetEntityInfo ( hFile: uint32;  dwEntityID: uint32; EntityInfo: Pns_ENTITYINFO;  dwEntityInfoSize: uint32):ns_Result;
var
  tt:integer;
begin
  result:=ns_libError;
  if not assigned(EntityInfo) then exit;

  try
  with client do
  begin
    with currentBuffer do
    begin
      init(NS_Command, KNS_GetEntityInfo, false);
      writeInt(hFile);
      writeInt(dwEntityId);
    end;
    sendBuffer;

    tt:=getTickCount;
    repeat
      currentBuffer.init(NS_Query, KNS_GetEntityInfo, true); { Attendre un NS_Query }
      sendBuffer;
      if currentBuffer.ident=sys_NONE then delay(10);
    until (currentBuffer.ident<>sys_NONE) or (getTickCount-tt>ComDelay);

    if currentBuffer.ident<>sys_NONE then
    begin
      currentBuffer.readAndSkip(EntityInfo^,sizeof(EntityInfo^), dwEntityInfoSize);
      currentBuffer.read(result,4);     { Si OK ,lire NSresult }
      {messageCentral('EntityInfo '+Istr(dwEntityId)+' Count='+Istr(entityInfo^.dwItemCount));}
    end;
  end;

  except
  result:= ns_libError;
  end;
end;


function ns_GetEventInfo (hFile: uint32;  dwEntityID: uint32; EventInfo: Pns_EVENTINFO;  dwEventInfoSize: uint32):ns_Result;
var
  tt:integer;
begin
  result:=ns_libError;
  if not assigned(EventInfo) then exit;

  try
  with client do
  begin
    with currentBuffer do
    begin
      init(NS_Command, KNS_GetEventInfo, false);
      writeInt(hFile);                                                     { File Handle }
      writeInt(dwEntityId);                                                { Entity Num }
    end;
    sendBuffer;

    tt:=getTickCount;
    repeat
      currentBuffer.init(NS_Query, KNS_GetEventInfo, true); { Attendre un NS_Query }
      sendBuffer;
      if currentBuffer.ident=sys_NONE then delay(10);
    until (currentBuffer.ident<>sys_NONE) or (getTickCount-tt>ComDelay);

    if currentBuffer.ident<>sys_NONE then
    begin
      currentBuffer.readAndSkip(EventInfo^,sizeof(EventInfo^),dwEventInfoSize);    { EventInfo }
      currentBuffer.read(result,4);     { Si OK ,lire NSresult }                   { nsResult }
    end;
  end;

  except
    result:=ns_libError;
  end;
end;


function ns_GetEventData ( hFile: uint32;  dwEntityID: uint32;  nIndex: uint32;
                           dTimeStamp: Pdouble; pData: pointer;
                           dwDataBufferSize: uint32; dwDataRetSize: Plongword):ns_Result;
var
  tt:integer;
  dTime1:double;
  retSize:longword;
begin
  if not assigned(Pdata) then dwDataBufferSize:=0;

  TRY
  with client do
  begin
    with currentBuffer do
    begin
      init(NS_Command, KNS_GetEventData, false);
      writeInt(hFile);                                                     { File Handle }
      writeInt(dwEntityId);                                                { Entity Num }
      writeInt(nIndex);                                                    { Index }
      writeInt(dwDataBufferSize);
    end;
    sendBuffer;

    tt:=getTickCount;
    repeat
      currentBuffer.init(NS_Query, KNS_GetEventData, true); { Attendre un NS_Query }
      sendBuffer;
      if currentBuffer.ident=sys_NONE then delay(10);
    until (currentBuffer.ident<>sys_NONE) or (getTickCount-tt>ComDelay);

    if currentBuffer.ident<>sys_NONE then
    with currentBuffer do
    begin
      read(dTime1,8);
      read(RetSize,4);
      readAndSkip(pData^,dwDataBufferSize,RetSize);    { EventInfo }
      currentBuffer.read(result,4);     { Si OK ,lire NSresult }                 { nsResult }

      if assigned(dTimeStamp) then dTimeStamp^:=dTime1;
      if assigned(dwDataRetSize) then dwDataRetSize^:=retSize;
    end;
  end;

  except
    result:=ns_libError;
  end;
end;


function ns_GetAnalogInfo (  hFile: uint32;  dwEntityID: uint32;
                             AnalogInfo: Pns_ANALOGINFO;  dwAnalogInfoSize: uint32 ):ns_Result;
var
  tt:integer;
begin
  result:=ns_libError;
  if not assigned(AnalogInfo) then exit;

  TRY
  with client do
  begin
    with currentBuffer do
    begin
      init(NS_Command, KNS_GetAnalogInfo, false);
      writeInt(hFile);                                                     { File Handle }
      writeInt(dwEntityId);                                                { Entity Num }
    end;
    sendBuffer;

    tt:=getTickCount;
    repeat
      currentBuffer.init(NS_Query, KNS_GetAnalogInfo, true); { Attendre un NS_Query }
      sendBuffer;
      if currentBuffer.ident=sys_NONE then delay(10);
    until (currentBuffer.ident<>sys_NONE) or (getTickCount-tt>ComDelay);

    if currentBuffer.ident<>sys_NONE then
    begin
      currentBuffer.readAndSkip(AnalogInfo^,sizeof(AnalogInfo^),dwAnalogInfoSize); { AnalogInfo }
      {messageCentral( Estr(AnalogInfo^.dResolution,3));}
      currentBuffer.read(result,4);     { Si OK ,lire NSresult }                 { nsResult }
    end;
  end;

  except
    result:=ns_libError;
  end;
end;


function ns_GetAnalogData ( hFile: uint32;  dwEntityID: uint32;
                            dwStartIndex: uint32;  dwIndexCount: uint32;
                            dwContCount: PlongWord; pData: pointer):ns_Result;
var
  tt:integer;
begin
  if not assigned(pData) then dwIndexCount:=0;
  result:=ns_libError;

  TRY
  with client do
  begin
    with currentBuffer do
    begin
      init(NS_Command, KNS_GetAnalogData, false);
      writeInt(hFile);                                                     { File Handle }
      writeInt(dwEntityId);                                                { Entity Num }
      writeInt(dwStartIndex);                                              { Start Index }
      writeInt(dwIndexCount);                                              { Index count }
    end;
    sendBuffer;

    tt:=getTickCount;
    repeat
      currentBuffer.init(NS_Query, KNS_GetAnalogData, true); { Attendre un NS_Query }
      sendBuffer;
      if currentBuffer.ident=sys_NONE then delay(10);
    until (currentBuffer.ident<>sys_NONE) or (getTickCount-tt>ComDelay);

    if currentBuffer.ident<>sys_NONE then
    with currentBuffer do
    begin
      read(tt,4);
      readAndSkip(pData^,dwIndexCount*8,tt*8);    { EventInfo }
      currentBuffer.read(result,4);                        { nsResult }
      //dwContCount:=0;
    end;
  end;

  except
    result:=ns_libError;
  end;
end;


function ns_GetSegmentInfo (  hFile: uint32;  dwEntityID: uint32;
                              SegmentInfo: Pns_SEGMENTINFO;  dwSegmentInfoSize: uint32):ns_Result;
var
  tt:integer;
begin
  result:=ns_LibError;
  if not assigned(SegmentInfo) then exit;

  TRY
  with client do
  begin
    with currentBuffer do
    begin
      init(NS_Command, KNS_GetSegmentInfo, false);
      writeInt(hFile);                                                     { File Handle }
      writeInt(dwEntityId);                                                { Entity Num }
    end;
    sendBuffer;

    tt:=getTickCount;
    repeat
      currentBuffer.init(NS_Query, KNS_GetSegmentInfo, true);              { Attendre un NS_Query }
      sendBuffer;
      if currentBuffer.ident=sys_NONE then delay(10);
    until (currentBuffer.ident<>sys_NONE) or (getTickCount-tt>ComDelay);

    if currentBuffer.ident<>sys_NONE then
    begin
      currentBuffer.readAndSkip(SegmentInfo^,sizeof(SegmentInfo^),dwSegmentInfoSize); { SegmentInfo }
      currentBuffer.read(result,4);     { Si OK ,lire NSresult }                    { nsResult }
    end;
  end;

  except
    result:=ns_libError;
  end;
end;


function ns_GetSegmentSourceInfo (  hFile: uint32;  dwEntityID: uint32;  dwSourceID: uint32;
                                    SourceInfo: Pns_SEGSOURCEINFO;
                                    dwSourceInfoSize: uint32):ns_Result;
var
  tt:integer;
begin
  result:= ns_LibError;
  if not assigned(sourceInfo) then exit;

  TRY
  with client do
  begin
    with currentBuffer do
    begin
      init(NS_Command, KNS_GetSegSourceInfo, false);
      writeInt(hFile);                                                     { File Handle }
      writeInt(dwEntityId);                                                { Entity Num }
      writeInt(dwSourceId);                                                { Entity Num }
    end;
    sendBuffer;

    tt:=getTickCount;
    repeat
      currentBuffer.init(NS_Query, KNS_GetSegSourceInfo, true);              { Attendre un NS_Query }
      sendBuffer;
      if currentBuffer.ident=sys_NONE then delay(10);
    until (currentBuffer.ident<>sys_NONE) or (getTickCount-tt>ComDelay);

    if currentBuffer.ident<>sys_NONE then
    begin
      currentBuffer.readAndSkip(SourceInfo^,sizeof(SourceInfo^),dwSourceInfoSize); { SourceInfo }
      {
      sourceInfo.dMinVal:=-0.1;
      sourceInfo.dMaxVal:= 0.1;
      }
      currentBuffer.read(result,4);     { Si OK ,lire NSresult }                 { nsResult }
    end;
  end;

  except
    result:=ns_libError;
  end;

end;


function ns_GetSegmentData (  hFile: uint32;  dwEntityID: uint32;  nIndex: int32;
                              dTimeStamp: Pdouble;  pData: pointer;
                               dwDataBufferSize: uint32; dwSampleCount: Plongword;
                               dwUnitID: Plongword ):ns_Result;
var
  dTime1:double;
  tt:integer;
  dwUnitId1:integer;
begin
  result:=ns_libError;
  if not assigned(pData) then dwDataBufferSize:=0;


  with client do
  begin
    with currentBuffer do
    begin
      init(NS_Command, KNS_GetSegmentData, false);
      writeInt(hFile);                                       { File Handle }
      writeInt(dwEntityId);                                  { Entity Num }
      writeInt(nIndex);                                      { Index }
      writeInt(dwDataBufferSize);                            { BufferSize in bytes}
    end;
    sendBuffer;

    tt:=getTickCount;
    repeat
      currentBuffer.init(NS_Query, KNS_GetSegmentData, true); { Attendre un NS_Query }
      sendBuffer;
      if currentBuffer.ident=sys_NONE then delay(10);
    until (currentBuffer.ident<>sys_NONE) or (getTickCount-tt>ComDelay);

    if currentBuffer.ident<>sys_NONE then
    with currentBuffer do
    begin
      read(dTime1,8);                                        { Time Stamp }
      read(tt,4);                                            { Total Sample Count }
      read(dwUnitId1,4);                                     { Unit Id }
      readAndSkip(pData^,dwDataBufferSize,tt*8);             { SegmentInfo }
      currentBuffer.read(result,4);                          { nsResult }

      if dTimeStamp<>nil then dTimeStamp^:=dTime1;
      if dwSampleCount<>nil then dwSampleCount^:=tt;
      if dwUnitId<>nil then dwUnitId^:=dwUnitId1;

    end;
  end;
end;


function ns_GetNeuralInfo(  hFile: uint32;  dwEntityID: uint32;
                            NeuralInfo: Pns_NEURALINFO;  dwNeuralInfoSize: uint32 ):ns_Result;
var
  tt:integer;
begin
  if not assigned(NeuralInfo) then
  begin
    result:=ns_LibError;
    exit;
  end;

  TRY
  with client do
  begin
    with currentBuffer do
    begin
      init(NS_Command, KNS_GetNeuralInfo, false);
      writeInt(hFile);                                                     { File Handle }
      writeInt(dwEntityId);                                                { Entity Num }
    end;
    sendBuffer;

    tt:=getTickCount;
    repeat
      currentBuffer.init(NS_Query, KNS_GetNeuralInfo, true);              { Attendre un NS_Query }
      sendBuffer;
      if currentBuffer.ident=sys_NONE then delay(10);
    until (currentBuffer.ident<>sys_NONE) or (getTickCount-tt>ComDelay);

    if currentBuffer.ident<>sys_NONE then
    begin
      currentBuffer.readAndSkip(NeuralInfo^,sizeof(NeuralInfo^),dwNeuralInfoSize); { NeuralInfo }
      currentBuffer.read(result,4);     { Si OK ,lire NSresult }                   { nsResult }
    end;
  end;

  except
    result:=ns_LibError;
  end;
end;


function ns_GetNeuralData(  hFile: uint32;  dwEntityID: uint32;  dwStartIndex: uint32;
                             dwIndexCount: uint32; pData: pointer ):ns_Result;
var
  tt:integer;
begin
  if not assigned(pdata) then dwIndexCount:=0;

  TRY
  with client do
  begin
    with currentBuffer do
    begin
      init(NS_Command, KNS_GetNeuralData, false);
      writeInt(hFile);                                       { File Handle }
      writeInt(dwEntityId);                                  { Entity Num }
      writeInt(dwStartIndex);                                { Start Index }
      writeInt(dwIndexCount);                                { Index count }
    end;
    sendBuffer;

    tt:=getTickCount;
    repeat
      currentBuffer.init(NS_Query, KNS_GetNeuralData, true); { Attendre un NS_Query }
      sendBuffer;
      if currentBuffer.ident=sys_NONE then delay(10);
    until (currentBuffer.ident<>sys_NONE) or (getTickCount-tt>ComDelay);

    if currentBuffer.ident<>sys_NONE then
    with currentBuffer do
    begin
      read(pData^,dwIndexCount*8);                           { data }
      currentBuffer.read(result,4);                          { nsResult }
    end;
  end;

  except
    result:=ns_LibError;
  end;
end;


function ns_GetIndexByTime(  hFile: uint32;  dwEntityID: uint32;  dTime: double;
                             nFlag: int32;  var dwIndex: uint32 ):ns_Result;
var
  tt:integer;
begin
  with client do
  begin
    with currentBuffer do
    begin
      init(NS_Command, KNS_GetIndexByTime, false);
      writeInt(hFile);                                       { File Handle }
      writeInt(dwEntityId);                                  { Entity Num }
      write(dTime,8);                                        { Time }
      writeInt(nFlag);                                       { Flags }
    end;
    sendBuffer;

    tt:=getTickCount;
    repeat
      currentBuffer.init(NS_Query, KNS_GetIndexByTime, true); { Attendre un NS_Query }
      sendBuffer;
      if currentBuffer.ident=sys_NONE then delay(10);
    until (currentBuffer.ident<>sys_NONE) or (getTickCount-tt>ComDelay);

    if currentBuffer.ident<>sys_NONE then
    with currentBuffer do
    begin
      read(dwIndex,4);                                       { Index }
      currentBuffer.read(result,4);                          { nsResult }
    end;
  end;
end;


function ns_GetTimeByIndex( hFile: uint32;  dwEntityID: uint32;  dwIndex: uint32; var dTime: double):ns_Result;
var
  tt:integer;
begin
  with client do
  begin
    with currentBuffer do
    begin
      init(NS_Command, KNS_GetTimeByIndex, false);
      writeInt(hFile);                                       { File Handle }
      writeInt(dwEntityId);                                  { Entity Num }
      writeInt(dwIndex);                                     { Index }
    end;
    sendBuffer;

    tt:=getTickCount;
    repeat
      currentBuffer.init(NS_Query, KNS_GetTimeByIndex, true); { Attendre un NS_Query }
      sendBuffer;
      if currentBuffer.ident=sys_NONE then delay(10);
    until (currentBuffer.ident<>sys_NONE) or (getTickCount-tt>ComDelay);

    if currentBuffer.ident<>sys_NONE then
    with currentBuffer do
    begin
      read(dTime,8);                                         { Time }
      currentBuffer.read(result,4);                          { nsResult }
    end;
  end;
end;


function ns_GetLastErrorMsg(pszMsgBuffer: Pansichar;  dwMsgBufferSize: uint32):ns_Result;
var
  tt:integer;
  st:AnsiString;
begin
  with client do
  begin
    with currentBuffer do
    begin
      init(NS_Command, KNS_GetLastErrorMsg, false);
    end;
    sendBuffer;

    tt:=getTickCount;
    repeat
      currentBuffer.init(NS_Query, KNS_GetLastErrorMsg, true); { Attendre un NS_Query }
      sendBuffer;
      if currentBuffer.ident=sys_NONE then delay(10);
    until (currentBuffer.ident<>sys_NONE) or (getTickCount-tt>ComDelay);

    if currentBuffer.ident<>sys_NONE then
    with currentBuffer do
    begin
      st:=readString;
      StringToPchar(st,dwMsgBufferSize,pszMsgBuffer^);
      currentBuffer.read(result,4);                          { nsResult }
    end;
  end;
end;



end.
