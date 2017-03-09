unit AnOut;

interface

uses
  Windows, Classes, SysUtils, Forms, Graphics,
  DAQDefs, pwrdaq32, pdfw_def;

type

  // base acquisition thread
  TAnalogOutput = class(TThread)
  private
    hAdapter: DWORD;
    dwError: DWORD;
    FFrequency: DWORD;
    FAdapterType: DWORD;
    hNotifyEvent: THandle;
    dwEventsNotify: DWORD;
    ABuffer: PAnalogOutputBuffer;
    FSettingsChanges: Boolean;
  protected
    procedure DoTerminate; override;
    procedure DoPutData;
  public
    constructor Create(Adapter: DWORD);
    procedure Execute; override;
    property AdapterType: DWORD read FAdapterType write FAdapterType;
    property Frequency: DWORD read FFrequency write FFrequency;
    property Buffer: PAnalogOutputBuffer read ABuffer write ABuffer;
    property SettingsChanges: Boolean read FSettingsChanges write FSettingsChanges;
  end;

implementation

constructor TAnalogOutput.Create(Adapter: DWORD);
begin
  try
    // create thread suspended
    inherited Create(True);
    hAdapter := Adapter;
    Buffer := nil;
  except
    Application.HandleException(Self);
  end;
end;

procedure TAnalogOutput.Execute;
var
  dwAnalogOutCfg: DWORD;
  dwWaitTime: DWORD;
begin
  try
    // lock subsystem
    if not PdAdapterAcquireSubsystem(hAdapter, @dwError, AnalogOut, 1)
      then raise TPwrDaqException.Create('PdAdapterAcquireSubsystem', dwError);

    // reset analog output
    if not _PdAOutReset(hAdapter, @dwError)
      then raise TPwrDaqException.Create('_PdAOutReset', dwError);

    if AdapterType and atMF > 0
      then dwAnalogOutCfg := AOB_CVSTART0 or AOB_REGENERATE
      else dwAnalogOutCfg := AOB_CVSTART0 or AOB_AOUT32 or AOB_REGENERATE;

    // set configuration
    if not _PdAOutSetCfg(hAdapter, @dwError, dwAnalogOutCfg, 0)
      then raise TPwrDaqException.Create('_PdAOutSetCfg', dwError);

    // set DSP D/A conversion clock divider
    if not _PdAOutSetCvClk(hAdapter, @dwError, Round(11000000 / Frequency) - 1)
      then raise TPwrDaqException.Create('_PdAOutSetCvClk', dwError);

    // create and set private event
    if not _PdAOutSetPrivateEvent(hAdapter, @hNotifyEvent)
      then raise TPwrDaqException.Create('_PdSetPrivateEvent', dwError);

    // enable interrupts
    if not _PdAdapterEnableInterrupt(hAdapter, @dwError, 1)
      then raise TPwrDaqException.Create('_PdAdapterEnableInterrupt', dwError);

    dwEventsNotify := eFrameDone or eBufferDone or eTimeout or eBufferError or eStopped;
    if not _PdSetUserEvents(hAdapter, @dwError, AnalogOut, dwEventsNotify)
      then raise TPwrDaqException.Create('_PdSetUserEvents', dwError);

    // enable conversion
    if not _PdAOutEnableConv(hAdapter, @dwError, 1)
      then raise TPwrDaqException.Create('_PdAOutEnableConv', dwError);

    // set start trigger
    if not _PdAOutSwStartTrig(hAdapter, @dwError)
      then raise TPwrDaqException.Create('_PdAOutSwStartTrig', dwError);

    // thread loop
    while not Terminated do try
      if (WaitForSingleObject(hNotifyEvent, 100) = WAIT_OBJECT_0) or (SettingsChanges)
        then Synchronize(DoPutData);
    except
      raise;
    end;
  except
    Application.HandleException(Self);
  end;
end;

procedure TAnalogOutput.DoPutData;
var
  i,j: Integer;
  dwScanDone : DWORD;
begin
  try
    // get user event
    if not _PdGetUserEvents(hAdapter, @dwError, AnalogOut, @dwEventsNotify)
       then raise TPwrDaqException.Create('_PdGetUserEvents', dwError);
    // now analize user event
    if Bool (dwEventsNotify and eTimeout)
       then raise TPwrDaqException.Create('Driver detects timeout', 0);
    if Bool (dwEventsNotify and eStopped)
       then raise TPwrDaqException.Create('Acquisition stopped by driver', 0);
    // in other cases driver need data to output
    if SettingsChanges then
    begin
      // output block
      if not _PdAOutPutBlock(hAdapter, @dwError, 2048, @Buffer[0], @dwScanDone)
         then raise TPwrDaqException.Create('_PdAOutPutBlock', dwError);
      SettingsChanges := False;
      dwEventsNotify := eFrameDone or eBufferDone or eTimeout or eBufferError or eStopped;
      if not _PdSetUserEvents(hAdapter, @dwError, AnalogOut, dwEventsNotify)
        then raise TPwrDaqException.Create('_PdSetUserEvents', dwError);
      if not _PdAOutEnableConv(hAdapter, @dwError, 1)
        then raise TPwrDaqException.Create('_PdAOutEnableConv', dwError);
      if not _PdAOutSwStartTrig(hAdapter, @dwError)
        then raise TPwrDaqException.Create('_PdAOutEnableConv', dwError);
    end;
  except
    // Handle any exception
    Application.HandleException(Self);
  end;
end;

procedure TAnalogOutput.DoTerminate;
begin
  // stop output sequence
  try
   // disable A/D conversions
    if not _PdAOutClearPrivateEvent(hAdapter, @hNotifyEvent)
      then raise TPwrDaqException.Create('_PdAOutClearPrivateEvent', -1);
    // stop output
    if not _PdAOutSwStopTrig(hAdapter, @dwError)
      then raise TPwrDaqException.Create('_PdAOutSwStopTrig', dwError);
    // disable conversion
    if not _PdAOutEnableConv(hAdapter, @dwError, DWORD(False))
      then raise TPwrDaqException.Create('_PdAOutEnableConv', dwError);
    // reset analog output
    if not _PdAOutReset(hAdapter, @dwError)
      then raise TPwrDaqException.Create('_PdAOutReset', dwError);
    // release AOut subsystem and close adapter
    if not PdAdapterAcquireSubsystem(hAdapter, @dwError, AnalogOut, 0)
      then raise TPwrDaqException.Create('PdAdapterAcquireSubsystem', dwError);
  except
    // Handle any exception
    Application.HandleException(Self);
  end;
  inherited;
end;

end.