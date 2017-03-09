unit Wave1;

interface
{$IFDEF FPC} {$mode delphi} {$DEFINE AcqElphy2} {$A1} {$Z1} {$ENDIF}

uses windows,classes,messages,mmSystem,
     util1,Dgraphic,dtf0,
     stmdef,debug0;


Type
  Twave=class
        private
          hwo:hwaveOut;
          Wformat:TwaveFormatEx;

          data:typedataB;
          buffer:array[0..2] of PtabEntier;
          Whdr:array[0..2] of TWaveHDR;

          BufferPts:integer;
          CurBuf:integer;

          CurPos:integer;
          NumDone,NumSend:integer;
          SamplesDone,SamplesSend,SamplesTot:integer;

          Active:boolean;

          TabMoy:array of single;
          Nmoy:integer;
          TotMoy:single;

          FWindowHandle: HWnd;
          

          procedure setVolume(w:longword);
          function getVolume: longWord;

          procedure SendBlock;
          procedure DisposeBlock;

          procedure WndProc(var Message: TMessage);
        public
          Gm:single;
          Offm:single;
          AdjustOffset:boolean;
          OnEnd:procedure of object;

          constructor create(dat:typedataB;SamplesPerSec:integer);
          destructor destroy;override;
          procedure Seek(n:integer);
          procedure Play;
          procedure Stop;


          property Volume:longWord read getVolume write setVolume;
        end;

  TwaveInProc=procedure (var buf;nbBytes:integer) of object;

  TwaveIN=class
        private
          hwo:hwaveIn;
          Wformat:TwaveFormatEx;

          buffer:array[0..2] of PtabEntier;
          Whdr:array[0..2] of TWaveHDR;

          BufferPts:integer;
          CurBuf:integer;

          NumDone,NumSend:integer;
          SamplesDone,SamplesSend,SamplesTot:integer;

          Active:boolean;

          FWindowHandle: HWnd;

          waveInProc:TwaveInProc;
          Fstopping:boolean;

          procedure ProcessBlock;

          procedure WndProc(var Message: TMessage);
        public
          constructor create(SamplesPerSec:integer;proc:TwaveInProc);
          destructor destroy;override;
          procedure StartRecording;
          procedure StopRecording;

        end;

procedure TestWaveIn(proc:TwaveInProc);

implementation

{ Twave }

{ La méthode CallBack_window pose moins de problèmes que callBack_function. Donc on oublie
  la procédure suivante:

Procedure waveOutProc(Hwo:integer;uMsg,dwInstance,dwParam1,dwParam2:longword);stdCall;
begin
  if umsg=wom_done then
    with Twave(dwInstance) do
    begin
      disposeBlock;
      sendBlock;
    end;
end;

}
constructor Twave.create(dat: typedataB;SamplesPerSec:integer);
var
  i:integer;
begin
  data:=dat;

  BufferPts:=SamplesPerSec;
  for i:=0 to 2 do
  begin
    getmem(Buffer[i],BufferPts*sizeof(smallint));
    with WHdr[i] do
    begin
      lpData := pointer(buffer[i]);
      dwBufferLength := BufferPts*2;
      dwBytesRecorded :=0;
      dwUser := 0;
      dwFlags := 0;
      dwLoops := 1;
    end;
  end;

  with Wformat do
  begin
    wFormatTag:=1;
    nChannels:=1;
    nSamplesPerSec:=SamplesPerSec;
    nAvgBytesPerSec:=nSamplesPerSec*2;
    nBlockAlign:=2;
    wBitsPerSample:=16;
    cbSize:=0;
  end;

  Gm:=10;

  Nmoy:=SamplesPerSec div 2;
  setLength(tabmoy,Nmoy);
  fillchar(tabmoy[0],Nmoy*4,0);

  FWindowHandle := AllocateHWND(WndProc);
end;

destructor Twave.destroy;
var
  i:integer;
begin
  stop;
  for i:=0 to 2 do
    freemem(buffer[i]);

  DeAllocateHWND(FWindowHandle);
