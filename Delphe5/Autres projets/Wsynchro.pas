
{   Wsynchro contient
       - syncObjs de Delphi version 4
       - l'objet TMultiReadExclusiveWriteSynchronizer qui se trouve
         dans sysutils de Delphi version 4
}

unit Wsynchro;

interface

uses Sysutils, Windows, Messages, Classes;

type
  TSynchroObject = class(TObject)
  public
    procedure Acquire; virtual;
    procedure Release; virtual;
  end;

  THandleObject = class(TSynchroObject)
  private
    FHandle: THandle;
    FLastError: Integer;
  public
    destructor Destroy; override;
    property LastError: Integer read FLastError;
    property Handle: THandle read FHandle;
  end;

  TWaitResult = (wrSignaled, wrTimeout, wrAbandoned, wrError);

  TEvent = class(THandleObject)
  public
    constructor Create(EventAttributes: PSecurityAttributes; ManualReset,
      InitialState: Boolean; const Name: string);
    function WaitFor(Timeout: DWORD): TWaitResult;
    procedure SetEvent;
    procedure ResetEvent;
  end;

  TSimpleEvent = class(TEvent)
  public
    constructor Create;
  end;

  TCriticalSection = class(TSynchroObject)
  private
    FSection: TRTLCriticalSection;
  public
    constructor Create;
    destructor Destroy; override;
    procedure Acquire; override;
    procedure Release; override;
    procedure Enter;
    procedure Leave;
  end;

{ Thread synchronization }

{ TMultiReadExclusiveWriteSynchronizer minimizes thread serialization to gain
  read access to a resource shared among threads while still providing complete
  exclusivity to callers needing write access to the shared resource.
  (multithread shared reads, single thread exclusive write)
  Reading is allowed while owning a write lock.
  Read locks can be promoted to write locks.}

