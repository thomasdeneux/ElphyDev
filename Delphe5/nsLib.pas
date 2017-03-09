unit nsLib;

{ Correspond à nsTemplateLib }

interface
{$IFDEF FPC} {$mode delphi} {$DEFINE AcqElphy2} {$A1} {$Z1} {$ENDIF}

uses windows, nsAPItypes;

Const
  DLLname='NEURODLL1.DLL';


var
  ns_GetLibraryInfo: function( var LibraryInfo: ns_LIBRARYINFO;  dwLibraryInfoSize: uint32):ns_result;stdcall;
  ns_OpenFile: function(pszFilename: Pansichar; var hFile: uint32):ns_result;stdcall;
  ns_GetFileInfo: function (  hFile: uint32; var pFileInfo: ns_FILEINFO;  dwFileInfoSize: uint32 ):ns_result;stdcall;
  ns_CloseFile: function ( hFile: uint32):ns_result;stdcall;
  ns_GetEntityInfo: function ( hFile: uint32;  dwEntityID: uint32; var pEntityInfo: ns_ENTITYINFO;  dwEntityInfoSize: uint32):ns_result;stdcall;
  ns_GetEventInfo: function ( hFile: uint32;  dwEntityID: uint32; var pEventInfo: ns_EVENTINFO;  dwEventInfoSize: uint32):ns_result;stdcall;
  ns_GetEventData: function ( hFile: uint32;  dwEntityID: uint32;  nIndex: uint32;
                              var pdTimeStamp: double; pData: pointer;
                              dwDataBufferSize: uint32; var pdwDataRetSize: uint32):ns_result;stdcall;
  ns_GetAnalogInfo: function (  hFile: uint32;  dwEntityID: uint32;
                               var pAnalogInfo: ns_ANALOGINFO;  dwAnalogInfoSize: uint32 ):ns_result;stdcall;
  ns_GetAnalogData: function ( hFile: uint32;  dwEntityID: uint32;
                               dwStartIndex: uint32;  dwIndexCount: uint32;
                               var pdwContCount: uint32; pData: pointer):ns_result;stdcall;
  ns_GetSegmentInfo: function (  hFile: uint32;  dwEntityID: uint32;
                                 var pSegmentInfo: ns_SEGMENTINFO;  dwSegmentInfoSize: uint32):ns_result;stdcall;
  ns_GetSegmentSourceInfo: function (  hFile: uint32;  dwEntityID: uint32;  dwSourceID: uint32;
                                       var pSourceInfo: ns_SEGSOURCEINFO;
                                       dwSourceInfoSize: uint32):ns_result;stdcall;
  ns_GetSegmentData: function (  hFile: uint32;  dwEntityID: uint32;  nIndex: int32;
                                 var pdTimeStamp: double;  pData: pointer;
                                 dwDataBufferSize: uint32; var pdwSampleCount: uint32;
                                 var pdwUnitID: uint32 ):ns_result;stdcall;
  ns_GetNeuralInfo: function(  hFile: uint32;  dwEntityID: uint32;
                               var pNeuralInfo: ns_NEURALINFO;  dwNeuralInfoSize: uint32 ):ns_result;stdcall;
  ns_GetNeuralData: function(  hFile: uint32;  dwEntityID: uint32;  dwStartIndex: uint32;
                               dwIndexCount: uint32; pData: pointer ):ns_result;stdcall;
  ns_GetIndexByTime: function(  hFile: uint32;  dwEntityID: uint32;  dTime: double;
                                nFlag: int32;  var pdwIndex: uint32 ):ns_result;stdcall;
  ns_GetTimeByIndex: function( hFile: uint32;  dwEntityID: uint32;  dwIndex: uint32; var pdTime: double):ns_result;stdcall;
  ns_GetLastErrorMsg: function(pszMsgBuffer: Pansichar;  dwMsgBufferSize: uint32):ns_result;stdcall;

function InitNslib:boolean;

Implementation


const
  hh:intG=0;

function getProc(st:AnsiString):pointer;
begin
  result:=GetProcAddress(hh,Pansichar(st));
  {if result=nil then messageCentral(st+'=nil');}
  { cbMemSetDTMode renvoie NIL }
end;


function InitNslib:boolean;
begin
  result:=true;
  if hh<>0 then exit;

  hh:=GloadLibrary(DLLname);
  result:=(hh<>0);

  if not result then exit;

  ns_GetLibraryInfo:= getProc('ns_GetLibraryInfo');
  ns_OpenFile:= getProc('ns_OpenFile');
  ns_GetFileInfo:= getProc('ns_GetFileInfo');
  ns_CloseFile:= getProc('ns_CloseFile');
  ns_GetEntityInfo:= getProc('ns_GetEntityInfo');
  ns_GetEventInfo:= getProc('ns_GetEventInfo');
  ns_GetEventData:= getProc('ns_GetEventData');
  ns_GetAnalogInfo:= getProc('ns_GetAnalogInfo');
  ns_GetAnalogData:= getProc('ns_GetAnalogData');
  ns_GetSegmentInfo:= getProc('ns_GetSegmentInfo');
  ns_GetSegmentSourceInfo:= getProc('ns_GetSegmentSourceInfo');
  ns_GetSegmentData:= getProc('ns_GetSegmentData');
  ns_GetNeuralInfo:= getProc('ns_GetNeuralInfo');
  ns_GetNeuralData:= getProc('ns_GetNeuralData');
  ns_GetIndexByTime:= getProc('ns_GetIndexByTime');
  ns_GetTimeByIndex:= getProc('ns_GetTimeByIndex');
  ns_GetLastErrorMsg:= getProc('ns_GetLastErrorMsg');
end;

Initialization
AffDebug('Initialization nsLib',0);

finalization
  if hh<>0 then freeLibrary(hh);
end.

