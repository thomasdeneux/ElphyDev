unit PipeUnit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs,
  util1,Dgraphic, StdCtrls;

Const
  BUFSIZE=4096;
type
 TserverThread=
            class(Tthread)
              memoOut:Tmemo;
              hPipe:Thandle;
              chRequest,chReply: array[0..BUFSIZE-1] of byte;

              constructor create(createSuspended:boolean;hpipe1:THandle;memo1:Tmemo);
              procedure execute;override;
            end;


type
  TForm1 = class(TForm)
    Memo1: TMemo;
    Button1: TButton;
    procedure Button1Click(Sender: TObject);
  private
    thread:TServerThread;

    { Déclarations privées }
    procedure MessageServer(var message:Tmessage);message WM_USER;
  public
    { Déclarations publiques }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}



procedure TForm1.MessageServer(var message: Tmessage);
var
  fConnected: BOOL;
  hPipe: THandle;
Const
  lpszPipename:string = '\\.\pipe\mynamedpipe';
  BUFSIZE=4096;

begin
  hPipe := CreateNamedPipe(
      PAnsichar(lpszPipename),   // pipe name
      PIPE_ACCESS_DUPLEX,       // read/write access
      PIPE_TYPE_MESSAGE or      // message type pipe
      PIPE_READMODE_MESSAGE or  // message-read mode
      PIPE_WAIT,                // blocking mode
      PIPE_UNLIMITED_INSTANCES, // max. instances
      BUFSIZE,                  // output buffer size

      BUFSIZE,                  // input buffer size
      1000000,                  // client time-out
      Nil);                     // no security attribute

  if (hPipe = INVALID_HANDLE_VALUE)
      then MessageCentral('Error CreatePipe');

  fConnected := ConnectNamedPipe(hPipe, nil);

  if fConnected then
  begin
    memo1.lines.add('Connection is OK');
    thread:=TserverThread.Create(false,hpipe,memo1);
  end
  else
  begin
    memo1.lines.add('Error = '+getLastErrorString);
    CloseHandle(hPipe);
  end;

  memo1.lines.add('After closeHandle');
end;


{ TserverThread }

constructor TserverThread.create(createSuspended:boolean;hpipe1:THandle;memo1:Tmemo);
begin
  hPipe:=hPipe1;
  memoOut:=memo1;
  inherited create(createSuspended);
end;

procedure TserverThread.execute;
var
  fsuccess:boolean;
  cbBytesRead,cbWritten:cardinal;
  tot:integer;
  st:string[19];
begin
  tot:=0;
  repeat

    fSuccess := ReadFile(
         hPipe,        // handle to pipe
         chRequest,    // buffer to receive data
         20,           // number of bytes TO read
         cbBytesRead, // number of bytes read
         Nil);        // not overlapped I/O
    if not fSuccess or (cbBytesRead = 0) then terminate;

    tot:=tot+cbBytesRead;
    if tot>=5 then
    begin
      move(chRequest,st,20);
      memoOut.lines.add(st);
    end;

    st:='MERCI';
    move(st,chReply,20);
    fSuccess := WriteFile(
         hPipe,        // handle to pipe
         chReply,      // buffer to write from
         20,           // number of bytes to write
         cbWritten,    // number of bytes written
         Nil);         // not overlapped I/O
    if not fSuccess or (cbWritten<>20) then terminate;

  until terminated ;


  FlushFileBuffers(hPipe);
  DisconnectNamedPipe(hPipe);
  CloseHandle(hPipe);
end;



procedure TForm1.Button1Click(Sender: TObject);
begin
   PostMessage(handle,WM_USER,0,0);
end;

end.
