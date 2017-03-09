unit MainForm;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, ComCtrls, Buttons,
  AnInp, AnOut, DgInp, DgOut, Counters, DAQDefs, pwrdaq,
  pwrdaq32, pdfw_def, ImgList;

type

  // Main form class
  TMain = class(TForm)
    PageControl1: TPageControl;
    InfoPage: TTabSheet;
    AInPage: TTabSheet;
    DInPage: TTabSheet;
    AOutPage: TTabSheet;
    DOutPage: TTabSheet;
    NumAdapters: TLabel;
    InfoMemo: TMemo;
    RefreshBtn: TButton;
    AnalogPaintBox: TPaintBox;
    StartAInBtn: TButton;
    StopAinBtn: TButton;
    FreqEdit: TEdit;
    OutFreqEdit: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    FrequencyGroup: TGroupBox;
    TypesGroup: TRadioGroup;
    GainGroup: TRadioGroup;
    RangesGroup: TRadioGroup;
    StartAOutBtn: TButton;
    StopAOutBtn: TButton;
    GroupBox1: TGroupBox;
    Chan0Func: TRadioGroup;
    StartDInBtn: TButton;
    StopDInBtn: TButton;
    TotalChan: TEdit;
    ActiveChan: TEdit;
    TotalUpDown: TUpDown;
    ActiveUpDown: TUpDown;
    FreqTrackBar: TTrackBar;
    Label4: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    GroupBox2: TGroupBox;
    Label10: TLabel;
    Label12: TLabel;
    Label13: TLabel;
    AOutFrequency: TTrackBar;
    Label9: TLabel;
    Label5: TLabel;
    Label8: TLabel;
    Label11: TLabel;
    InBit0: TImage;
    InBit1: TImage;
    InBit2: TImage;
    InBit3: TImage;
    InBit4: TImage;
    InBit5: TImage;
    InBit6: TImage;
    InBit7: TImage;
    Label21: TLabel;
    HexIn: TEdit;
    Label22: TLabel;
    MaxAOut: TLabel;
    HexOut: TEdit;
    Label24: TLabel;
    OutBit0: TImage;
    OutBit1: TImage;
    Label25: TLabel;
    OutBit2: TImage;
    Label26: TLabel;
    OutBit3: TImage;
    Label27: TLabel;
    OutBit4: TImage;
    Label28: TLabel;
    OutBit5: TImage;
    Label29: TLabel;
    OutBit6: TImage;
    Label30: TLabel;
    OutBit7: TImage;
    Label31: TLabel;
    Label32: TLabel;
    Label33: TLabel;
    StartDOutBtn: TButton;
    StopDOutBtn: TButton;
    ImageList1: TImageList;
    Label41: TLabel;
    Label42: TLabel;
    Label43: TLabel;
    DigInpFreq: TTrackBar;
    Label35: TLabel;
    Label36: TLabel;
    Label37: TLabel;
    DigOutFreq: TTrackBar;
    Chan0Amp: TTrackBar;
    Label38: TLabel;
    Chan1Amp: TTrackBar;
    Label39: TLabel;
    DecimalIn: TEdit;
    DecimalOut: TEdit;
    RandomValue: TTrackBar;
    Label40: TLabel;
    Label44: TLabel;
    Label45: TLabel;
    DigitalPaintBox: TPaintBox;
    Panel1: TPanel;
    Image9: TImage;
    BoardCombo: TComboBox;
    ModesGroup: TRadioGroup;
    CntPage: TTabSheet;
    CountGroup0: TGroupBox;
    OutGroup0: TRadioGroup;
    ExtClock0: TCheckBox;
    ExtGate0: TCheckBox;
    StartCOBtn: TButton;
    StopCOBtn: TButton;
    Value0: TEdit;
    Label34: TLabel;
    CntFreq0: TTrackBar;
    Label15: TLabel;
    GroupBox3: TGroupBox;
    Label17: TLabel;
    OutGroup1: TRadioGroup;
    ExtClock1: TCheckBox;
    ExtGate1: TCheckBox;
    Value1: TEdit;
    CntFreq1: TTrackBar;
    GroupBox4: TGroupBox;
    Label19: TLabel;
    OutGroup2: TRadioGroup;
    ExtClock2: TCheckBox;
    ExtGate2: TCheckBox;
    Value2: TEdit;
    CntFreq2: TTrackBar;
    Label16: TLabel;
    Label18: TLabel;
    Label20: TLabel;
    Label46: TLabel;
    Label47: TLabel;
    Label48: TLabel;
    Chan1Func: TRadioGroup;
    procedure RefreshBtnClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure StartAInBtnClick(Sender: TObject);
    procedure StopAinBtnClick(Sender: TObject);
    procedure AnalogPaintBoxPaint(Sender: TObject);
    procedure FreqSliderChange(Sender: TObject);
    procedure ActiveChanChange(Sender: TObject);
    procedure TypesGroupClick(Sender: TObject);
    procedure StartAOutBtnClick(Sender: TObject);
    procedure StopAOutBtnClick(Sender: TObject);
    procedure StartDInBtnClick(Sender: TObject);
    procedure StopDInBtnClick(Sender: TObject);
    procedure DigInpFreqChange(Sender: TObject);
    procedure StartDOutBtnClick(Sender: TObject);
    procedure StopDOutBtnClick(Sender: TObject);
    procedure DigOutFreqChange(Sender: TObject);
    procedure DigitalPaintBoxPaint(Sender: TObject);
    procedure FillOutputBuffer(Sender: TObject);
    procedure TotalChanChange(Sender: TObject);
    procedure ModesGroupClick(Sender: TObject);
    procedure StartCOBtnClick(Sender: TObject);
    procedure StopCOBtnClick(Sender: TObject);
    procedure OutGroupClick(Sender: TObject);
    procedure AOutFrequencyChange(Sender: TObject);
  private
    { Private declarations }
    hAdapter : THandle;
    hDriver : DWORD;
    dwError : DWORD;
    dwNumAdapters : DWORD;
    MaxChannels: DWORD;
    AdapterResolution: DWORD;
    PDVersion : PWRDAQ_VERSION;
    PDPciConfig : PWRDAQ_PCI_CONFIG;
    AdapterInfo : TADAPTER_INFO_STRUCT;
    AcquisitionSetup : TAcquisitionSetup;
    AnalogInput : TAnalogInput;
    AnalogOutput : TAnalogOutput;
    DigitalInput : TDigitalInput;
    DigitalOutput : TDigitalOutput;
    Counters : TCounter;
    // for digital input
    PrevValue: Byte;
    OnBitmap : TBitmap;
    OffBitmap : TBitmap;
    // for analog output simulation
    Period: Real;
    ZeroShift, HalfRange: DWORD;
    FuncValues: array [0..3,0..2047] of Real;
    OutputBuffer: TAnalogOutputBuffer;
    procedure ChangeLED(LEDName: String; Value: Byte);
    procedure AnalogInputTerminate(Sender: TObject);
    procedure AnalogOutputTerminate(Sender: TObject);
    procedure DigitalInputTerminate(Sender: TObject);
    procedure DigitalOutputTerminate(Sender: TObject);
    procedure CountersTerminate(Sender: TObject);
    procedure DigitalInputUpdateView (Value: Integer);
    function  DigitalOutputGetData: Cardinal;
    procedure DigitalOutputUpdateView (Value: Integer);
    procedure UpdatePaintBox(Value: Integer);
    procedure UpdateCountersValue;
    procedure PreCalculate;
  public
    { Public declarations }
    procedure SetupInfoPage;
    procedure SetupAnalogInput;
    procedure SetupDigitalInput;
  end;

