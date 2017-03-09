unit AnInp;

interface

uses
  Windows, Classes, SysUtils, Forms, ExtCtrls, Graphics,
  DAQDefs, VisualThread, pwrdaq, pdfw_def,
  pwrdaq32, pd_hcaps;

type

  TAcquisitionSetup = record
    // for hardware setup
    Adapter: THandle;              // adapter handle
    BoardType: DWORD;              // type of the PowerDAQ board
    Resolution: DWORD;             // adapter resolution
    FIFOSize: DWORD;               // FIFO size
    Frequency: DWORD;              // acquisition Frequency
    Channel: DWORD;                // active channel
    NumChannels: DWORD;            // total number of channel to acquisition
    DefGain: DWORD;                // default gain (for all channels)
    AInMode: DWORD;                // Single-ended/Differential
    AInType: DWORD;                // Unipolar/Bipolar
    AInRange: DWORD;               // Low/High
    Factor: Real;                  //
    // for visualisation setup
    PaintRect: TRect;
    PaintCanvas: TCanvas;
  end;

  // base acquisition thread
  TAnalogInput = class(TThread)
  private
    AcqSetup: TAcquisitionSetup;
    dwError: DWORD;
    hNotifyEvent : THandle;
    FActiveChannel: Integer;
    AInChList: array [0..63] of DWORD;
    AInBuffer: PAnalogInputBuffer;
    dwAInScanSize: DWORD;
    dwAInScans: DWORD;
    Visualisation: TVisualThread;
    procedure SetActiveChannel(Value: Integer);
  protected
    procedure DoTerminate; override;
  public
    constructor Create(AAcqSetup: TAcquisitionSetup);
    procedure Execute; override;
    procedure DoGetData; virtual;
    property ActiveChannel: Integer read FActiveChannel write SetActiveChannel;
  end;

implementation

// methods for AcquisitionThread
constructor TAnalogInput.Create(AAcqSetup: TAcquisitionSetup);
begin
  // assign setup record
  AcqSetup := AAcqSetup;
  // create visualisation thread
  Visualisation := TVisualThread.Create(AcqSetup.PaintCanvas, AcqSetup.PaintRect);
  inherited Create(False);
end;

procedure TAnalogInput.Execute;
var
  i: Integer;
  dwAInCfg,
  dwConvType,
  dwAInPreTrigCount,
  dwAInPostTrigCount,
  dwAInCvClkDiv,
  dwAInClClkDiv,
  dwEventsNotify,
  dwAInFrames,
  dwWaitTime : DWORD;
begin
  // analog input - init sequence
  try
    if (AcqSetup.BoardType and atPD2MF > 0) or (AcqSetup.BoardType and atPDMF > 0)
      then dwConvType :=  AIB_CLSTART0 or AIB_CLSTART1 or AIB_CVSTART0
      else dwConvType :=  AIB_CLSTART0 or AIB_CVSTART0 or AIB_CVSTART1;

    dwAInCfg := AcqSetup.AInMode                      // Modes (Single ended/Differential)
             or AcqSetup.AInType                      // Input Type (Unipolar/Bipolar)
             or AcqSetup.AInRange                     // Input Range (Low/High)
             or dwConvType                            // Conversion type
             or AIB_INTCLSBASE                        // Select 33 MHz Source
             or AIB_INTCVSBASE;                       // -

    // build Channel list
    for i:=0 to AcqSetup.NumChannels-1 do
      AInChList [i] := i + (AcqSetup.DefGain SHL 6);

    // init counter variables
    dwAInPreTrigCount := 0;
    dwAInPostTrigCount := 0;

    if (AcqSetup.BoardType = atPD2MF) or (AcqSetup.BoardType = atPDMF)
      then dwAInCvClkDiv := Round(BaseFrequency[ LongBool(dwAInCfg and AIB_INTCLSBASE)] / (AcqSetup.Frequency * AcqSetup.NumChannels)) - 1
      else dwAInCvClkDiv := Round(BaseFrequency[ LongBool(dwAInCfg and AIB_INTCLSBASE)] / AcqSetup.Frequency) - 1;

    dwAInClClkDiv := dwAInCvClkDiv;

    // init buffer variables
    dwAInScanSize := AcqSetup.NumChannels;
    dwAInScans := Round( AcqSetup.Frequency / dwAInScanSize / 20);

    if dwAInScans < (AcqSetup.PaintRect.Right-AcqSetup.PaintRect.Left) * 2
      then dwAInScans := (AcqSetup.PaintRect.Right-AcqSetup.PaintRect.Left) * 2;

    if dwAInScans < AcqSetup.FIFOSize div 2 then dwAInScans := AcqSetup.FIFOSize div 2; 

    dwAInFrames   := 8;
    dwWaitTime := 10000;

    // get subsystem in use
    if not PdAdapterAcquireSubsystem(AcqSetup.Adapter, @dwError, AnalogIn, 1)
      then raise TPwrDaqException.Create('PdAdapterAcquireSubsystem', dwError);

    // get buffer in use
    if not _PdAllocateBuffer(@AInBuffer, dwAInFrames, dwAInScans, dwAInScanSize, @dwError)
      then raise TPwrDaqException.Create('_PdAllocateBuffer', dwError);

    // connect buffer to AIn subsystem
    if not _PdRegisterBuffer(AcqSetup.Adapter, @dwError, PWORD(AInBuffer), AnalogIn, AIB_BUFFERWRAPPED or AIB_BUFFERRECYCLED)
      then raise TPwrDaqException.Create('_PdRegisterBuffer', dwError);

    // set notification events
    dwEventsNotify := eFrameDone or eBufferDone or eBufferError or eStopped;

    // configure AIn subsystem.
    if not _PdAInAsyncInit(AcqSetup.Adapter, @dwError,
                           dwAInCfg,
                           dwAInPreTrigCount,
                           dwAInPostTrigCount,
                           dwAInCvClkDiv,
                           dwAInClClkDiv,
                           dwEventsNotify,
                           dwAInScanSize,
                           @AInChList)
      then raise TPwrDaqException.Create('_PdAInAsyncInit', dwError);

    // enable A/D conversions.
    if not _PdAInAsyncStart(AcqSetup.Adapter, @dwError)
      then raise TPwrDaqException.Create('_PdAInAsyncStart', dwError);

    // set private event
    if not _PdAInSetPrivateEvent(AcqSetup.Adapter, @hNotifyEvent)
      then raise TPwrDaqException.Create('_PdSetPrivateEvent', -1);

    // run visualisation
    if Visualisation <> nil then
    begin
      Visualisation.Channel := ActiveChannel;
      Visualisation.ScanSize := dwAInScanSize;                   // number of channels
      Visualisation.Buffer := AInBuffer;
      Visualisation.Adapter := AcqSetup.Adapter;
      Visualisation.Mode := dwAInCfg;
      Visualisation.Resume;
    end;

    // thread loop
    while not Terminated do try
      if WaitForSingleObject(hNotifyEvent, dwWaitTime) = WAIT_OBJECT_0
        then Synchronize(DoGetData)
        else raise TPwrDaqException.Create('Time-out detected. Acquisition stopped', 0);
    except
      raise;
    end;
  except
    Application.HandleException(Self);
  end;
