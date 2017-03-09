unit ThdTimer;

interface
{$IFDEF FPC} {$mode delphi} {$DEFINE AcqElphy2} {$A1} {$Z1} {$ENDIF}

uses
  Windows, Messages, SysUtils, Classes,
  Graphics, Controls, Forms, Dialogs;

type
  TThreadedTimer = class;

  TTimerThread = class(TThread)
    OwnerTimer: TThreadedTimer;
    Interval: DWord;
    FirstInterval:Dword;
    first:boolean;
    procedure Execute; override;
    procedure DoTimer;
  end;

  TThreadedTimer = class(TComponent)
  private
    FEnabled: Boolean;
    FInterval,FFirstInterval: DWord;
    FOnTimer: TNotifyEvent;
    FTimerThread: TTimerThread;
    FThreadPriority: TThreadPriority;
  protected
    procedure UpdateTimer;
    procedure SetEnabled(Value: Boolean);
    procedure SetInterval(Value: DWord);
    procedure SetFirstInterval(Value: DWord);

    procedure SetOnTimer(Value: TNotifyEvent);
    procedure SetThreadPriority(Value: TThreadPriority);
    procedure Timer; dynamic;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;

    procedure Reset;
  published
    property Enabled: Boolean read FEnabled write SetEnabled default True;
    property Interval: DWord read FInterval write SetInterval default 1000;
    property FirstInterval: DWord read FFirstInterval write SetFirstInterval default 1000;

    property OnTimer: TNotifyEvent read FOnTimer write SetOnTimer;
    property ThreadPriority: TThreadPriority read FThreadPriority
      write SetThreadPriority;
  end;

procedure Register;

implementation

procedure TTimerThread.Execute;
begin
   repeat
     if first then
       begin
         SleepEx(FirstInterval, False);
         first:=false;
       end
     else SleepEx(Interval, False);
     DoTimer;
   until Terminated;
end;

procedure TTimerThread.DoTimer;
begin
   OwnerTimer.Timer;
end;

constructor TThreadedTimer.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FEnabled := True;
  FInterval := 1000;
  FfirstInterval := 1000;
  

  FThreadPriority := tpNormal;
  FTimerThread := TTimerThread.Create(False);
  FTimerThread.OwnerTimer := Self;
  FTimerThread.Interval := FInterval;
  FTimerThread.FirstInterval := FfirstInterval;
  FTimerThread.first:=true;

  FTimerThread.Priority := FThreadPriority;
end;

destructor TThreadedTimer.Destroy;
begin
  FEnabled := False;
  UpdateTimer;
  FTimerThread.Free;
  inherited Destroy;
end;

procedure TThreadedTimer.UpdateTimer;
begin
   if FTimerThread.Suspended = False then
      FTimerThread.Suspend;

   if (FInterval <> 0) and FEnabled and Assigned(FOnTimer) then
      FTimerThread.Resume;
end;

procedure TThreadedTimer.SetEnabled(Value: Boolean);
begin
   if Value <> FEnabled then
   begin
      FEnabled := Value;

      UpdateTimer;
   end;
end;

procedure TThreadedTimer.SetInterval(Value: DWord);
begin
   if Value <> FInterval then
   begin
      FInterval := Value;
      FTimerThread.Interval := FInterval;
      UpdateTimer;
   end;
end;

procedure TThreadedTimer.SetFirstInterval(Value: DWord);
begin
   if Value <> FirstInterval then
   begin
      FFirstInterval := Value;
      FTimerThread.FirstInterval := FFirstInterval;
      UpdateTimer;
   end;
end;


procedure TThreadedTimer.SetOnTimer(Value: TNotifyEvent);
begin
   FOnTimer := Value;
   UpdateTimer;
end;

procedure TThreadedTimer.SetThreadPriority(Value: TThreadPriority);
begin
   if Value <> FThreadPriority then
   begin
      FThreadPriority := Value;
      FTimerThread.Priority := Value;
      UpdateTimer;
   end;
end;

procedure TThreadedTimer.Timer;
begin
   if Assigned(FOnTimer) then
      FOnTimer(Self);
end;


procedure TThreadedTimer.Reset;
begin
   FTimerThread.Free;
   FTimerThread := TTimerThread.Create(False);
   FTimerThread.OwnerTimer := Self;
   FTimerThread.Priority := FThreadPriority;
   UpdateTimer;
end;


procedure Register;
begin
   RegisterComponents('System', [TThreadedTimer]);
end;

end.
