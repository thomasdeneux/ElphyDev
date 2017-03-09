unit ClientPipe1;

interface

uses Windows, Messages,
     util1;

procedure SendToPipe;

implementation


procedure SendToPipe;
var
   fSuccess:BOOL;
   cbRead, cbWritten, dwMode:Dword;
   st:string[19];
   ok:boolean;
const
   lpszPipename:string = '\\.\pipe\mynamedpipe';

   hPipe:Thandle=0;
   Connected:boolean=false;
begin
  if not connected then
  begin
    ok:=false;
    while not ok do
    begin
      hPipe := CreateFile(
           PansiChar(lpszPipename),   // pipe name
           GENERIC_READ or // read and write access
           GENERIC_WRITE,
           0,              // no sharing
           Nil,            // no security attributes
           OPEN_EXISTING,  // opens existing pipe
           0,              // default attributes
           0);          // no template file


      ok:= (hPipe <> INVALID_HANDLE_VALUE);

      if not ok then
      begin
        if not WaitNamedPipe(PansiChar(lpszPipename), 20000) then
        begin
          messageCentral('Could not open pipe');
          exit;
        end;
      end;
    end;

     dwMode := PIPE_READMODE_MESSAGE;
     fSuccess := SetNamedPipeHandleState(
        hPipe,    // pipe handle
        dwMode,  // new pipe mode
        Nil,     // don't set max. bytes
        Nil);    // don't set max. time
     if not fSuccess then
     begin
       MessageCentral('SetNamedPipeHandleState');
       exit;
     end;
  end;

  connected:=true;

  st:='COUCOU';

  fSuccess := WriteFile(
      hPipe,                  // pipe handle
      st,                     // message
      20,                     // message length
      cbWritten,              // bytes written
      Nil);                  // not overlapped
  if not fSuccess then
  begin
    MessageCentral('WriteFile error');
    exit;
  end;


  fSuccess := ReadFile(
         hPipe,    // pipe handle
         st,       // buffer to receive reply
         20,      // size of buffer
         cbRead,  // number of bytes read
         Nil);    // not overlapped

  if not fSuccess and (GetLastError<> ERROR_MORE_DATA) then exit;

  messageCentral('Reçu   '+st);


 //  CloseHandle(hPipe);

end;

end.
