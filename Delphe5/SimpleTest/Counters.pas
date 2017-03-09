unit Counters;

interface

uses Windows, Forms, Classes, DAQDefs,
     pwrdaq32, pdfw_def;

const
    UCT_SQUARE  = $36;
    UCT_IMPULSE = $34;

type

  // base acquisition thread
  TCounter = class(TThread)
  private
    hAdapter: DWORD;
    dwError: DWORD;
    FModes: array [0..2] of DWORD;
    FClocks: array [0..2] of DWORD;
    FGates: array [0..2] of DWORD;
    FUpdateView: TThreadMethod;
    procedure SetValue(Index: Integer; Value: DWORD);
    function  GetValue(Index: Integer): DWORD;
    procedure SetClock(Index: Integer; Value: DWORD);
    procedure SetGate(Index: Integer; Value: DWORD);
    procedure SetMode(Index: Integer; Value: DWORD);
  public
    constructor Create(Adapter: THandle);
    procedure Execute; override;
    property OnUpdateView: TThreadMethod read FUpdateView write FUpdateView;
    property Clocks[Index: Integer]: DWORD write SetClock;
    property Gates[Index: Integer]: DWORD write SetGate;
    property Modes[Index: Integer]: DWORD write SetMode;
    property Values[Index: Integer]: DWORD read GetValue write SetValue;
  end;

implementation

constructor TCounter.Create(Adapter: THandle);
begin
  try
    inherited Create(True);
    hAdapter := Adapter;
    FillChar(FModes, SizeOf(FModes), 0);
    FillChar(FClocks, SizeOf(FClocks), 0);
    FillChar(FGates, SizeOf(FGates), 0);
  except
    Application.HandleException(Self);
  end;
end;

procedure TCounter.Execute;
begin
  try
    // counter output - init sequence
    try
      // get subsystem in use
      if not PdAdapterAcquireSubsystem(hAdapter, @dwError, CounterTimer, 1)
        then raise TPwrDaqException.Create('PdAdapterAcquireSubsystem', dwError);

      // reset timers
      if not _PdUctReset(hAdapter, @dwError)
        then raise TPwrDaqException.Create('_PdUctReset', dwError);

      // start timers
      if not _PdUctSetCfg(hAdapter, @dwError, FClocks[0] or FClocks[1] or FClocks[2] or
                                              FGates[0]  or FGates[1]  or FGates[2])
        then raise TPwrDaqException.Create('_PdUctSetCfg', dwError);

      // thread loop
      while not Terminated do
      begin
        Sleep(10);
        if Assigned(OnUpdateView) then Synchronize(OnUpdateView);
      end;

      // release UCTnp subsystem
      if not _PdUctReset(hAdapter, @dwError)
        then raise TPwrDaqException.Create('_PdUctReset', dwError);

    except
      Application.HandleException(Self);
    end;

  finally
    // Release AOut subsystem and close adapter
    if not PdAdapterAcquireSubsystem(hAdapter, @dwError, CounterTimer, 0)
      then raise TPwrDaqException.Create('PdAdapterAcquireSubsystem', dwError);
  end;
end;

procedure TCounter.SetMode(Index: Integer; Value: DWORD);
begin
  FModes[Index] := Value;
end;

procedure TCounter.SetClock(Index: Integer; Value: DWORD);
begin
  FClocks[Index] := Value;
end;

procedure TCounter.SetGate(Index: Integer; Value: DWORD);
begin
  FGates[Index] := Value;
end;

procedure TCounter.SetValue(Index: Integer; Value: DWORD);
begin
{ Timer programming: square wave for channel 0
  Control Word Format
  ===================
  0x36 - 0011 0110
         00 -        select counter N 0
           11 -      write LSB, then MSB (order)
              011 -  mode select (mode 3)
                 0 - use bynary counter (0-65536) }
    _PdUctWrite(hAdapter, @dwError, (Value SHL 8) or (Index SHL 6) or FModes[Index]);
end;

function TCounter.GetValue(Index: Integer): DWORD;
var FValue: DWORD;
begin
{ Timer programming: reading counter value from channel 0
  Control Word Format
  ===================
  0x30 - 0011 0000
         00 -        select counter N 0
           11 -      write LSB, then MSB (order)
              011 -  mode select (mode 3)
                 0 - use bynary counter (0-65536) }
//  _PdUctSwSetGate(hAdapter, @dwError, $00);
    _PdUctRead(hAdapter, @dwError, $1000 or (Index SHL 9) or (Index SHL 6) or $30, @FValue);
//  _PdUctSwSetGate(hAdapter, @dwError, $FF);
    if FValue > $FFFF then FValue := FValue - $FFFF;
    Result := ($FFFF - FValue) shr 1;
end;

end.