var
  Main: TMain;

implementation

{$R *.DFM}

procedure TMain.FormCreate(Sender: TObject);
begin
  // get driver and adapter information
  SetupInfoPage;
  // setup analog input page
  SetupAnalogInput;
  // setup digital input page
  SetupDigitalInput;
  // set info page as active page
  PageControl1.ActivePage := InfoPage;
end;

procedure TMain.SetupInfoPage;
begin
  try
    // open the PowerDAQ driver
    if not PdDriverOpen(@hDriver, @dwError, @dwNumAdapters)
      then raise TPwrDaqException.Create('PdDriverOpen',dwError);
    // select first board
    BoardCombo.Items.Add('');
    BoardCombo.ItemIndex := 0;
    // refreshing information about adapter
    RefreshBtnClick(Self);
    if ParamCount > 0 then
    begin
      BoardCombo.ItemIndex := StrToInt(ParamStr(1));
      RefreshBtnClick(Self);
    end;
  except
    Application.HandleException(Self);
    hAdapter := INVALID_HANDLE_VALUE;
    NumAdapters.Caption := 'Adapter not found or driver not started';
  end;
end;

procedure TMain.SetupAnalogInput;
begin
  // setup acqusition initial data
  TotalChanChange(Self);
end;

procedure TMain.SetupDigitalInput;
begin
  // assign images for digital i/o
  OnBitmap := TBitmap.Create;
  OffBitmap := TBitmap.Create;
  ImageList1.GetBitmap(0, OnBitmap);
  ImageList1.GetBitmap(1, OffBitmap);
  ChangeLED('InBit', 0);
  ChangeLED('OutBit', 0);
