unit DgOut;

interface

uses Windows, Forms, Classes, DAQDefs,
     pwrdaq32, pdfw_def, pd_hcaps;

type

  // base acquisition thread
  TDigitalOutput = class(TThread)
  private
    hAdapter: DWORD;
    dwError: DWORD;
    FFrequency: DWORD;
    FOnUpdateView: TUpdateViewProc;
    FOnGetData: TDataFunction;
  protected
    procedure DoTerminate; override;
  public
    constructor Create(Adapter: DWORD);
    procedure Execute; override;
    property Frequency: DWORD read FFrequency write FFrequency;
    property OnUpdateView: TUpdateViewProc read FOnUpdateView write FOnUpdateView;
    property OnGetData: TDataFunction read FOnGetData write FOnGetData;
  end;

implementation

constructor TDigitalOutput.Create(Adapter: DWORD);
begin
  hAdapter := Adapter;
  Frequency := 500;
  inherited Create(False);
end;

procedure TDigitalOutput.Execute;
var Value: WORD;
begin
  Value := 0;
  // digital output - init sequence
  try
    // initialize DInp subsystem
    if not PdAdapterAcquireSubsystem(hAdapter, @dwError, DigitalOut, 1)
      then raise TPwrDaqException.Create('PdAdapterAcquireSubsystem', dwError);
    // thread loop
    while not Terminated do try
      // get data value
      if Assigned(OnGetData) then Value := OnGetData;
      // update view
      if Assigned(OnUpdateView) then OnUpdateView(Value);
      // output data
      if not _PdDOutWrite(hAdapter, @dwError, Value)
        then raise TPwrDaqException.Create('_PdDOutWrite', dwError);
      try Sleep (10000 div Frequency); except end;
    except
      raise;
    end;
  except
    Application.HandleException(Self);
  end;
end;

procedure TDigitalOutput.DoTerminate;
begin
  // stop input sequence
  try
    // release DInp subsystem and close adapter
    if not PdAdapterAcquireSubsystem(hAdapter, @dwError, DigitalOut, 0)
      then raise TPwrDaqException.Create('PdAdapterAcquireSubsystem', dwError);
  except
    // Handle any exception
    Application.HandleException(Self);
  end;
  inherited;
end;

end.