end;

procedure TAnalogInput.DoGetData;
var
  dwAInEvents: Cardinal;
  ScanIndex, NumValidScans: DWORD;
begin
  try
    if not _PdGetUserEvents(AcqSetup.Adapter, @dwError, AnalogIn, @dwAInEvents)
      then raise TPwrDaqException.Create('_PdGetUserEvents', dwError);

    // if aq. stopped, test on any error
    if LongBool(eStopped and dwAInEvents) then
    begin
      // aq. stopped test
      if LongBool(eBufferError and dwAInEvents)
        then raise TPwrDaqException.Create('Buffer error detected', 0);

      // time-out test
      if LongBool(eTimeout and dwAInEvents)
        then raise TPwrDaqException.Create('Time-out detected', 0);
    end;

    if LongBool (eFrameDone and dwAInEvents) then
    begin
      // get scans using PdAInGetScans.
      if not _PdAInGetScans(AcqSetup.Adapter, @dwError, $FFFFFF, @ScanIndex, @NumValidScans)
        then raise TPwrDaqException.Create('_PdAInGetScans', dwError);

      // if data available, draw it
      if Visualisation <> nil then
      begin
        Visualisation.Offset := ScanIndex;
        Visualisation.NumScans := NumValidScans;
      end;
    end;

  finally
    // make sure, that we're  interested in this two events,
    dwAInEvents := dwAInEvents and (not (eDataAvailable or eScanDone));

    // re-enable user events that asserted.
    if not _PdSetUserEvents(AcqSetup.Adapter, @dwError, AnalogIn, dwAInEvents)
      then raise TPwrDaqException.Create('_PdClearUserEvents', dwError);
  end;
end;

procedure TAnalogInput.DoTerminate;
begin
  // stop acquisition sequence
  try
   // terminate visualisation thread
   if Visualisation <> nil then
   begin
     Visualisation.Free;
     Visualisation := nil;
   end;

   // disable A/D conversions
   if not _PdAInClearPrivateEvent(AcqSetup.Adapter, @hNotifyEvent)
     then raise TPwrDaqException.Create('_PdAInClearPrivateEvent', -1);

   // stop acquisition
   if not _PdAInAsyncStop(AcqSetup.Adapter, @dwError)
     then raise TPwrDaqException.Create('_PdAInAsyncStop', dwError);

   // clear all events
   if not _PdClearUserEvents(AcqSetup.Adapter, @dwError, AnalogIn, eAllEvents)
     then raise TPwrDaqException.Create('_PdClearUserEvents', dwError);

   // terminate acquisition
   if not _PdAInAsyncTerm(AcqSetup.Adapter, @dwError)
     then raise TPwrDaqException.Create('_PdAInAsyncTerm', dwError);

   // unregister data buffer &
   if not _PdUnregisterBuffer(AcqSetup.Adapter, @dwError, PWORD(AInBuffer))
     then raise TPwrDaqException.Create('_PdUnregisterBuffer', dwError);

   // dispose it
   if not _PdFreeBuffer(PWORD(AInBuffer), @dwError)
     then raise TPwrDaqException.Create('_PdFreeBuffer', dwError);

   // free AI subsystem
   if not PdAdapterAcquireSubsystem(AcqSetup.Adapter, @dwError, AnalogIn, 0)
     then raise TPwrDaqException.Create('PdAdapterAcquireSubsystem', dwError);

  except
    // handle any exception
    Application.HandleException(Self);
  end;
  inherited;
end;

procedure TAnalogInput.SetActiveChannel(Value: Integer);
begin
  if FActiveChannel <> Value then
  begin
    FActiveChannel := Value;
    if Visualisation <> nil then Visualisation.Channel := Value;
  end;
end;

end.
