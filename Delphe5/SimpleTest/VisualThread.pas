unit VisualThread;

interface

uses Windows, Classes, Forms, Graphics, ExtCtrls, SysUtils, SyncObjs,DAQDefs, pdfw_def,
     pwrdaq32;

type

  TVisualThread = class(TThread)
  private
    FPaintHeight: Integer;
    FPaintWidth: Integer;
    FPaintRect: TRect;
    FPaintCanvas: TCanvas;
    FGridCanvas: TCanvas;
    FMemCanvas: TCanvas;
    FBuffer: PAnalogInputBuffer;
    FOffset: DWORD;
    FChannel: DWORD;
    FScanSize: DWORD;
    FNumChannels: DWORD;
    FViewSize: DWORD;
    FAdapter: THandle;
    FNumScans: DWORD;
    FMode: DWORD;
  protected
    procedure DoVisualisation;
  public
    constructor Create(PaintCanvas: TCanvas; PaintRect: TRect);
    procedure Execute; override;
    property Buffer: PAnalogInputBuffer read FBuffer write FBuffer;
    property Offset: DWORD read FOffset write FOffset;
    property Channel: DWORD read FChannel write FChannel;
    property ScanSize: DWORD read FScanSize write FScanSize;
    property NumScans: DWORD read FNumScans write FNumScans;
    property Adapter: THandle read FAdapter write FAdapter;
    property Mode: DWORD read FMode write FMode;
  end;

implementation

// Basic methods from AcquisitionThread
constructor TVisualThread.Create(PaintCanvas: TCanvas; PaintRect: TRect);
var
  i : Integer;
begin
  // Assign setup
  FPaintCanvas := PaintCanvas;
  FPaintRect := PaintRect;
  // Create back buffer
  FPaintWidth := PaintRect.Right-PaintRect.Left;
  FPaintHeight := PaintRect.Bottom-PaintRect.Top;
  with TImage.Create(nil) do
  begin
    Picture.Bitmap := TBitmap.Create;
    Picture.Bitmap.Width := FPaintWidth;
    Picture.Bitmap.Height := FPaintHeight;
    Canvas.Pen.Color := clLime;
    Canvas.Brush.Color := clBlack;
    FMemCanvas := Canvas;
  end;
  // Create grid
  with TImage.Create(nil) do
  begin
    Picture.Bitmap := TBitmap.Create;
    Picture.Bitmap.Width := FPaintWidth;
    Picture.Bitmap.Height := FPaintHeight;
    Canvas.Pen.Color := clLime;
    Canvas.Brush.Color := clBlack;
    FGridCanvas := Canvas;
    with FGridCanvas do
    try
      Pen.Color := clGray;
      Brush.Color := clBlack;
      FillRect (PaintRect);
      for i:=1 to 9 do
      begin
        MoveTo(Round(i * FPaintWidth / 10), PaintRect.Top);
        LineTo(Round(i * FPaintWidth / 10), PaintRect.Bottom);
      end;
      for i:=1 to 9 do
      begin
        if i=5 then Pen.Color := clWhite else Pen.Color := clGray;      
        MoveTo(PaintRect.Left, Round(i * FPaintHeight / 10));
        LineTo(PaintRect.Right, Round(i * FPaintHeight / 10));
      end;
    except
    end;
  end;
  inherited Create(True);
end;

procedure TVisualThread.Execute;
begin
  while not Terminated do
  begin
    Sleep(50);
    Synchronize(DoVisualisation);
  end;
end;

procedure TVisualThread.DoVisualisation;

const Delta = 0.1;

var i, k, NumPoints, StartPoint: Integer;
    RawData: array [0..1023] of Word;
    VoltValues: array [0..1023] of Real;
    MaxValue, MinValue, Median, DispCoeff, Value: Real;
begin
  if (Buffer <> nil) and (NumScans > FPaintWidth) then
  try
    // calculate number of samples to display
    if NumScans >= High(RawData)
       then NumPoints := High(RawData)
       else NumPoints := NumScans;

    // copy active channel raw data
    for i:=0 to NumPoints do
      RawData[i] := Buffer^[(Offset + i)*ScanSize + Channel];

    // convert to the volt values
    PdAInRawToVolts (Adapter, Mode, @RawData,  @VoltValues, NumPoints );

    // calculate median
    MaxValue := 0; MinValue := 0;
    for i:=0 to NumPoints-1 do
    begin
      if VoltValues[i] > MaxValue then MaxValue := VoltValues[i] else
      if VoltValues[i] < MinValue then MinValue := VoltValues[i];
    end;
    Median := MinValue + (MaxValue - MinValue) / 2;

    // triggering: median, rising level
    StartPoint := 0;
    for i:=0 to NumPoints-FPaintWidth do
      if (VoltValues[i] > Median-Delta) and (VoltValues[i] < Median+Delta) and
         (VoltValues[i] < VoltValues[i+2]) then
      begin
        StartPoint := i;
        Break;
      end;
    if StartPoint = 0 then
      // special trigger for square waveforms
      for i:=0 to NumPoints-FPaintWidth do
        if (VoltValues[i] > MinValue-2*Delta) and (VoltValues[i] < MinValue+2*Delta) and
           (VoltValues[i+2] > MinValue+2*Delta) then
      begin
        StartPoint := i;
        Break;
      end;

    // calculate display coefficient
    if Mode and AIB_INPRANGE > 0
      then DispCoeff := FPaintHeight / 20
      else DispCoeff := FPaintHeight / 10;

    // draw oscilloscope
    with FMemCanvas do
    try
      // clear background
      CopyRect(FPaintRect, FGridCanvas, FPaintRect);
      MoveTo( 0, FPaintHeight div 2 - Round (VoltValues[StartPoint] * DispCoeff));
      // draw oscilliscope
      for i := 1 to FPaintWidth do
        LineTo( i, FPaintHeight div 2 - Round (VoltValues[StartPoint+i] * DispCoeff));
    except
    end;
    FPaintCanvas.CopyRect(FPaintRect, FMemCanvas, FPaintRect);
  except
  end;
end;

end.