{
 ----------------------------------------------------------------
  File - WINDRVR_INT_THREAD.PAS

  Copyright (c) 2003 Jungo Ltd.  http://www.jungo.com
 ----------------------------------------------------------------
}

unit WinDrvr_Int_Thread;

interface

uses
    Windows,
    windrvr;

type
    INT_HANDLER_FUNC = procedure(pData : POINTER);

    EVENT_HANDLER_FUNC = procedure(event : WD_EVENT; pData : POINTER);

    PWD_INTERRUPT = ^WD_INTERRUPT;

    INT_THREAD_DATA = record
        hThread : HANDLE;
        hWD : HANDLE;
        func : INT_HANDLER_FUNC;
        pData : POINTER;
        pInt : PWD_INTERRUPT;
    end;

    PINT_THREAD_DATA = ^INT_THREAD_DATA;

    EVENT_HANDLE_T = record
        func : EVENT_HANDLER_FUNC;
        hWD : HANDLE;
        pdata : POINTER;
        thread : HANDLE;
        pInt : WD_INTERRUPT;
    end;

    PEVENT_HANDLE_T = ^EVENT_HANDLE_T;
    PPEVENT_HANDLE_T = ^PEVENT_HANDLE_T;

{ OLD prototypes for backward compatibility }
function InterruptThreadEnable(phThread : PHANDLE; hWD : HANDLE; pInt : PWD_INTERRUPT; func : INT_HANDLER_FUNC; pData : POINTER) : BOOLEAN;
procedure InterruptThreadDisable(hThread : HANDLE);
function event_register(hWD : HANDLE; event : PWD_EVENT; func : EVENT_HANDLER_FUNC; pdata : Pointer) : PEVENT_HANDLE_T;
procedure event_unregister(hWD : HANDLE ; handle : PEVENT_HANDLE_T);

{ New prototypes. Functions return status. }

function InterruptEnable(phThread : PHANDLE; hWD : HANDLE; pInt : PWD_INTERRUPT; func : INT_HANDLER_FUNC; pData : POINTER) : DWORD;
function InterruptEnable1(phThread : PHANDLE; hWD : HANDLE; pInt : PWD_INTERRUPT; func : INT_HANDLER_FUNC; pData : POINTER) : DWORD;
function InterruptDisable(hThread : HANDLE) : DWORD;
function EventRegister(phThread : PPEVENT_HANDLE_T; hWD : HANDLE; event : PWD_EVENT; func : EVENT_HANDLER_FUNC; pdata : Pointer) : DWORD;
function EventUnregister(handle : PEVENT_HANDLE_T) : DWORD;


implementation

function InterruptThreadHandler(pData : POINTER) : INTEGER;
var
    pThread : PINT_THREAD_DATA;

begin
    pThread := PINT_THREAD_DATA (pData);
    while True do
    begin
        WD_IntWait(pThread^.hWD, pThread^.pInt^);
        if pThread^.pInt^.fStopped = 1
        then
            Break;
        pThread^.func(pThread^.pData);
    end;
    InterruptThreadHandler := 0;
end;

function InterruptThreadHandler1(pData : POINTER) : INTEGER;stdCall;
var
    pThread : PINT_THREAD_DATA;

begin
    pThread := PINT_THREAD_DATA (pData);
    while True do
    begin
        WD_IntWait(pThread^.hWD, pThread^.pInt^);
        if pThread^.pInt^.fStopped = 1
        then
            Break;
        pThread^.func(pThread^.pData);
    end;
    InterruptThreadHandler1 := 0;
end;


function InterruptThreadEnable(phThread : PHANDLE; hWD : HANDLE; pInt : PWD_INTERRUPT; func : INT_HANDLER_FUNC; pData : POINTER) : BOOLEAN;
var
    dwStatus : DWORD;
begin
    dwStatus := InterruptEnable(phThread, hWD, pInt, func, pData);
    if dwStatus=0
    then
        InterruptThreadEnable := True
    else
        InterruptThreadEnable := False
end;

function InterruptEnable(phThread : PHANDLE; hWD : HANDLE; pInt : PWD_INTERRUPT; func : INT_HANDLER_FUNC; pData : POINTER) : DWORD;
var
    pThread : ^INT_THREAD_DATA;
    dwStatus : DWORD;

begin
    phThread^ := 0;

    dwStatus := WD_IntEnable(hWD, pInt^);
    { check if WD_IntEnable failed }
    if dwStatus>0
    then
    begin
        InterruptEnable := dwStatus;
        Exit;
    end;

    GetMem(POINTER(pThread), SizeOf(INT_THREAD_DATA));
    pThread^.func := func;
    pThread^.pData := pData;
    pThread^.hWD := hWD;
    pThread^.pInt := pInt;
    pThread^.hThread := BeginThread (nil, $1000, InterruptThreadHandler, POINTER(pThread), 0, WinDriverGlobalDW);
    phThread^ := HANDLE (pThread);
    InterruptEnable := WD_STATUS_SUCCESS;