end;

procedure Twave.SendBlock;
var
  res,i,imax,nb:integer;
  p:PtabEntier;
  w:single;
  Fend:boolean;
begin
  if not active or not assigned(data) then exit;

  p:=buffer[numsend mod 3];

  Fend:=false;
  imax:=curPos+bufferPts-1;
  if imax>data.indiceMax then
  begin
    imax:=data.indiceMax;
    Fend:=true;
  end;

  if AdjustOffset then
    for i:=curPos to imax do
    begin
      TotMoy:=TotMoy-tabmoy[i mod Nmoy];
      w:=data.getE(i);
      TotMoy:=TotMoy+w;
      tabmoy[i mod Nmoy]:=w;
      p^[i-curPos]:=roundL(Gm*(w -TotMoy/Nmoy));
    end
  else
    for i:=curPos to imax do
    begin
      p^[i-curPos]:=roundL(Gm*(data.getE(i) -Offm));
    end;

  nb:=imax-curPos+1;
  curPos:=imax+1;


  WHdr[numSend mod 3].dwBufferLength:=nb*2;
  if nb>0 then
  begin
    Res := WaveOutPrepareHeader(HWO,@WHdr[numSend mod 3],SizeOf(TWaveHDR));
    if res<>0 then
    begin
      messageCentral('PrepareHeader Res='+Istr(res)+' numSend='+Istr(numsend)+' hwo='+Istr(hwo));
      active:=false;
      exit;
    end;

    Res := WaveOutWrite(HWO, @WHdr[numSend mod 3], SizeOf(TWaveHDR));
    if res<>0 then
    begin
      messageCentral('Write Res='+Istr(res));
      active:=false;
    end;

  end;

  inc(numSend);
  inc(samplesSend,nb);

  {if Fend and assigned(OnEnd)
    then OnEnd;}
end;

procedure Twave.DisposeBlock;
var
  Res:integer;
begin
  Res := WaveOutUnPrepareHeader(HWO, @WHdr[numDone mod 3], SizeOf(TWaveHDR));
  if res<>0 then messageCentral('Unprepare Res='+Istr(res));
  inc(SamplesDone,WHdr[numDone mod 3].dwBufferLength div 2);

  inc(numDone);

  if SAmplesDone>=SamplesTot then
  begin
    stop;
    if assigned(OnEnd)then OnEnd;
  end;
end;

procedure Twave.Play;
var
  res:integer;
  i:integer;
begin
  if not assigned(data) then exit;

  NumDone:=0;
  NumSend:=0;
  SamplesSend:=0;
  SamplesDone:=0;
  SamplesTot:=data.indiceMax-curPos+1;
  Active:=true;

  {
  res:=waveOutOpen(@Hwo,wave_mapper,@Wformat,intG(@waveOutProc),
              intG(self),Callback_function);
  }
  res:=waveOutOpen(@Hwo,wave_mapper,@Wformat,FWindowHandle,
              0,Callback_Window);

  if res=0 then
    for i:=0 to 2 do sendBlock
  else active:=false;
end;

procedure Twave.Seek(n: integer);
begin
  if assigned(data) then
  begin
    CurPos:=n;
    if CurPos<data.indicemin
      then CurPos:=data.indicemin;
    if CurPos>data.indicemax
      then CurPos:=data.indicemax;
  end;
end;

procedure Twave.Stop;
begin
  Active:=false;
  waveOutReset(HWO);
  waveOutClose(HWO);
end;



function Twave.getVolume: longWord;
var
  w:longWord;
begin
  waveOutgetVolume(hwo,@w);
  result:=w;
end;

procedure Twave.setVolume(w: longword);
begin
  waveOutsetVolume(hwo,w);
end;

procedure Twave.WndProc(var Message: TMessage);
begin
  case Message.Msg of
    MM_WOM_DONE : begin
                    disposeBlock;
                    sendBlock;
                  end;
  end;
end;

{************************** Méthodes de TwaveIn ******************************}


constructor TwaveIn.create(SamplesPerSec:integer;proc:TwaveInProc);
var
  i:integer;
