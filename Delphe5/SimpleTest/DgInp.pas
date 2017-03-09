unit DgInp;

interface

uses Windows, Forms, Classes, DAQDefs,
   pwrdaq32, pdfw_def, pd_hcaps;

type

  // base acquisition thread
  TDigitalInput = class(TThread)
  private
    hAdapter: DWORD;
    dwError: DWORD;
    FFrequency: DWORD;
    FOnUpdateView: TUpdateViewProc;
  protected
    procedure DoTerminate; override;
  public
    constructor Create(Adapter: DWORD);
    procedure Execute; override;
    property Frequency: DWORD read FFrequency write FFrequency;
    property OnUpdateView: TUpdateViewProc read FOnUpdateView write FOnUpdateView;
  end;

implementation

constructor TDigitalInput.Create(Adapter: DWORD);
begin
  hAdapter := Adapter;
  Frequency := 500;  
  inherited Create(False);
end;

procedure TDigitalInput.Execute;
var Value: DWORD;
begin
  // digital input - init sequence
  try
    // initialize DInp subsystem
    if not PdAdapterAcquireSubsystem(hAdapter, @dwError, DigitalIn, 1)
      then raise TPwrDaqException.Create('PdAdapterAcquireSubsystem', dwError);
    // thread loop
    while not Terminated do try
      if not _PdDInRead(hAdapter, @dwError, @Value)
        then raise TPwrDaqException.Create('_PdDInRead', dwError);
      if Assigned(OnUpdateView)
        then OnUpdateView(Value);
      try Sleep (10000 div Frequency); except end;
    except
      raise;
    end;
  except
    Application.HandleException(Self);
  end;
end;

procedure TDigitalInput.DoTerminate;
begin
  // stop input sequence
  try
    // release DInp subsystem and close adapter
    if not PdAdapterAcquireSubsystem(hAdapter, @dwError, DigitalIn, 0)
      then raise TPwrDaqException.Create('PdAdapterAcquireSubsystem', dwError);
  except
    // Handle any exception
    Application.HandleException(Self);
  end;
  inherited;
end;

end.