end;


function InterruptEnable1(phThread : PHANDLE; hWD : HANDLE; pInt : PWD_INTERRUPT; func : INT_HANDLER_FUNC; pData : POINTER) : DWORD;
var
    pThread : ^INT_THREAD_DATA;
    dwStatus : DWORD;

begin
    phThread^ := 0;

    dwStatus := WD_IntEnable(hWD, pInt^);
    { check if WD_IntEnable failed }
    if dwStatus>0
    then
    begin
        InterruptEnable1 := dwStatus;
        Exit;
    end;

    GetMem(POINTER(pThread), SizeOf(INT_THREAD_DATA));
    pThread^.func := func;
    pThread^.pData := pData;
    pThread^.hWD := hWD;
    pThread^.pInt := pInt;
    pThread^.hThread := createThread (nil, $1000, @InterruptThreadHandler1, POINTER(pThread), 0, WinDriverGlobalDW);

    setThreadPriority(pThread^.hThread,THREAD_PRIORITY_TIME_CRITICAL);	
    phThread^ := HANDLE (pThread);
    InterruptEnable1 := WD_STATUS_SUCCESS;
end;

procedure InterruptThreadDisable(hThread : HANDLE);
begin
    InterruptDisable(hThread);
end;

function InterruptDisable(hThread : HANDLE) : DWORD;
var
    pThread : PINT_THREAD_DATA;
begin
    if hThread=0
    then
    begin
        InterruptDisable := WD_INVALID_HANDLE;
    end;
    pThread := PINT_THREAD_DATA (hThread);
    InterruptDisable := WD_IntDisable(pThread^.hWD, pThread^.pInt^);
    WaitForSingleObject(pThread^.hThread, INFINITE);
    CloseHandle(pThread^.hThread);
    Freemem(pThread);
end;

function EventHandler(pData : Pointer) : integer;
Var
    handle : PEVENT_HANDLE_T;
    pull :WD_EVENT;

Begin
    handle := PEVENT_HANDLE_T(pData);
    pull.handle := handle.pInt.hInterrupt;
    WD_EventPull(handle.hWD, @pull);

    if (pull.dwAction <> 0) then
        handle.func(pull, handle.pdata);

    if (pull.dwOptions = WD_ACKNOWLEDGE) then
        WD_EventSend(handle.hWD, @pull);
end;

function event_register(hWD : HANDLE; event : PWD_EVENT; func : EVENT_HANDLER_FUNC; pdata : Pointer) : PEVENT_HANDLE_T;
var
    pEvent : PEVENT_HANDLE_T;
begin
    EventRegister(@pEvent, hWD, event, func, pdata);
    event_register := pEvent;
end;

function EventRegister(phThread : PPEVENT_HANDLE_T; hWD : HANDLE; event : PWD_EVENT; func : EVENT_HANDLER_FUNC; pdata : Pointer) : DWORD;
Var
        handle : PEVENT_HANDLE_T;
        wdevent : WD_EVENT;
        dwStatus : DWORD;
label Error;
Begin
        phThread^ := nil;
        handle := nil;
        getmem(handle,sizeof(EVENT_HANDLE_T));
        if (handle = nil) then
        begin
            EventRegister := WD_INSUFFICIENT_RESOURCES;
            goto Error;
        end;
        fillchar(handle^,sizeof(EVENT_HANDLE_T),0);
        handle^.func := func;
        handle^.hWD := hWD;
        handle^.pdata := pdata;
        fillchar(wdevent,sizeof(WD_EVENT),0);
        event^.dwOptions := WD_ACKNOWLEDGE;
        wdevent := event^;
        EventRegister := WD_EventRegister(hWD, @wdevent);
        if (wdevent.handle = 0) then
            goto Error;
        handle^.pInt.hInterrupt := wdevent.handle;
        dwStatus := InterruptEnable(@handle^.thread, hWD, @handle.pInt,
            @EventHandler, Pointer(handle));
        EventRegister := dwStatus;
        if dwStatus=WD_STATUS_SUCCESS
        then
        begin
            phThread^ := handle;
            Exit;
        end;

Error:
        if ((handle <> nil) and (handle.pInt.hInterrupt <> 0)) then
            WD_EventUnregister(hWD, @event_register);
        if (handle <> nil) then
            freemem(handle);
End;

procedure event_unregister(hWD : HANDLE ; handle : PEVENT_HANDLE_T);
begin
    EventUnregister(handle);
end;

function EventUnregister(handle : PEVENT_HANDLE_T) : DWORD;
Var
    event : WD_EVENT;
begin
    event.handle := handle.pInt.hInterrupt;
    InterruptDisable(handle.thread);
    EventUnregister := WD_EventUnregister(handle^.hWD, @event);
    freemem(handle);
end;

end.