begin
  BufferPts:=SamplesPerSec;
  waveInProc:=proc;

  for i:=0 to 2 do
  begin
    getmem(Buffer[i],BufferPts*sizeof(smallint));
    with WHdr[i] do
    begin
      lpData := pointer(buffer[i]);
      dwBufferLength := BufferPts*2;
      dwBytesRecorded :=0;
      dwUser := 0;
      dwFlags := 0;
      dwLoops := 0;
    end;
  end;

  with Wformat do
  begin
    wFormatTag:=1;
    nChannels:=1;
    nSamplesPerSec:=SamplesPerSec;
    nAvgBytesPerSec:=nSamplesPerSec*2;
    nBlockAlign:=2;
    wBitsPerSample:=16;
    cbSize:=0;
  end;

  FWindowHandle := AllocateHWND(WndProc);
end;

destructor TwaveIn.destroy;
var
  i:integer;
begin
  if active then stopRecording;
  for i:=0 to 2 do
    freemem(buffer[i]);

  DeAllocateHWND(FWindowHandle);
end;

procedure TwaveIn.ProcessBlock;
var
  Res:integer;
begin
  waveInProc(buffer[numDone mod 3]^,WHdr[numDone mod 3].dwBytesRecorded );

  Res := WaveinUnPrepareHeader(HWO, @WHdr[numDone mod 3], SizeOf(TWaveHDR));
  {if res<>0 then StatuslineTxt('WaveInUnprepareHeader Res='+Istr(res)+'  numDone='+Istr(numDone) );}
  inc(numDone);


  if active then
  begin
    with WHdr[numSend mod 3] do
    begin
      dwBytesRecorded :=0;
      dwUser := 0;
      dwFlags := 0;
      dwLoops := 0;
    end;
    WaveInPrepareHeader(HWO,@WHdr[NumSend mod 3],SizeOf(TWaveHDR));
    WaveInAddBuffer(hwo,@WHdr[NumSend mod 3],SizeOf(TWaveHDR));
    inc(numSend);
  end;

end;

procedure TwaveIn.StartRecording;
var
  res:integer;
  i:integer;
begin
  NumDone:=0;
  NumSend:=0;
  SamplesSend:=0;
  SamplesDone:=0;
  Active:=true;

  res:=waveInOpen(@Hwo,wave_mapper,@Wformat,FWindowHandle,
              0,Callback_Window);

  if res=0 then
    for i:=0 to 2 do
      begin
        res:=WaveInPrepareHeader(HWO,@WHdr[i],SizeOf(TWaveHDR));
        if res=0
          then WaveInAddBuffer(hwo,@WHdr[i],SizeOf(TWaveHDR))
          else
            begin
              active:=false;
              break;
            end;
        inc(NumSend);
      end
  else
    active:=false;

  if active then waveInStart(hwo);
end;

procedure TwaveIn.StopRecording;
begin
  Fstopping:=true;
  Active:=false;
  waveInStop(HWO);

  {repeat until not Fstopping;}
  waveInReset(HWO);
  waveInClose(HWO);
end;


procedure TwaveIn.WndProc(var Message: TMessage);
begin
  case Message.Msg of
    MM_WIM_DATA : begin
                    ProcessBlock;
                    Fstopping:=false;
                  end;
    MM_WIM_CLOSE: Fstopping:=false;

  end;
end;

procedure TestWaveIn(proc:TwaveInProc);
var
  wave:TwaveIn;
begin
  wave:=TwaveIn.create(4000,proc);
  wave.StartRecording;

  messageCentral('Running');
  wave.StopRecording;
  messageCentral('nb='+Istr(wave.numDone)+crlf+
                 'nb='+Istr(wave.WHDR[0].dwBytesRecorded)+crlf+
                 'nb='+Istr(wave.WHDR[1].dwBytesRecorded)+crlf+
                 'nb='+Istr(wave.WHDR[2].dwBytesRecorded)+crlf

                  );
  wave.Free;
end;

end.
