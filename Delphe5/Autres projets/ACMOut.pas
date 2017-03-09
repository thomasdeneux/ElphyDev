unit ACMOut;

{Version modifiée pour quelques essais}

{-----------------------------------------------------------------------------
The contents of this file are subject to the Mozilla Public License
Version 1.1 (the "License"); you may not use this file except in compliance
with the License. You may obtain a copy of the License at
http://www.mozilla.org/MPL/MPL-1.1.html

Software distributed under the License is distributed on an "AS IS" basis,
WITHOUT WARRANTY OF ANY KIND, either expressed or implied. See the License for
the specific language governing rights and limitations under the License.

The Original Code is: ACMOut.pas, released August 28, 2000.

The Initial Developer of the Original Code is Peter Morris (pete@stuckindoors.com),
Portions created by Peter Morris are Copyright (C) 2000 Peter Morris.
All Rights Reserved.

Purpose of file:
Allows you to open an audio-output stream, in almost any format

Contributor(s):
None as yet


Last Modified: September 14, 2000
Current Version: 1.00

You may retrieve the latest version of this file at http://www.stuckindoors.com/dib

Known Issues:
TrueSpeech doesn't work for some reason.
-----------------------------------------------------------------------------}

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  MMSystem;

type
  EACMOut = class(Exception);
  TBufferPlayedEvent = procedure(Sender : TObject; Header : PWaveHDR) of object;
  TACMOut = class(TComponent)
  private
    { Private declarations }
    FActive                   : Boolean;
    FNumBuffersLeft           : Byte;
    FBackBufferList           : TList;
    FNumBuffers               : Byte;
    FBufferList               : TList;
    FFormat                   : TWaveFormatEx;
    FOnBufferPlayed           : TBufferPlayedEvent;
    FWaveOutHandle            : HWaveOut;
    FWindowHandle             : HWnd;
    function GetBufferCount: Integer;
  protected
    { Protected declarations }
    function  NewHeader : PWaveHDR;
    procedure DisposeHeader(Header : PWaveHDR);
    procedure DoWaveDone(Header : PWaveHdr);
    procedure WndProc(var Message : TMessage);
  public
    { Public declarations }
    constructor Create(AOwner : TComponent); override;
    destructor Destroy; override;

    procedure Close;
    procedure Open(aFormat : TWaveFormatEx);
    procedure Play(var Buffer; Size : Integer);
    procedure RaiseException(const aMessage : String; Result : Integer);

    property Active           : Boolean
      read FActive;
    property BufferCount      : Integer
      read GetBufferCount;
    property Format           : TWaveFormatEx
      read FFormat;
    property WindowHandle     : HWnd
      read FWindowHandle;

  published
    { Published declarations }
    property NumBuffers      : Byte
      read FNumBuffers
      write FNumBuffers;
    property OnBufferPlayed   : TBufferPlayedEvent
      read FOnBufferPlayed
      write FOnBufferPlayed;
  end;

procedure Register;

implementation

procedure Register;
begin
  RegisterComponents('Sound', [TACMOut]);
end;

{ TACMOut }

procedure TACMOut.Close;
var
  X                           : Integer;
begin
  if not Active then exit;
  FActive := False;
  WaveOutReset(FWaveOutHandle);
  WaveOutClose(FWaveOutHandle);
  FBackBufferList.Clear;
  FWaveOutHandle := 0;
  For X:=FBufferList.Count-1 downto 0 do DisposeHeader(PWaveHDR(FBufferList[X]));
end;

constructor TACMOut.Create(AOwner: TComponent);
begin
  inherited;
  FBufferList := TList.Create;
  FBackBufferList := TList.Create;
  FActive := False;
  FWindowHandle := AllocateHWND(WndProc);
  FWaveOutHandle := 0;
  FNumBuffers := 4;

end;

destructor TACMOut.Destroy;
begin
  if Active then Close;
  FBufferList.Free;
  DeAllocateHWND(FWindowHandle);
  FBackBufferList.Free;
  inherited;
end;

procedure TACMOut.DisposeHeader(Header: PWaveHDR);
var
  X                           : Integer;
begin
  X := FBufferList.IndexOf(Header);
  if X < 0 then exit;
  Freemem(header.lpData);
  Freemem(header);
  FBufferList.Delete(X);
end;

procedure TACMOut.DoWaveDone(Header : PWaveHdr);
var
  Res                         : Integer;
begin
  if not Active then exit;
  if Assigned(FOnBufferPlayed) then FOnBufferPlayed(Self, Header);
  Res := WaveOutUnPrepareHeader(FWaveOutHandle, Header, SizeOf(TWaveHDR));
  if Res <> 0 then RaiseException('WaveOut-UnprepareHeader',Res);
  DisposeHeader(Header);
end;

function TACMOut.GetBufferCount: Integer;
begin
  Result := FBufferList.Count;
end;

function TACMOut.NewHeader: PWaveHDR;
begin
  GetMem(Result, SizeOf(TWaveHDR));
  FBufferList.Add(Result);
end;

procedure TACMOut.Open(aFormat: TWaveFormatEx);
var
  Res                         : Integer;
  Device                      : Integer;
  Params                      : Integer;
begin
  if Active then exit;
  FWaveOutHandle := 0;
  FNumBuffersLeft := FNumBuffers;
  FFormat := aFormat;

  if FFormat.wFormatTag = 1 then begin
    Params := CALLBACK_WINDOW;
    Device := -1;
  end else begin
    Params := CALLBACK_WINDOW or WAVE_MAPPED;
    Device := 0;
  end;
  Res := WaveOutOpen(@FWaveOutHandle,Device,@FFormat,FWindowHandle,0, params);
  if Res <> 0 then RaiseException('WaveOutOpen',Res);
  FActive := True;
end;

procedure TACMOut.Play(var Buffer; Size: Integer);
var
  TempHeader                  : PWaveHdr;
  Data                        : Pointer;
  Res                         : Integer;
  X                           : Integer;

  procedure PlayHeader(Header : PWaveHDR);
  begin
    Res := WaveOutPrepareHeader(FWaveOutHandle,Header,SizeOf(TWaveHDR));
    if Res <> 0 then RaiseException('WaveOut-PrepareHeader',Res);

    Res := WaveOutWrite(FWaveOutHandle, Header, SizeOf(TWaveHDR));
    if Res <> 0 then RaiseException('WaveOut-Write',Res);
  end;

begin
  if Size = 0 then exit;
  if not active then exit;
  TempHeader := NewHeader;
  GetMem(Data, Size);
  Move(Buffer,Data^,Size);
  with TempHeader^ do begin
    lpData := Data;
    dwBufferLength := Size;
    dwBytesRecorded :=0; //Was " := Size;" but not needed, and crashes some PC's
    dwUser := 0;
    dwFlags := 0;
    dwLoops := 1;
  end;

  if FNumBuffersLeft > 0 then begin
    FBackBufferList.Add(TempHeader);
    Dec(FNumBuffersLeft);
  end else begin
    for X:=0 to FBackBufferList.Count-1 do
      PlayHeader(PWaveHDR(FBackBufferList[X]));
    FBackBufferList.Clear;
    PlayHeader(TempHeader);
  end;
end;

procedure TACMOut.RaiseException(const aMessage: String; Result: Integer);
begin

end;

procedure TACMOut.WndProc(var Message: TMessage);
begin
  case Message.Msg of
    MM_WOM_DONE : DoWaveDone(PWaveHDR(Message.LParam));
  end;
end;

end.