type
  TActiveThreadRecord = record
    ThreadID: Integer;
    RecursionCount: Integer;
  end;
  TActiveThreadArray = array[0..99] of TActiveThreadRecord;
    { à l'origine, on avait array of TActiveThreadRecord; }

  TMultiReadExclusiveWriteSynchronizer = class
  private
    FLock: TRTLCriticalSection;
    FReadExit: THandle;
    FCount: Integer;
    FSaveReadCount: Integer;
    FActiveThreads: TActiveThreadArray;
    FWriteRequestorID: Integer;
    FReallocFlag: Integer;
    FWriting: Boolean;
    FTlen:integer; {ajouté}
    function WriterIsOnlyReader: Boolean;
  public
    constructor Create;
    destructor Destroy; override;
    procedure BeginRead;
    procedure EndRead;
    procedure BeginWrite;
    procedure EndWrite;
  end;



implementation

{ TSynchroObject }

procedure TSynchroObject.Acquire;
begin
end;

procedure TSynchroObject.Release;
begin
end;

{ THandleObject }

destructor THandleObject.Destroy;
begin
  CloseHandle(FHandle);
  inherited Destroy;
end;

{ TEvent }

constructor TEvent.Create(EventAttributes: PSecurityAttributes; ManualReset,
  InitialState: Boolean; const Name: string);
begin
  FHandle := CreateEvent(EventAttributes, ManualReset, InitialState, PChar(Name));
end;

function TEvent.WaitFor(Timeout: DWORD): TWaitResult;
begin
  case WaitForSingleObject(Handle, Timeout) of
    WAIT_ABANDONED: Result := wrAbandoned;
    WAIT_OBJECT_0: Result := wrSignaled;
    WAIT_TIMEOUT: Result := wrTimeout;
    WAIT_FAILED:
      begin
        Result := wrError;
        FLastError := GetLastError;
      end;
  else
    Result := wrError;    
  end;
end;

procedure TEvent.SetEvent;
begin
  Windows.SetEvent(Handle);
end;

procedure TEvent.ResetEvent;
begin
  Windows.ResetEvent(Handle);
end;

{ TSimpleEvent }

constructor TSimpleEvent.Create;
begin
  FHandle := CreateEvent(nil, True, False, nil);
end;

{ TCriticalSection }

constructor TCriticalSection.Create;
begin
  inherited Create;
  InitializeCriticalSection(FSection);
end;

destructor TCriticalSection.Destroy;
begin
  DeleteCriticalSection(FSection);
  inherited Destroy;
end;

procedure TCriticalSection.Acquire;
begin
  EnterCriticalSection(FSection);
end;

procedure TCriticalSection.Release;
begin
  LeaveCriticalSection(FSection);
end;

procedure TCriticalSection.Enter;
begin
  Acquire;
end;

procedure TCriticalSection.Leave;
begin
  Release;
end;

{ TMultiReadExclusiveWriteSynchronizer }

constructor TMultiReadExclusiveWriteSynchronizer.Create;
begin
  inherited Create;
  InitializeCriticalSection(FLock);
  FReadExit := CreateEvent(nil, True, True, nil);  // manual reset, start signaled
  FTlen:=4;
end;

destructor TMultiReadExclusiveWriteSynchronizer.Destroy;
begin
  BeginWrite;
  inherited Destroy;
  CloseHandle(FReadExit);
  DeleteCriticalSection(FLock);
end;

function TMultiReadExclusiveWriteSynchronizer.WriterIsOnlyReader: Boolean;
var
  I, Len: Integer;
begin
  Result := False;
  if FWriteRequestorID = 0 then Exit;
  // We know a writer is waiting for entry with the FLock locked,
  // so FActiveThreads is stable - no BeginRead could be resizing it now
  I := 0;
  Len := FTlen; {High(FActiveThreads);}
  while (I < Len) and
    ((FActiveThreads[I].ThreadID = 0) or (FActiveThreads[I].ThreadID = FWriteRequestorID)) do
    Inc(I);
  Result := I >= Len;
end;

procedure TMultiReadExclusiveWriteSynchronizer.BeginWrite;
begin
  EnterCriticalSection(FLock);  // Block new read or write ops from starting
  if not FWriting then
  begin
    FWriteRequestorID := GetCurrentThreadID;   // Indicate that writer is waiting for entry
    if not WriterIsOnlyReader then              // See if any other thread is reading
      WaitForSingleObject(FReadExit, INFINITE); // Wait for current readers to finish
    FSaveReadCount := FCount;  // record prior read recursions for this thread
    FCount := 0;
    FWriteRequestorID := 0;
    FWriting := True;
  end;
  Inc(FCount);  // allow read recursions during write without signalling FReadExit event
end;

procedure TMultiReadExclusiveWriteSynchronizer.EndWrite;
begin
  Dec(FCount);
  if FCount = 0 then
  begin
    FCount := FSaveReadCount;  // restore read recursion count
    FSaveReadCount := 0;
    FWriting := False;
  end;
  LeaveCriticalSection(FLock);
end;

procedure TMultiReadExclusiveWriteSynchronizer.BeginRead;
var
  I: Integer;
  ThreadID: Integer;
  ZeroSlot: Integer;
begin
  EnterCriticalSection(FLock);
  try
    if not FWriting then
    begin
      // This will call ResetEvent more than necessary on win95, but still work
      if InterlockedIncrement(FCount) = 1 then
        ResetEvent(FReadExit); // Make writer wait until all readers are finished.
      I := 0;  // scan for empty slot in activethreads list
      ThreadID := GetCurrentThreadID;
      ZeroSlot := -1;
      while (I < FTlen {High(FActiveThreads)}) and (FActiveThreads[I].ThreadID <> ThreadID) do
      begin
        if (FActiveThreads[I].ThreadID = 0) and (ZeroSlot < 0) then ZeroSlot := I;
        Inc(I);
      end;
      if I >= FTlen {High(FActiveThreads)} then  // didn't find our threadid slot
      begin
        if ZeroSlot < 0 then  // no slots available.  Grow array to make room
        begin   // spin loop.  wait for EndRead to put zero back into FReallocFlag
          while InterlockedExchange(FReallocFlag, ThreadID) <> 0 do  Sleep(0);
          try
            {SetLength(FActiveThreads, High(FActiveThreads) + 3);}
            FTlen:=FTlen+3;
          finally
            FReallocFlag := 0;
          end;
        end
        else  // use an empty slot
          I := ZeroSlot;
        // no concurrency issue here.  We're the only thread interested in this record.
        FActiveThreads[I].ThreadID := ThreadID;
        FActiveThreads[I].RecursionCount := 1;
      end
      else  // found our threadid slot.
        Inc(FActiveThreads[I].RecursionCount); // thread safe = unique to threadid
    end;
  finally
    LeaveCriticalSection(FLock);
  end;
end;

procedure TMultiReadExclusiveWriteSynchronizer.EndRead;
var
  I, ThreadID, Len: Integer;
begin
  if not FWriting then
  begin
    // Remove our threadid from the list of active threads
    I := 0;
    ThreadID := GetCurrentThreadID;
    // wait for BeginRead to finish any pending realloc of FActiveThreads
    while InterlockedExchange(FReallocFlag, ThreadID) <> 0 do  Sleep(0);
    try
      Len := High(FActiveThreads);
      while (I < Len) and (FActiveThreads[I].ThreadID <> ThreadID) do Inc(I);
      {assert(I < Len);}
      if I>=Len
        then raise Exception.Create ('TMultiReadExclusiveWriteSynchronizer error');

      // no concurrency issues here.  We're the only thread interested in this record.
      Dec(FActiveThreads[I].RecursionCount); // threadsafe = unique to threadid
      if FActiveThreads[I].RecursionCount = 0 then
        FActiveThreads[I].ThreadID := 0; // must do this last!
    finally
      FReallocFlag := 0;
    end;
    if (InterlockedDecrement(FCount) = 0) or WriterIsOnlyReader then
      SetEvent(FReadExit);     // release next writer
  end;
end;


end.