end;

procedure TMain.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  if hAdapter <> INVALID_HANDLE_VALUE then
  try
    // stop analog input
    StopAInBtnClick(Self);
    // stop analog output
    StopAOutBtnClick(Self);
    // stop digital input
    StopDInBtnClick(Self);
    // stop digital output
    StopDOutBtnClick(Self);
    // stop counters
    StopCOBtnClick(Self);
    // close adapter
    if not _PdAdapterClose(hAdapter, @dwError)
      then raise TPwrDaqException.Create('PdAdapterClose', dwError);
    // close driver
    if not PdDriverClose(hDriver, @dwError)
      then raise TPwrDaqException.Create('PdDriverClose', dwError);
  except end;
  Action := caFree;
end;

// ************ Code part for refreshing driver & board information ***********

procedure TMain.RefreshBtnClick(Sender: TObject);
const
  DividerStr = '************************************************************************************';
  GainStr : array [Boolean, 0..3] of PChar = (('x 1','x 2','x 4','x 8'), ('x 1','x 10','x 100','x 1000'));
var
  i, SaveIndex: Integer;
  s: ShortString;
begin
  // stop all threads
  StopAInBtnClick(Self);
  StopAOutBtnClick(Self);
  StopDInBtnClick(Self);
  StopDOutBtnClick(Self);

  _PdAdapterClose(hAdapter, @dwError);
  // store all boards name into combo box
  SaveIndex := BoardCombo.ItemIndex;
  BoardCombo.Items.Clear;
  for i:=0 to dwNumAdapters-1 do
  begin
    // Get adapter info
    if _PdGetAdapterInfo(i, @dwError, @AdapterInfo)
    then with AdapterInfo, BoardCombo.Items do Add(lpBoardName+'   s/n: '+lpSerialNum)
    else with AdapterInfo, BoardCombo.Items do Add('Not available');
  end;

  // displaing total adapters count
  NumAdapters.Caption := 'Number of adapters installed: '+IntToStr(dwNumAdapters);
  BoardCombo.ItemIndex := SaveIndex;

  // open the first PowerDAQ PCI adapter.
  if not _PdAdapterOpen(BoardCombo.ItemIndex, @dwError, @hAdapter)
    then raise TPwrDaqException.Create('PdAdapterOpen',dwError);

  // clear all information
  InfoMemo.Lines.Clear;
  InfoMemo.Lines.BeginUpdate;
  if hAdapter <> INVALID_HANDLE_VALUE then
  try
    // getting information about board from driver ...
    if not PdGetVersion(hDriver, @dwError, @PDVersion)
      then raise TPwrDaqException.Create('PdGetVersion', dwError);
    // and storing information in list box
    with PDVersion, InfoMemo.Lines do
    begin
      Add('Driver info');
      Add(DividerStr);
      Add('Major version :'#9#9+IntToStr(MajorVersion));
      Add('Minor version :'#9#9+IntToStr(MinorVersion));
      Add('Build type : '#9#9+BuildType);
      Add('Build time stamp : '#9#9+BuildTimeStamp+#13#10);
    end;

    // getting information about PCI configuration from driver ...
    if not PdGetPciConfiguration(hAdapter,  @dwError, @PDPciConfig)
      then raise TPwrDaqException.Create('PdGetPciConfiguration', dwError);

    // and storing information in list box
    with PDPciConfig, InfoMemo.Lines do
    begin
      Add('PCI info');
      Add(DividerStr);
      Add('Vendor ID :'#9#9'0x'+IntToHex(VendorID,4));
      Add('Device ID :'#9#9'0x'+IntToHex(DeviceID,4));
      Add('Revision ID :'#9#9'0x'+IntToHex(RevisionID,4));
      Add('Base address :'#9#9'0x'+IntToHex(Cardinal(BaseAddress0),8));
      Add('Interrupt line :'#9#9'0x'+IntToHex(InterruptLine,2));
      Add('Subsystem ID :'#9#9'0x'+IntToHex(SubsystemID,4)+#13#10);
    end;

    // Get adapter info
    if not _PdGetAdapterInfo(BoardCombo.ItemIndex, @dwError, @AdapterInfo)
      then raise TPwrDaqException.Create('PdGetAdapterInfo',dwError);

    // retrieve information from header
    with AdapterInfo, InfoMemo.Lines do
    begin
      Add('Board info');
      Add(DividerStr);
      Add('Board Name :'#9#9+lpBoardName);
      Add('Serial Number :'#9#9+lpSerialNum);
      Add('FIFO Size :'#9#9+IntToStr(SSI[AnalogIn].dwFifoSize)+' samples');

      if SSI[AnalogIn].dwChannels > 0 then
      begin
        Add('Analog input channels:'#9+IntToStr(SSI[AnalogIn].dwChannels));
        Add('Analog input capacity:'#9+IntToStr(SSI[AnalogIn].dwChBits)+' bits');
        Add('Analog input max. rate:'#9+IntToStr(SSI[AnalogIn].dwRate));
        s:='';
        for i:=0 to SSI[AnalogIn].dwMaxRanges-1 do
          s:=s+FloatToStrF(SSI[AnalogIn].fRangeLow[i], ffNumber, 3, 1)+'/'+FloatToStrF(SSI[AnalogIn].fRangeHigh[i], ffNumber, 3, 1)+'  ';
        Add('Analog input ranges:'#9#9+s);
        s:='';
        for i:=0 to SSI[AnalogIn].dwMaxGains-1 do
          s:=s+FloatToStrF(SSI[AnalogIn].fGains[i], ffFixed, 4, 0)+', ';
        Dec(s[0],2);
        Add('Analog input gains:'#9#9+s);
      end;

      if SSI[AnalogOut].dwChannels > 0 then
      begin
        Add('Analog output channels:'#9+IntToStr(SSI[AnalogOut].dwChannels));
        Add('Analog output capacity:'#9+IntToStr(SSI[AnalogOut].dwChBits)+' bits');
        Add('Analog output max. rate:'#9+IntToStr(SSI[AnalogOut].dwRate));
        s:='';
        for i:=0 to SSI[AnalogOut].dwMaxRanges-1 do
          s:=s+FloatToStrF(SSI[AnalogOut].fRangeLow[i], ffNumber, 3, 1)+'/'+FloatToStrF(SSI[AnalogOut].fRangeHigh[i], ffNumber, 3, 1)+'  ';
        Add('Analog output ranges:'#9+s);
        s:='';
        for i:=0 to SSI[AnalogOut].dwMaxGains-1 do
          s:=s+FloatToStrF(SSI[AnalogOut].fGains[i], ffFixed, 3, 1)+', ';
        Dec(s[0],2);
        Add('Analog output gains:'#9#9+s);
      end;

      if SSI[DigitalIn].dwChannels > 0 then
      begin
        Add('Digital in/out channels:'#9+IntToStr(SSI[DigitalIn].dwChannels));
        Add('Digital in/out capacity:'#9+IntToStr(SSI[DigitalIn].dwChBits)+' bits');
        Add('Digital in/out max. rate:'#9+IntToStr(SSI[DigitalIn].dwRate));
      end;

      if SSI[CounterTimer].dwChannels > 0 then
      begin
        Add('Counter/Timer channels:'#9+IntToStr(SSI[CounterTimer].dwChannels));
        Add('Counter/Timer capacity:'#9+IntToStr(SSI[CounterTimer].dwChBits)+' bits');
        Add('Counter/Timer max. rate:'#9+IntToStr(SSI[CounterTimer].dwRate));
      end;

      // enable or disable analog input options tab
      if atType and atMF <> 0
        then AInPage.TabVisible := True
        else AInPage.TabVisible := False;

      // enable or disable analog output options tab
      if atType and atPD2DIO <> 0 then
      begin
        AOutPage.TabVisible := False;
        DInPage.TabVisible := False;
        DOutPage.TabVisible := False;
        CntPage.TabVisible := False;
      end
      else begin
        AOutPage.TabVisible := True;
        DInPage.TabVisible := True;
        DOutPage.TabVisible := True;
        CntPage.TabVisible := True;
      end;

      // setup current board resolution
      if SSI[AnalogOut].wXorMask = $800
         then AdapterResolution := 12
         else AdapterResolution := 16;

      // setup gains info
      GainGroup.Items.Clear;
      for i:= 0 to 3 do GainGroup.Items.Add (GainStr[(SSI[AnalogIn].fGains[1]=10) , i]);
      GainGroup.ItemIndex := 0;

      // Setup max freq for Analog Input
      if SSI[AnalogIn].dwRate > 0 then
      begin
        FreqTrackBar.Max := SSI[AnalogIn].dwRate div 1000;
        FreqTrackBar.Frequency := FreqTrackBar.Max div 50;
      end;

      // Setup max freq for Analog Output
      if SSI[AnalogOut].dwRate > 0 then
      begin
        AOutFrequency.Max := SSI[AnalogOut].dwRate;
        AOutFrequency.Frequency := AOutFrequency.Max div 50;
        MaxAOut.Caption := IntToStr(AOutFrequency.Max);
      end;

      // setup max. channels
      MaxChannels := SSI[AnalogIn].dwChannels;
      TotalUpDown.Max := MaxChannels;
      TotalChan.OnChange(Self);
    end;
  except
    Application.HandleException (Self);
  end;
  InfoMemo.Lines.EndUpdate;
end;

// ***************** Code part for analog input service **********************
procedure TMain.StartAInBtnClick(Sender: TObject);
const
  Modes : array [0..1] of DWORD = (0, AIB_INPMODE);
  Types : array [0..1] of DWORD = (0, AIB_INPTYPE);
  Ranges : array [0..1] of DWORD = (0, AIB_INPRANGE);
begin
  // disable controls
  StartAInBtn.Enabled := False;
  FrequencyGroup.Enabled := False;
  ModesGroup.Enabled := False;
  TypesGroup.Enabled := False;
  RangesGroup.Enabled := False;
  GainGroup.Enabled := False;
  TotalChan.Enabled := False;
  StopAInBtn.Enabled := True;
  // fill setup record
  with AcquisitionSetup do
  begin
    Adapter := hAdapter;
    BoardType := AdapterInfo.atType;
    Resolution := AdapterResolution;
    FIFOSize := AdapterInfo.SSI[AnalogIn].dwFifoSize;
    Frequency := FreqTrackBar.Position * 1000;
    DefGain := GainGroup.ItemIndex;
    Channel := StrToInt(ActiveChan.Text);
    NumChannels := StrToInt(TotalChan.Text);
    AInMode := Modes [ModesGroup.ItemIndex];
    AInType := Types [TypesGroup.ItemIndex];
    AInRange:= Ranges [RangesGroup.ItemIndex];
    PaintRect := AnalogPaintBox.ClientRect;
    PaintCanvas := AnalogPaintBox.Canvas;
  end;
  // create acqusition thread and run immediately
  AnalogInput := TAnalogInput.Create(AcquisitionSetup);
  AnalogInput.ActiveChannel := StrToInt(ActiveChan.Text);
  AnalogInput.OnTerminate := AnalogInputTerminate;
end;

procedure TMain.StopAinBtnClick(Sender: TObject);
begin
  if Assigned(AnalogInput) then
  begin
    AnalogInput.Free;
    AnalogInput := nil;
  end;
end;

procedure TMain.AnalogInputTerminate(Sender: TObject);
begin
  // enable controls
  StartAInBtn.Enabled := True;
  FrequencyGroup.Enabled := True;
  ModesGroup.Enabled := True;
  TypesGroup.Enabled := True;  
  RangesGroup.Enabled := True;
  GainGroup.Enabled := True;
  TotalChan.Enabled := True;
  StopAInBtn.Enabled := False;
end;

procedure TMain.AnalogPaintBoxPaint(Sender: TObject);
var i: Integer;
begin
  // repaint view display
  with AnalogPaintBox, AnalogPaintBox.Canvas do
  begin
    Brush.Color := clBlack;
    FillRect(ClientRect);
    Pen.Color := clGray;
    for i:=1 to 9 do
    begin
      MoveTo(Round(i * ClientWidth / 10), 0);
      LineTo(Round(i * ClientWidth / 10), Height);
    end;
    for i:=1 to 9 do
    begin
      if i=5 then Pen.Color := clWhite else Pen.Color := clGray;
      MoveTo(0, Round(i * ClientHeight / 10));
      LineTo(Width, Round(i * ClientHeight / 10));
    end;
  end;
end;

procedure TMain.FreqSliderChange(Sender: TObject);
begin
  FreqEdit.Text := IntToStr(FreqTrackBar.Position * 1000);
end;

procedure TMain.TotalChanChange(Sender: TObject);
begin
  if StrToInt(TotalChan.Text) > 0 then
  try
    if StrToInt(TotalChan.Text) > TotalUpDown.Max
      then TotalChan.Text := IntToStr(TotalUpDown.Max);
    ActiveUpDown.Max := StrToInt(TotalChan.Text)-1;
    ActiveChan.Text := '0';
    FreqTrackBar.Max := AdapterInfo.SSI[AnalogIn].dwRate div (1000 * StrToInt (TotalChan.Text));
    FreqSliderChange(Self);
  except
  end;
end;

procedure TMain.ActiveChanChange(Sender: TObject);
begin
  if Assigned(AnalogInput)
    then AnalogInput.ActiveChannel := StrToInt(ActiveChan.Text);
end;

procedure TMain.ModesGroupClick(Sender: TObject);
begin
  // in defferential mod we must decrease total chan. count
{ if ModesGroup.ItemIndex = 0
    then TotalUpDown.Max := MaxChannels
    else TotalUpDown.Max := MaxChannels div 2; 
  TotalChan.OnChange(Self); }
end;

procedure TMain.TypesGroupClick(Sender: TObject);
const
  RangesStr : array [Boolean,Boolean] of PChar = (('0-5 V','0-10 V'), ('±  5  V','± 10 V'));
var
  SaveIndex : Integer;
begin
  // change string value in ranges group
  SaveIndex := RangesGroup.ItemIndex;
  RangesGroup.Items.Clear;
  RangesGroup.Items.Add(RangesStr[Boolean(TypesGroup.ItemIndex), False]);
  RangesGroup.Items.Add(RangesStr[Boolean(TypesGroup.ItemIndex), True]);
  RangesGroup.ItemIndex := SaveIndex;
end;

// ***************** Code part for analog output service **********************

procedure TMain.StartAOutBtnClick(Sender: TObject);
begin
  // disable controls
  StartAOutBtn.Enabled := False;
  StopAOutBtn.Enabled := True;
  AOutFrequency.Enabled := False;
  // create output thread
  AnalogOutput := TAnalogOutput.Create(hAdapter);
  // fill output buffer
  ZeroShift := (1 shl AdapterInfo.SSI[AnalogOut].dwChBits) div 2;
  HalfRange := ZeroShift div Chan0Amp.Max;
  Period := 12*Pi / 2048;
  PreCalculate;
  FillOutputBuffer(Self);
  // setup parameters
  AnalogOutput.Frequency := AOutFrequency.Position;
  AnalogOutput.AdapterType := AdapterInfo.atType;
  AnalogOutput.Buffer := @OutputBuffer;
  AnalogOutput.OnTerminate := AnalogOutputTerminate;
  AnalogOutput.Resume;
end;

procedure TMain.StopAOutBtnClick(Sender: TObject);
begin
  if Assigned(AnalogOutput) then
  begin
    AnalogOutput.Free;
    AnalogOutput := nil;
  end;
end;

procedure TMain.AnalogOutputTerminate(Sender: TObject);
begin
  // enable controls
  StartAOutBtn.Enabled := True;
  StopAOutBtn.Enabled := False;
  AOutFrequency.Enabled := True;
end;

procedure TMain.AOutFrequencyChange(Sender: TObject);
begin
  OutFreqEdit.Text := IntToStr(AOutFrequency.Position);
  if Assigned(AnalogOutput) then
    AnalogOutput.Frequency := AOutFrequency.Position;
end;

// pre-calculates data arrays (values between -1 and 1)
procedure TMain.PreCalculate;
var i: Integer;
    Phase: Real;
begin
  Phase := 0.0;
  for i:=Low(FuncValues[0]) to High(FuncValues[0]) do
  begin
    // pre-calculate sine wave
    FuncValues[0,i] := Sin (Phase);
    // pre-calculate square wave
    if FuncValues[0,i] < 0 then FuncValues[1,i]:= -1 else FuncValues[1,i]:= 1;
    // pre-calculate triangle wave
    if Phase <= Pi
      then FuncValues[2,i]:= 2.0 * Phase / Pi - 1.0
      else FuncValues[2,i]:= 3.0 - 2.0 * Phase / Pi;
    // pre-calculate sawtooth wave
    if Phase <= 2*Pi
      then FuncValues[3,i]:= Phase / Pi - 1.0
      else FuncValues[3,i]:= -1;
    // increase phase
    Phase := Phase+Period;
    if Phase >= 2*Pi then Phase := 0;
  end;
end;

procedure TMain.FillOutputBuffer(Sender: TObject);
var i: Integer;
    Value: array [0..1] of DWORD;
begin
  if AdapterInfo.atType and atMF > 0 then
     for i:=Low(OutputBuffer) to High(OutputBuffer) do
     begin
       Value[0] := Round ((FuncValues [Chan0Func.ItemIndex, i]) * (HalfRange * Chan0Amp.Position)) + ZeroShift;
       Value[1] := Round ((FuncValues [Chan1Func.ItemIndex, i]) * (HalfRange * Chan1Amp.Position)) + ZeroShift;
       OutputBuffer[i] := Value[1] shl 12 or Value[0];
     end
  else
     for i:=Low(OutputBuffer) to High(OutputBuffer) div 2 do
     begin
       OutputBuffer[i*2]   := Round((FuncValues [Chan0Func.ItemIndex, i]) * (HalfRange * Chan0Amp.Position)) + ZeroShift + (0 shl 16);
       OutputBuffer[i*2+1] := Round((FuncValues [Chan1Func.ItemIndex, i]) * (HalfRange * Chan1Amp.Position)) + ZeroShift + (1 shl 16);
     end;
  // re-output data
  if Assigned (AnalogOutput) then AnalogOutput.SettingsChanges := True;
end;

// ****************** Code part for digital i/o services **********************

procedure TMain.ChangeLED(LEDName: String; Value: Byte);
var
   i, BitNum: Integer;
begin
  for i:=0 to ComponentCount-1 do
    if Pos(LEDName, Components[i].Name) > 0 then
    begin
      BitNum := StrToInt(Copy(Components[i].Name, Length(LEDName)+1,255));
      if (1 shl BitNum) and Value = 0
        then TImage(Components[i]).Picture.Bitmap.Assign(OffBitmap)
        else TImage(Components[i]).Picture.Bitmap.Assign(OnBitmap);
    end;
end;

// ***************** Code part for digital input service **********************

procedure TMain.StartDInBtnClick(Sender: TObject);
begin
  // disable controls
  StartDInBtn.Enabled := False;
  StopDInBtn.Enabled := True;
  // create acqusition thread and run immediately
  DigitalInput := TDigitalInput.Create(hAdapter);
  DigitalInput.Frequency := DigInpFreq.Position;
  DigitalInput.OnTerminate := DigitalInputTerminate;
  DigitalInput.OnUpdateView :=  DigitalInputUpdateView;
end;

procedure TMain.StopDInBtnClick(Sender: TObject);
begin
  if Assigned(DigitalInput) then
  begin
    DigitalInput.Free;
    DigitalInput := nil;
  end;
end;

procedure TMain.DigitalInputTerminate(Sender: TObject);
begin
  // enable controls
  StartDInBtn.Enabled := True;
  StopDInBtn.Enabled := False;
end;

procedure TMain.DigitalPaintBoxPaint(Sender: TObject);
begin
  // repaint view display
  DigitalPaintBox.Canvas.Brush.Color := clBlack;
  DigitalPaintBox.Canvas.FillRect(ClientRect);
end;

procedure TMain.UpdatePaintBox(Value: Integer);
const
  BitColors : array [0..7] of TColor = (clWhite, clRed, clWhite, clRed, clWhite, clRed, clWhite, clRed);
  dX = 5;
var
  SrcRect, DstRect: TRect;
  i, y, y2: Integer;
begin
  with DigitalPaintBox, DigitalPaintBox.Canvas do
  try
    // shift paint box canvas to left on 1 pixel
    SrcRect := ClipRect;
    DstRect := ClipRect;
    OffsetRect (DstRect, -dX, 0);
    CopyRect(DstRect, DigitalPaintBox.Canvas, SrcRect);
    FillRect(Rect(SrcRect.Right-dX, SrcRect.Top, SrcRect.Right, SrcRect.Bottom));
    for i:=0 to 7 do
    begin
      Pen.Color := BitColors[i];
      // for vertical lines
      if (Value and (1 shl i)) <> (PrevValue and (1 shl i)) then
      begin
        if (1 shl i) and PrevValue <> 0 then
        begin
          y := i*3+i*8;
          y2 := i*3+(i+1)*8;
        end
        else begin
          y := i*3+(i+1)*8;
          y2 := i*3+i*8;
        end;
        MoveTo (SrcRect.Right-dX-1, y);
        LineTo (SrcRect.Right-dX-1, y2);
      end;
      // for horizontal lines
      if (1 shl i) and Value <> 0
        then y := i*3+i*8           // low level
        else y := i*3+(i+1)*8;      // high level
      MoveTo (SrcRect.Right-dX-1, y);
      LineTo (SrcRect.Right-1, y);
    end;
  finally
    PrevValue := Value;
  end;
end;

procedure TMain.DigInpFreqChange(Sender: TObject);
begin
  if Assigned(DigitalInput)
    then DigitalInput.Frequency := DigInpFreq.Position;
end;

procedure TMain.DigitalInputUpdateView (Value: Integer);
begin
  DecimalIn.Text := IntToStr(Value);
  HexIn.Text := '0x'+IntToHex(Value,4);
  ChangeLED('InBit', Value);
  UpdatePaintBox(Value);
end;

// ***************** Code part for digital output service ********************

procedure TMain.StartDOutBtnClick(Sender: TObject);
begin
  // disable controls
  StartDOutBtn.Enabled := False;
  StopDOutBtn.Enabled := True;
  // create acqusition thread and run immediately
  DigitalOutput := TDigitalOutput.Create(hAdapter);
  DigitalOutput.Frequency := DigOutFreq.Position;
  DigitalOutput.OnTerminate := DigitalOutputTerminate;
  DigitalOutput.OnGetData :=  DigitalOutputGetData;
  DigitalOutput.OnUpdateView :=  DigitalOutputUpdateView;
end;

procedure TMain.StopDOutBtnClick(Sender: TObject);
begin
  if Assigned(DigitalOutput) then
  begin
    DigitalOutput.Free;
    DigitalOutput := nil;
  end;
end;

procedure TMain.DigitalOutputTerminate(Sender: TObject);
begin
  // enable controls
  StartDOutBtn.Enabled := True;
  StopDOutBtn.Enabled := False;
end;

function TMain.DigitalOutputGetData: Cardinal;
begin
  Result := Random (RandomValue.Position);
end;

procedure TMain.DigitalOutputUpdateView (Value: Integer);
begin
  DecimalOut.Text := IntToStr(Value);
  HexOut.Text := '0x'+IntToHex(Value,4);
  ChangeLED('OutBit', Value);
end;

procedure TMain.DigOutFreqChange(Sender: TObject);
begin
  if Assigned(DigitalOutput)
    then DigitalOutput.Frequency := DigOutFreq.Position;
end;

// ***************** Code part for counters/timers service *******************

procedure TMain.StartCOBtnClick(Sender: TObject);
const
  Clocks  : array [0..2,Boolean] of DWORD = ((UTB_CLK0, UTB_CLK0 or UTB_CLK0_1),
                                             (UTB_CLK1, UTB_CLK1 or UTB_CLK1_1),
                                             (UTB_CLK2, UTB_CLK2 or UTB_CLK2_1));
  Gates   : array [0..2,Boolean] of DWORD = ((UTB_SWGATE0, UTB_GATE0),
                                             (UTB_SWGATE1, UTB_GATE1),
                                             (UTB_SWGATE2, UTB_GATE2));
begin
  StartCOBtn.Enabled := False;
  ExtClock0.Enabled := False;
  ExtClock1.Enabled := False;
  ExtClock2.Enabled := False;
  ExtGate0.Enabled := False;
  ExtGate1.Enabled := False;
  ExtGate2.Enabled := False;
  StopCOBtn.Enabled := True;
  Counters := TCounter.Create(hAdapter);
  // setup clock sources
  Counters.Clocks[0] := Clocks[0, ExtClock0.Checked];
  Counters.Clocks[1] := Clocks[1, ExtClock1.Checked];
  Counters.Clocks[2] := Clocks[2, ExtClock2.Checked];
  // setup gate sources
  Counters.Gates[0] := Gates[0, ExtGate0.Checked];
  Counters.Gates[1] := Gates[1, ExtGate1.Checked];
  Counters.Gates[2] := Gates[2, ExtGate2.Checked];
  Counters.OnUpdateView := UpdateCountersValue;
  Counters.OnTerminate := CountersTerminate;
  Counters.Resume;
  // setup modes
  OutGroupClick(Self);
end;

procedure TMain.UpdateCountersValue;
begin
  Value0.Text := IntToStr(Counters.Values[0]);
  Value1.Text := IntToStr(Counters.Values[1]);
  Value2.Text := IntToStr(Counters.Values[2]);
end;

procedure TMain.StopCOBtnClick(Sender: TObject);
begin
  if Assigned(Counters) then
  begin
    Counters.Free;
    Counters := nil;
  end;
end;

procedure TMain.CountersTerminate(Sender: TObject);
begin
  // enable controls
  StartCOBtn.Enabled := True;
  ExtClock0.Enabled := True;
  ExtClock1.Enabled := True;
  ExtClock2.Enabled := True;
  ExtGate0.Enabled := True;
  ExtGate1.Enabled := True;
  ExtGate2.Enabled := True;
  StopCOBtn.Enabled := False;
end;

procedure TMain.OutGroupClick(Sender: TObject);
const
  CntModes: array [0..1] of DWORD = (UCT_SQUARE, UCT_IMPULSE);
begin
  if Counters <> nil then
  try
    Counters.Modes[0] := CntModes[OutGroup0.ItemIndex];
    Counters.Modes[1] := CntModes[OutGroup1.ItemIndex];
    Counters.Modes[2] := CntModes[OutGroup2.ItemIndex];
    // setup frequency
    Counters.Values[0] := $FFFF div CntFreq0.Position;
    Counters.Values[1] := $FFFF div CntFreq1.Position;
    Counters.Values[2] := $FFFF div CntFreq2.Position;
  except
  end;
end;

end.
