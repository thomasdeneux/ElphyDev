unit SerialCom1;

interface
uses windows,
     util1, QueryString1,stmObj,Ncdef2,stmPg;

type
  TserialCom= class
              private
                hSerial: Thandle;
                error: integer;
              public
                constructor create(num: integer);
                procedure setParams(BaudRate, ByteSize,StopBits,Parity: integer);
                procedure SetTimeOuts( ReadI, ReadC, ReadM, writeC,writeM:integer);

                function ReadAnsiString(sep:AnsiChar): AnsiString;
                procedure WriteAnsiString(st:AnsiString);
                destructor destroy;override;
              end;

  TserialComUO =
              class(typeUO)
              private
                sc: TserialCom;
              public
                constructor create;override;
                procedure init(num:integer);
                destructor destroy;override;
              end;

procedure mavoTest;

procedure proTserialCom_create(num: integer;var pu: typeUO);pascal;
procedure proTserialCom_setParams(BaudRate, ByteSize,StopBits,Parity: integer;var pu: typeUO);pascal;
procedure proTserialCom_SetTimeOuts( ReadI, ReadC, ReadM, writeC,writeM:integer;var pu: typeUO);pascal;

function fonctionTserialCom_ReadString(sep:AnsiChar;var pu: typeUO): AnsiString;pascal;
procedure proTserialCom_WriteString(st:AnsiString;var pu: typeUO);pascal;


implementation

{ TserialCom }

constructor TserialCom.create(num: integer);
var
  st: String;
begin
  st:='COM'+Istr(num);
  hSerial := CreateFile(PChar(st),GENERIC_READ or GENERIC_WRITE, 0, 0, OPEN_EXISTING, FILE_ATTRIBUTE_NORMAL, 0);
  if (hSerial=INVALID_HANDLE_VALUE) then
  begin
   if (GetLastError =ERROR_FILE_NOT_FOUND) //serial port does not exist.
     then error:=1
     else error:=2;
  end;
end;

destructor TserialCom.destroy;
begin
  CloseHandle(hSerial);
  inherited;
end;

function TserialCom.ReadAnsiString(sep: AnsiChar): AnsiString;
var
  ok: boolean;
  ch:AnsiChar;
  nbRead: longword;
begin
  error:=0;
  result:='';
  repeat
    ok:=readFile(hSerial, ch,1,nbRead,nil);
    if ok and (nbread>0) then
    begin
      if ch=#10 //
        then exit
        else result:=result+ch;
    end
    else
    begin
      error:=10;
      ok:=false;
    end;
  until not ok;
end;

procedure TserialCom.setParams(BaudRate, ByteSize,StopBits,Parity: integer);
var
  dcb: TDCB;
  st: string;
  ok: boolean;
begin
  error:=0;
  fillchar( dcb,sizeof(dcb),0);
  dcb.DCBlength:=sizeof(dcb);

  ok:=GetCommState(hSerial, dcb);                     // Donne false
  if not ok then ok:= (getLastError=0);               // alors que getLastError=0 !!!
  if ok then
  begin
    dcb.BaudRate:= BaudRate;
    dcb.ByteSize:= ByteSize;
    dcb.StopBits:= StopBits;
    dcb.Parity:= Parity ;

    if not SetCommState(hSerial, dcb) then error:=3;
  end
  else error:=3;
end;

procedure TserialCom.SetTimeOuts( ReadI, ReadC, ReadM, writeC,writeM:integer);
var
  timeouts: TCOMMTIMEOUTS;
begin
  error:=0;
  fillchar(timeOuts, sizeof(TimeOuts),0);
  timeouts.ReadIntervalTimeout:=        ReadI;
  timeouts.ReadTotalTimeoutConstant:=   ReadC;
  timeouts.ReadTotalTimeoutMultiplier:= ReadM;

  timeouts.WriteTotalTimeoutConstant:=  WriteC;
  timeouts.WriteTotalTimeoutMultiplier:=WriteM;

  if not SetCommTimeouts(hSerial, timeouts) then error:=4;
end;



procedure TserialCom.WriteAnsiString(st: Ansistring);
var
  nbWritten: longword;
begin
  error:=0;
  if not writeFile(hserial,st[1],length(st),nbWritten,nil) or (nbWritten<>length(st)) then error:=20;
//  messageCentral('nbWritten='+Istr(nbWritten));
end;


procedure mavoTest;
var
  serialPort: TserialCom;
  st,stS:AnsiString;
begin
  serialPort:=TserialCom.create(3);

  with serialPort do
  begin
    setParams(9600,7,2,EvenParity);
    setTimeOuts(500,500,500,500,500);
    stS:='VER?';
    repeat
      stS:= GetAString(stS);
      if stS<>'' then
      begin
        error:=0;
        writeAnsiString(stS+#10);
        if error=0 then
        begin
          st:=ReadAnsiString(#10);
          if error=0
            then messageCentral(st)
            else messageCentral('error= '+Istr(error));
        end;
      end;
    until stS='';
    free;
  end;
end;


{ TserialComUO }

constructor TserialComUO.create;
begin
  inherited;
end;

destructor TserialComUO.destroy;
begin
  sc.Free;
  inherited;
end;

procedure TserialComUO.init(num:integer);
begin
  sc:=TserialCom.create(num);
end;

{ STM }

procedure proTserialCom_create(num:integer;var pu: typeUO);
begin
  createPgObject('',pu,TserialComUO);
  with TserialcomUO(pu) do
  begin
    init(num);
    if error<>0 then sortieErreur('TserialCom.create : unable to open channel');
  end;
end;

procedure proTserialCom_setParams(BaudRate, ByteSize,StopBits,Parity: integer;var pu: typeUO);
begin
  verifierObjet(pu);
  with TserialcomUO(pu) do
  begin
    sc.setParams(BaudRate, ByteSize,StopBits,Parity);
    if error<>0 then sortieErreur('TserialCom.setParams : unable to set parameters');
  end;
end;

procedure proTserialCom_SetTimeOuts( ReadI, ReadC, ReadM, writeC,writeM:integer;var pu: typeUO);
begin
  verifierObjet(pu);
  with TserialcomUO(pu) do
  begin
    sc.setTimeOuts(ReadI, ReadC, ReadM, writeC,writeM);
    if error<>0 then sortieErreur('TserialCom.setTimeOuts : unable to set timeOuts');
  end;
end;

function fonctionTserialCom_ReadString(sep:AnsiChar;var pu: typeUO): AnsiString;
begin
  verifierObjet(pu);
  with TserialcomUO(pu) do
  begin
    result:=sc.ReadAnsiString(sep);
    if error<>0 then sortieErreur('TserialCom.ReadString error');
  end;
end;

procedure proTserialCom_WriteString(st:Ansistring;var pu: typeUO);
begin
  verifierObjet(pu);
  with TserialcomUO(pu) do
  begin
    sc.WriteAnsiString(st);
    if error<>0 then sortieErreur('TserialCom.WriteString error');
  end;
end;



end.
