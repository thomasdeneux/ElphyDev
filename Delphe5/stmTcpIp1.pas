unit stmTcpIp1;

interface

{  NOTELPHY doit être défini par une application extérieure à Elphy
   Il permet d'exclure toute référence à typeUO, l'objet TserverA et les méthodes Stm .
}

uses windows,classes,sysutils,Dialogs,extCtrls,forms,mmsystem,
     IdGlobal, IdIOHandler,IdTCPServer, IdTCPclient, IdSocketHandle, IdContext, IdStack, IdStreamVcl, IdAntiFreeze,
     util1
     {$IFNDEF NOTELPHY} ,stmdef,stmObj,stmDobj1, stmPG, NcDef2  {$ENDIF}
     ;


Const
   DefaultServerIP = '127.0.0.1';
   DefaultServerPort = 50190;

var
  idAntiFreeze1:TidAntiFreeze;
  {$IFDEF NOTELPHY}
  formStm:Tform;
  {$ENDIF}
                                            
Const
  Sys_Command='Sys_Command';
  Sys_NONE='NONE';

  Sys_Reset =     1;
  Sys_PgExec =    2;
  Sys_PgInstall = 3;
  Sys_LoadConfig =4;
  Sys_Quit =      5;

Const
  NS_Command='NS_Command';
  NS_Query = 'NS_Query';

  Kns_GetLibraryInfo =     101;
  Kns_OpenFile       =     102;
  Kns_GetFileInfo    =     103;
  Kns_CloseFile      =     104;
  Kns_GetEntityInfo  =     105;
  Kns_GetEventInfo   =     106;
  Kns_GetEventData   =     107;
  Kns_GetAnalogInfo  =     108;
  Kns_GetAnalogData  =     109;
  Kns_GetSegmentInfo =     110;
  Kns_GetSegSourceInfo=    111;
  Kns_GetSegmentData =     112;
  Kns_GetNeuralInfo  =     113;
  Kns_GetNeuralData  =     114;
  Kns_GetIndexByTime =     115;
  Kns_GetTimeByIndex =     116;
  Kns_GetLastErrorMsg=     117;


var
  TestMode:boolean;
  MaxTestMode: integer;

type
  TbufferInfo=record
                id:string[20];
                idNum:integer;
                flagQuery:boolean;
              end;


  Tbuffer=class
          private
            buf:TmemoryStream; { Buf existe toujours et contient une structure TbufferInfo}
            FrawBuffer: boolean;

            function getDataSize:integer;
            procedure setDataSize(n:integer);

            function getDataPosition:integer;
            procedure setDataPosition(n:integer);

            function getIdent:AnsiString;
            procedure setIdent(st:AnsiString);

            function getIdNum:integer;
            procedure setIdNum(n:integer);

            function getIsQuery:boolean;
            procedure setIsQuery(w:boolean);

            procedure writeInfo(var info:TbufferInfo);
            procedure readInfo(var info:TbufferInfo);

            function InfoSize:integer;

          public
            constructor create(FRaw: boolean);
            destructor destroy;override;
            property DataSize:integer read getDataSize write setDataSize;
            property DataPosition:integer read getDataPosition write setDataPosition;

            property ident:AnsiString read getIdent write setIdent;
            property idNum:integer read getIdNum write setIdNum;
            property IsQuery:boolean read getIsQuery write setIsQuery;

            procedure Clear;
            procedure ResetIndex;
            procedure init(stIdent:AnsiString;num:integer;query:boolean);

            procedure read(var x;nb:integer; const swap:boolean=false);
            procedure write(var x;nb:integer);
            procedure ReadAndSkip(var x;varSize,nb:integer);

            procedure readInt(var x:integer);
            procedure writeInt(x:integer);

            function readShortString:AnsiString;
            procedure writeShortString(st:AnsiString);

            function readString:AnsiString;
            procedure writeString(st:AnsiString);

            {$IFNDEF NOTELPHY}
            procedure readObject(uo:TypeUO);
            procedure writeObject(uo:TypeUO);
            {$ENDIF}
            procedure send(IOhandler:TidIOhandler);
            procedure receive(IOhandler:TidIOhandler);
          end;

  {$IFNDEF NOTELPHY}
  TonReceive= procedure (buf: Tbuffer) of object;
  TserverA=class (typeUO)
           private
             idServer:TidTCPserver;

             ClientContext: TIdContext;   { un seul client, du moins en mode texte }
             Connected:boolean;
             TextMode:boolean;

             InBuffers:TThreadList;
             OutBuffers:TThreadList;

             currentBuffer:Tbuffer;
             FoutputBuffer:Tbuffer;
             {$IFNDEF NOTELPHY}
             OnReceivePG2:Tpg2event;
             {$ENDIF}


             FrawBuffer: boolean;    { Les buffers ne contiennent pas de header }

             procedure idServerConnect(AContext:TIdContext);
             procedure idServerExecute(AContext:TIdContext);
             procedure idServerDisconnect(AContext:TIdContext);


           public
             IP0:AnsiString;
             port0:integer;
             Active0:boolean;
             OnReceive: TonReceive;
             Fprivate: boolean; // si true, on n'envoie pas de message au thread principal
             TotBufSize: integer;
             MaxTotBufSize:integer;

             constructor create;{$IFNDEF NOTELPHY}override;{$ENDIF}
             destructor destroy;override;

             procedure setup(serverIP:AnsiString;ServerPort:integer;active:boolean; mode:integer);

             function BufferCount:integer;
             function getBuffer:Tbuffer;
             procedure nextBuffer;

             property outputBuffer:Tbuffer read FoutputBuffer;
             procedure putBuffer;

             procedure ProcessBuffer(sender:Tobject);virtual;
             function receiveString:AnsiString;
             procedure sendString(st:AnsiString);
           end;

  {$ENDIF}
  TclientA=class  {$IFNDEF NOTELPHY}(typeUO) {$ENDIF}
           private
             idClient:TidTCPclient;

           public
             IP0:AnsiString;
             port0:integer;
             Active0:boolean;

             currentBuffer:Tbuffer;
             constructor create; {$IFNDEF NOTELPHY}override;{$ENDIF}
             destructor destroy;override;

             function setup(serverIP:AnsiString;ServerPort:integer;
                            Const connectTO: integer=10000; Const readTO: integer=10000): boolean;
             procedure sendBuffer;

             function receiveString:AnsiString;
             function receiveString512:AnsiString;

             procedure sendString(st:AnsiString);
           end;


 {$IFNDEF NOTELPHY}
procedure proTbuffer_ident(st:AnsiString; pu:Tbuffer); pascal;
function fonctionTbuffer_ident(pu: Tbuffer):AnsiString; pascal;

procedure proTbuffer_isQuery(w:boolean; pu:Tbuffer); pascal;
function fonctionTbuffer_isQuery(pu: Tbuffer):boolean; pascal;


procedure proTbuffer_clear(pu: Tbuffer);pascal;

procedure proTbuffer_ReadObject(var uo:typeUO; pu: Tbuffer); pascal;
procedure proTbuffer_writeObject(var uo:typeUO; pu: Tbuffer); pascal;

procedure proTbuffer_ReadString(var st:AnsiString; pu: Tbuffer);pascal;
procedure proTbuffer_ReadString_1(var st:PgString;sz:integer; pu: Tbuffer);pascal;

procedure proTbuffer_writeString(st:AnsiString; pu: Tbuffer);pascal;

function fonctionTbuffer_size(pu: Tbuffer): integer;pascal;

function fonctionTbuffer_position(pu: Tbuffer): integer;pascal;
procedure proTbuffer_position(w: integer; pu: Tbuffer);pascal;


procedure proTbuffer_Read(var x;size:integer;tpn:word; pu: Tbuffer);pascal;
procedure proTbuffer_write(var x;size:integer;tpn:word; pu: Tbuffer);pascal;



procedure proTserverA_create(myIP:AnsiString; port:integer; var pu:typeUO);pascal;
procedure proTserverA_create_1(myIP:AnsiString; port:integer; Mode:integer; var pu:typeUO);pascal;

procedure proTserverA_Active(w:boolean;var pu:typeUO); pascal;
function fonctionTserverA_Active(var pu: TypeUO):boolean; pascal;

procedure proTserverA_OnReceive(p:integer;var pu:typeUO);pascal;
function fonctionTserverA_OnReceive(var pu:typeUO):integer;pascal;

function fonctionTserverA_OutBuffer(var pu:typeUO):Tbuffer;pascal;
procedure proTserverA_sendBuffer(var pu:typeUO);pascal;

procedure proTserverA_SendString(st:AnsiString;var pu:typeUO);pascal;
procedure proTserverA_SendString512(st:AnsiString;bb:byte;var pu:typeUO);pascal;
function fonctionTserverA_ReceiveString(var pu:typeUO):AnsiString;pascal;

procedure proTserverA_SetTestMode(mode:boolean; nb:integer;var pu:typeUO);pascal;

function fonctionTclientA_create(serverIP:AnsiString; port:integer; Active:boolean; var pu:typeUO): boolean;pascal;
function fonctionTclientA_create_1(serverIP:AnsiString; port:integer;ConnectTO: integer;  var pu:typeUO): boolean;pascal;
function fonctionTclientA_create_2(serverIP:AnsiString; port:integer;ConnectTO,readTO: integer;  var pu:typeUO): boolean;pascal;

function fonctionTclientA_OutBuffer(var pu:typeUO):Tbuffer;pascal;
procedure proTclientA_sendBuffer(var pu:typeUO);pascal;

procedure proTclientA_sendElphyCommand(stCom,stParam:AnsiString;var pu:typeUO);pascal;

procedure proTclientA_SendString(st:AnsiString;var pu:typeUO);pascal;
procedure proTclientA_SendString512(st:AnsiString;bb:byte;var pu:typeUO);pascal;
function fonctionTclientA_ReceiveString(var pu:typeUO):AnsiString;pascal;
function fonctionTclientA_ReceiveString512(var pu:typeUO):AnsiString;pascal;


procedure proTclientA_SetRawBuffer(w:boolean;var pu:typeUO);pascal;
{$ENDIF}

implementation

{ Tbuffer }

function Tbuffer.getDataSize: integer;
begin
  result:=buf.size-InfoSize;
  if result<0 then result:=0;
end;

procedure Tbuffer.setDataSize(n: integer);
begin
  buf.Size:=n+ InfoSize;
end;

function Tbuffer.getDataPosition: integer;
begin
  result:=buf.position-InfoSize;
  if result<0 then result:=0;
end;

procedure Tbuffer.setDataPosition(n: integer);
begin
  if n<0 then n:=0;
  n:= n+ InfoSize;
  if n>buf.Size then n:=buf.size;
  buf.Position:=n;
end;


procedure Tbuffer.read(var x; nb: integer; const swap:boolean=false);
begin
  buf.ReadBuffer(x,nb);
end;

procedure Tbuffer.ReadAndSkip(var x;varSize,nb:integer);
var
  p:int64;
begin
  p:=buf.position;
  if varSize<=nb
    then buf.ReadBuffer(x,varSize)
    else buf.ReadBuffer(x,nb);
  buf.Position:=p+nb

end;

procedure Tbuffer.write(var x; nb: integer);
begin
  buf.WriteBuffer(x,nb);
end;

procedure Tbuffer.readInt(var x:integer);
begin
  buf.Read(x,4)
end;

procedure Tbuffer.writeInt(x:integer);
begin
  buf.write(x,4);
end;

function Tbuffer.readShortString:AnsiString;
var
  nb:byte;
begin
  buf.ReadBuffer(nb,1);
  setlength(result,nb);
  buf.ReadBuffer(result[1],nb);
end;

procedure Tbuffer.writeShortString(st: AnsiString);
var
  n:byte;
begin
  if length(st)<255
    then n:=length(st)
    else n:=255;
  buf.WriteBuffer(n,1);
  buf.writeBuffer(st[1],n);
end;

function Tbuffer.readString:AnsiString;
var
  n:integer;
begin
  buf.ReadBuffer(n,sizeof(n));
  setlength(result,n);
  buf.ReadBuffer(result[1],n);
end;

procedure Tbuffer.writeString(st:AnsiString);
var
  n:integer;
begin
  n:=length(st);
  buf.WriteBuffer(n,sizeof(n));
  if n>0 then buf.WriteBuffer(st[1],n);
end;


{$IFNDEF NOTELPHY}
procedure Tbuffer.readObject(uo: TypeUO);
var
  st1:AnsiString;
  size:LongWord;

  oldIdent:AnsiString;
  oldFchild:boolean;
  OldNotPub:boolean;
  OldReadOnly:boolean;
begin
  if not assigned(uo)  or uo.ReadOnly then exit;

  oldIdent:=uo.ident;
  oldFchild:=uo.Fchild;
  oldNotPub:=uo.NotPublished;
  OldReadOnly:=uo.readOnly;

  st1:=readHeader(buf,size);
  if st1=uo.stmClassName
    then uo.loadFromStream(buf,size,true);

  uo.Ident:=OldIdent;
  uo.Fchild:=oldFchild;
  uo.NotPublished:=OldNotPub;
  uo.ReadOnly:=OldReadOnly;

  uo.clearReferences;
  uo.resetMyAd;
  uo.setChildNames;
end;


procedure Tbuffer.writeObject(uo: TypeUO);
begin
  uo.saveToStream0(buf,true);
end;

{$ENDIF}

{ Initialise buf et place l'indice sur les premières données }
procedure Tbuffer.ResetIndex;
var
  info:TbufferInfo;
begin
  if FrawBuffer then buf.Position:=0
  else
  if buf.size<sizeof(TbufferInfo) then   // Si buf est vide, on crée BufferInfo
  begin
    buf.clear;
    fillchar(info,sizeof(info),0);
    buf.WriteBuffer(info,sizeof(info));
  end
  else buf.Position:=sizeof(info);       // sinon, on se place au début
end;


constructor Tbuffer.create(Fraw: boolean);
begin
  buf:=TmemoryStream.create;
  FrawBuffer:=Fraw;
  resetIndex;
end;

procedure Tbuffer.clear;
begin
  buf.clear;
  resetIndex;
end;


destructor Tbuffer.destroy;
begin
  buf.free;
  inherited;
end;

function Tbuffer.getIdent: AnsiString;
var
  info:TbufferInfo;
begin
  if FrawBuffer then result:=''
  else
  begin
    readInfo(info);
    result:=info.id;
  end;
end;

procedure Tbuffer.setIdent(st: AnsiString);
var
  info:TbufferInfo;
begin
  if not FrawBuffer then
  begin
    readInfo(info);
    info.id:=st;
    writeInfo(Info);
  end;
end;

function Tbuffer.getIdNum: integer;
var
  info:TbufferInfo;
begin
  if FrawBuffer then result:=0
  else
  begin
    readInfo(info);
    result:=info.idNum;
  end;
end;


procedure Tbuffer.setIdNum(n: integer);
var
  info:TbufferInfo;
begin
  if not FrawBuffer then
  begin
    readInfo(info);
    info.idNum:=n;
    writeInfo(Info);
  end;
end;



function Tbuffer.getIsQuery:boolean;
var
  info:TbufferInfo;
begin
  if FrawBuffer then result:=false
  else
  begin
    readInfo(info);
    result:=info.flagQuery;
  end;
end;

procedure Tbuffer.setIsQuery(w:boolean);
var
  info:TbufferInfo;
begin
  if not FrawBuffer then
  begin
    readInfo(info);
    info.flagQuery:=w;
    writeInfo(info);
  end;
end;

procedure Tbuffer.init(stIdent: AnsiString; num: integer; query: boolean);
var
  info:TbufferInfo;
begin
  if not FrawBuffer then
  begin
    info.id:=stIdent;
    info.idNum:=num;
    info.flagQuery:=query;

    buf.Clear;
    buf.Write(info,sizeof(info));
  end;
end;



procedure Tbuffer.send(IOhandler: TidIOhandler);
begin

  IOHandler.Write(buf.Size,false);
  IOHandler.WriteBufferOpen;
  IOhandler.Write(buf);
  IOhandler.WriteBufferClose;

end;


procedure Tbuffer.receive(IOhandler: TidIOhandler);
var
  size:integer;
begin
  size:=IOHandler.readInt64(false);
  if size>0 then
  begin
    buf.Clear;

    IOhandler.ReadStream(buf,Size);

  end
  else clear;

  resetIndex;
end;

procedure Tbuffer.readInfo(var info:TbufferInfo);
var
  old:integer;
begin
  if FrawBuffer then fillchar(info,sizeof(info),0)
  else
  begin
    old:=buf.Position;
    buf.Position:=0;
    buf.ReadBuffer(info,sizeof(info));
    buf.Position:=old;
  end;
end;

procedure Tbuffer.writeInfo(var info:TbufferInfo);
var
  old:integer;
begin
  if not FrawBuffer then
  begin
    old:=buf.Position;
    buf.Position:=0;
    buf.writeBuffer(info,sizeof(info));
    buf.Position:=old;
  end;
end;


{ TserverA }


{$IFNDEF NOTELPHY}
constructor TserverA.create;
begin
  inherited;

  if not assigned(idAntiFreeze1)
    then idAntiFreeze1:=TidAntiFreeze.Create(formStm);

  idServer:=TidTCPserver.Create(formstm);
  with idServer do
  begin
    onConnect:=idServerConnect;
    onDisConnect:=idServerDisConnect;
    onExecute:=idServerExecute;
  end;

  idServer.TerminateWaitTime:=1;


  InBuffers:=TThreadList.create;
  OutBuffers:=TThreadList.create;

  MaxTotBufSize:=100000000;
end;

procedure TserverA.setup(serverIP:AnsiString;ServerPort:integer;active:boolean; mode:integer);
var
  Bindings: TIdSocketHandles;
begin
  if serverIP='' then serverIP:=DefaultServerIP;
  if serverPort=0 then serverPort:=DefaultServerPort;

  IP0:=serverIP;
  Port0:=ServerPort;
  Active0:=active;

  case mode of
    1: TextMode:=True;
    2: FrawBuffer:=true;
  end;
  FoutputBuffer:=Tbuffer.create(FrawBuffer);

  if active then
  begin
    Bindings := TIdSocketHandles.Create(idServer);
    try
      with Bindings.Add do
      begin
        IP := ServerIP;
        Port := ServerPort;
      end;
      try
        idServer.Bindings:=Bindings;
        idServer.Active:=Active;
      except on E:Exception do
        ShowMessage(E.Message);
      end;
    finally
      Bindings.Free;
    end;
  end;
end;

destructor TserverA.destroy;
var
  i:integer;
begin
  try
  with idServer do
  begin
    active:=false;
    onConnect:=nil;
    onDisConnect:=nil;
    onExecute:=nil;
  end;

  delay(1000);

  with InBuffers.LockList do
  for i:=0 to count-1 do
    Tbuffer(items[i]).Free;
  finally
  InBuffers.UnLockList
  end;

  InBuffers.Free;

  try
  with OutBuffers.LockList do
  for i:=0 to count-1 do
    Tbuffer(items[i]).Free;
  finally
  OutBuffers.UnLockList
  end;

  OutBuffers.Free;

  currentBuffer.Free;
  FoutputBuffer.free;

  idServer.free;
  inherited;
end;

function TserverA.BufferCount: integer;
begin
  try
  with InBuffers.LockList do
    result:=count;
  finally
    InBuffers.UnLockList;
  end;
end;

{ getBuffer renvoie le premier buffer de la liste s'il existe
  et enlève le buffer de la liste
}
function TserverA.getBuffer: Tbuffer;
begin
  try
  with InBuffers.LockList do
    if count>0 then
    begin
      result:=items[0];
      TotBufSize:=TotBufSize-Tbuffer(items[0]).DataSize;
      delete(0);
    end
    else result:=nil;
  finally
    InBuffers.UnLockList;
  end;
end;

procedure TserverA.nextBuffer;
begin
  freeAndNil(currentBuffer);
  currentBuffer:=getBuffer;
end;

procedure TserverA.putBuffer;
begin
  try
    OutBuffers.LockList.add(FoutputBuffer);
    FoutputBuffer:=Tbuffer.create(FrawBuffer);
  finally
    OutBuffers.UnLockList;
  end;
end;


procedure TserverA.idServerConnect(AContext: TIdContext);
begin
  if connected then exit;

  ClientContext:= AContext;
  Connected := true;
end;

procedure TserverA.idServerDisconnect(AContext: TIdContext);
begin
  connected:=false;
  ClientContext:=nil;
end;

procedure TserverA.idServerExecute(AContext: TIdContext);
var
  size:int64;
  buffer:Tbuffer;

  i:integer;
  st:AnsiString;
  bb:array[1..1000] of byte;
  tt: longword;

begin
  if not Acontext.Connection.Connected then exit;

  tt:=timeGetTime;

  if testMode then
  begin
    for i:=1 to MaxTestMode do bb[i]:= byte(Acontext.Connection.IOhandler.ReadChar);

    buffer:=Tbuffer.create(false);
    buffer.init('Test Mode',0,false);
    buffer.write(bb,MaxTestMode);

    try
      InBuffers.LockList.Add(buffer);   { on range le buffer dans la liste InBuffers }
    finally
      InBuffers.UnlockList;
    end;                                { et on informe le thread principal de l'arrivée d'un nouveau buffer }

    postMessage(formstm.Handle,msg_server,intG(self),0);
  end
  else
  if not TextMode then { Mode buffer }
  begin

    {lire la taille du buffer = int64}
    Size := Acontext.Connection.IOhandler.ReadInt64(false);

    if size>0 then
    begin
      buffer:=Tbuffer.create(FrawBuffer);
      buffer.buf.clear;

      {lire tout le buffer}
      Acontext.Connection.IOhandler.ReadStream(buffer.buf,Size);

      if not FrawBuffer and buffer.IsQuery then                { S'il s'agit d'une question }
      begin
        try
          st:=buffer.ident;                 { on regarde dans la liste outBuffers }
          buffer.Clear;                     { si la réponse est présente }
          buffer.ident:=sys_NONE;
          with OutBuffers.LockList do
          begin
            for i:=0 to count-1 do
            if Tbuffer(items[i]).ident=st then
            begin
              buffer.Free;                  { si oui, on l'envoie (buffer avec le nom original }
              buffer:=items[i];             { sinon, on renvoie un buffer vide appelé NONE }
              delete(i);
              break;
            end;
          end;
        finally
          OutBuffers.UnlockList;
        end;
        buffer.send(Acontext.Connection.IOhandler);
        buffer.Free;
      end
      else
      begin                                 { si ce n'est pas une question }
        try
          with InBuffers.LockList do
          begin
            // Pour les buffers photons, on ajoute le temps du PC
            if FrawBuffer then buffer.buf.Write(tt,sizeof(tt));

            Add(buffer);   { on range le buffer dans la liste InBuffers }
            TotBufSize:=TotBufSize+buffer.DataSize;
            while TotBufSize>MaxTotBufSize do
            begin
              TotBufSize:=TotBufSize-Tbuffer(items[0]).DataSize;
              delete(0);
            end;
          end;
        finally
          InBuffers.UnlockList;
        end;                                { et on informe le thread principal de l'arrivée d'un nouveau buffer }

        if not Fprivate then postMessage(formstm.Handle,msg_server,intG(self),0);
      end;
    end
    else
    begin
      buffer:=Tbuffer.create(FrawBuffer);
      buffer.init('Bad Size',0,false);
      buffer.write(size,8);
      try
        InBuffers.LockList.Add(buffer);   { on range le buffer dans la liste InBuffers }
      finally
        InBuffers.UnlockList;
      end;                                { et on informe le thread principal de l'arrivée d'un nouveau buffer }

      postMessage(formstm.Handle,msg_server,intG(self),0);

    end;
  end
  else
  begin     {mode Texte }
    st:=Acontext.Connection.IOhandler.Readln;
    buffer:=Tbuffer.create(false);             { on crée un buffer contenant la chaîne }
    buffer.ident:='_string';
    buffer.writeString(st);

    try
      InBuffers.LockList.Add(buffer);   { on range le buffer dans la liste InBuffers }
    finally
      InBuffers.UnlockList;
    end;
    postMessage(formstm.Handle,msg_server,intG(self),0);
  end;
end;


procedure TserverA.ProcessBuffer(sender: Tobject);
var
  buffer:Tbuffer;
begin
  repeat
    buffer:=getBuffer;
    if assigned(buffer) then
      try
      if OnReceivePG2.valid then
        with OnReceivePG2 do
           pg.executerOnServerEvent(ad,typeUO(buffer))
      else
      if assigned(OnReceive) then
        onReceive(buffer);
      finally
        buffer.free;
      end

    // S'il n'y a pas de gestionnaire, le buffer est détruit et perdu
  until not assigned(buffer);
end;



function TserverA.receiveString: AnsiString;
var
  buffer:Tbuffer;
begin
  repeat
    buffer:=getBuffer;
    if testEscape then break;
  until assigned(buffer);

  if assigned(buffer) then
  begin
    try
      buffer.ResetIndex;
      result:=buffer.readString;
    finally
      buffer.free;
    end;
  end
  else result:='';
end;


procedure TserverA.sendString(st: AnsiString);
begin
  if assigned(ClientContext)
    then ClientContext.Connection.IOhandler.WriteLn(st);
end;
{$ENDIF}



function Tbuffer.InfoSize: integer;
begin
  if FrawBuffer
    then result:= 0
    else result:= sizeof(TbufferInfo);
end;

{ TclientA }


constructor TclientA.create;
begin
  inherited;

  if not assigned(idAntiFreeze1)
    then idAntiFreeze1:=TidAntiFreeze.Create(formStm);

  idClient:=TidTCPclient.Create(formstm);
  with idclient do
  begin
    connectTimeOut:=10000;
    readTimeOut:=10000;
  end;


end;

function TClientA.setup(serverIP:AnsiString;ServerPort:integer;
                        Const connectTO: integer=10000; Const readTO: integer=10000): boolean;
begin
  if serverIP='' then serverIP:=DefaultServerIP;
  if serverPort=0 then serverPort:=DefaultServerPort;

  try
    idClient.Host := ServerIP;
    idClient.Port := ServerPort;
    idClient.connectTimeOut:= connectTO;
    idClient.ReadTimeOut:= ReadTO;

    idClient.Connect;
    result:=true;
  except
    result:=false;
  end;

  currentBuffer:=Tbuffer.create(false);
end;

destructor TClientA.destroy;
begin
  if idClient.Connected then idClient.Disconnect;
  idClient.free;

  currentBuffer.free;

  inherited;
end;



procedure TclientA.sendBuffer;
begin
  if assigned(currentBuffer) then
  begin
    currentBuffer.send(IdClient.IOHandler);
    if currentBuffer.IsQuery then currentBuffer.receive(IdClient.IOHandler);
  end;

end;

function TclientA.receiveString: AnsiString;
begin
  result:=IdClient.IOHandler.ReadLn;
end;

function TclientA.receiveString512: AnsiString;
var
  buf:TidBytes;
  i:integer;
begin
  setlength(buf,512);
  IdClient.IOHandler.ReadBytes(buf,512,false);

  result:='';
  for i:=0 to 511 do
    if (buf[i]=10) or (buf[i]=13) then break
    else result:=result+char(buf[i]);
end;


procedure TclientA.sendString(st: AnsiString);
begin
  IdClient.IOHandler.WriteLn(st);
end;


{$IFNDEF NOTELPHY}
{*********************************** Méthodes stm de Tbuffer **************************************}


procedure proTbuffer_ident(st:AnsiString; pu:Tbuffer);
begin
  pu.ident:=st;
end;

function fonctionTbuffer_ident(pu: Tbuffer):AnsiString;
begin
  result:=pu.ident;
end;

procedure proTbuffer_isQuery(w:boolean; pu:Tbuffer);
begin
  pu.IsQuery:=w;
end;

function fonctionTbuffer_isQuery(pu: Tbuffer):boolean;
begin
  result:=pu.IsQuery;
end;

procedure proTbuffer_clear(pu: Tbuffer);pascal;
begin
  pu.Clear;
end;

procedure proTbuffer_ResetIndex(pu: Tbuffer);
begin
  pu.ResetIndex;
end;

procedure proTbuffer_ReadObject(var uo:typeUO; pu: Tbuffer);
begin
  pu.readObject(uo);
end;

procedure proTbuffer_writeObject(var uo:typeUO; pu: Tbuffer);
begin
  pu.writeObject(uo);
end;

procedure proTbuffer_ReadString(var st:AnsiString; pu: Tbuffer);
begin
  st:=pu.readString;
end;

procedure proTbuffer_ReadString_1(var st:PgString;sz:integer; pu: Tbuffer);
var
  st1:shortString absolute st;
  st2:AnsiString;
begin
  st2:=pu.readShortString;
  st1:=copy(st2,1,sz-1);
end;

procedure proTbuffer_writeString(st:AnsiString; pu: Tbuffer);
begin
  pu.writeString(st);
end;

function fonctionTbuffer_size(pu: Tbuffer): integer;
begin
  result:=pu.DataSize;
end;

function fonctionTbuffer_position(pu: Tbuffer): integer;
begin
  result:=pu.DataPosition;
end;

procedure proTbuffer_position(w: integer; pu: Tbuffer);
begin
  pu.DataPosition:=w;
end;


procedure proTbuffer_write(var x;size:integer;tpn:word; pu: Tbuffer);
begin
  if pu.DataPosition<=pu.DataSize
    then pu.buf.write(x,size)
    else sortieErreur('Tbuffer.write : unable to write variable');
end;


procedure proTbuffer_Read(var x;size:integer;tpn:word; pu: Tbuffer);
begin
  if pu.DataPosition<=pu.DataSize -size
    then pu.buf.Read(x,size)
    else sortieErreur('Tbuffer.read : unable to read variable');


end;


{*********************************** Méthodes stm de TserverA **************************************}


procedure proTserverA_create(myIP:AnsiString; port:integer; var pu:typeUO);pascal;
begin
  createPgObject('',pu,TserverA);
  with TserverA(pu) do
  begin
    setup(myIP,port,true,0);
  end;
end;

procedure proTserverA_create_1(myIP:AnsiString; port:integer; Mode: integer; var pu:typeUO);
begin
  createPgObject('',pu,TserverA);
  with TserverA(pu) do
  begin
    setup(myIP,port,true,mode);
  end;
end;

procedure proTserverA_Active(w:boolean;var pu:typeUO);
begin
  verifierObjet(pu);
  with TserverA(pu) do
  begin
    active0:=w;
    setup(IP0,port0,active0,ord(FrawBuffer)*2+ord(TextMode));
  end;
end;

function fonctionTserverA_Active(var pu: TypeUO):boolean;
begin
  verifierObjet(pu);
  with TserverA(pu) do
  begin
    result:=active0;
  end;
end;


procedure proTserverA_OnReceive(p:integer;var pu:typeUO);
begin
  verifierObjet(TypeUO(pu));
  with TserverA(pu).OnReceivePG2 do setAd(p);
end;

function fonctionTserverA_OnReceive(var pu:typeUO):integer;
begin
  verifierObjet(TypeUO(pu));
  result:=TserverA(pu).OnReceivePG2.ad;
end;



function fonctionTserverA_OutBuffer(var pu:typeUO):Tbuffer;pascal;
begin
  verifierObjet(pu);
  with TserverA(pu) do
  begin
    result:=FoutputBuffer;
  end;
end;

procedure proTserverA_sendBuffer(var pu:typeUO);
begin
  verifierObjet(pu);
  with TserverA(pu) do
  begin
    putBuffer;
  end;
end;

procedure proTserverA_SendString(st:AnsiString;var pu:typeUO);
begin
  verifierObjet(pu);
  with TserverA(pu) do
  begin
    sendString(st);
  end;
end;

procedure proTserverA_SendString512(st:AnsiString;bb:byte;var pu:typeUO);
var
  st1:AnsiString;
begin
  verifierObjet(pu);
  setlength(st1,512);
  fillchar(st1[1],512,bb);
  move(st[1],st1[1],length(st));

  TserverA(pu).sendString(st1);
end;

function fonctionTserverA_ReceiveString(var pu:typeUO):AnsiString;
begin
  verifierObjet(pu);
  with TserverA(pu) do
  begin
    result:=receiveString;
  end;
end;

procedure proTserverA_SetTestMode(mode:boolean; nb:integer;var pu:typeUO);
begin
  verifierObjet(pu);
  TestMode:=mode;
  MaxTestMode:=nb;
end;


{*********************************** Méthodes stm de TclientA **************************************}

function fonctionTclientA_create(serverIP:AnsiString; port:integer; Active: boolean;  var pu:typeUO): boolean;
begin
  result:=fonctionTclientA_create_1(serverIP, port,0, pu);
end;


function fonctionTclientA_create_1(serverIP:AnsiString; port:integer;ConnectTO: integer;  var pu:typeUO): boolean;
begin
  createPgObject('',pu,TclientA);
  with TclientA(pu) do
  begin
    result:= setup(serverIP,port,connectTO);
  end;
end;

function fonctionTclientA_create_2(serverIP:AnsiString; port:integer;ConnectTO,readTO: integer;  var pu:typeUO): boolean;
begin
  createPgObject('',pu,TclientA);
  with TclientA(pu) do
  begin
    result:= setup(serverIP,port,connectTO, readTO);
  end;
end;


function fonctionTclientA_OutBuffer(var pu:typeUO):Tbuffer;
begin
  verifierObjet(pu);
  with TclientA(pu) do
  begin
    result:=currentBuffer;
  end;
end;

procedure proTclientA_sendBuffer(var pu:typeUO);
begin
  verifierObjet(pu);
  with TclientA(pu) do
  begin
    sendBuffer;
  end;
end;

procedure proTclientA_sendElphyCommand(stCom,stParam:AnsiString;var pu:typeUO);
begin
  verifierObjet(pu);
  with TclientA(pu) do
  begin
    with currentBuffer do
    begin
      clear;
      ident:=stCom;
      writeShortString(stParam);
    end;
    sendBuffer;
  end;
end;

procedure proTclientA_SendString(st:AnsiString;var pu:typeUO);
begin
  verifierObjet(pu);
  TclientA(pu).sendString(st);
end;

procedure proTclientA_SendString512(st:AnsiString;bb:byte;var pu:typeUO);
var
  st1:AnsiString;
begin
  verifierObjet(pu);
  setlength(st1,512);
  fillchar(st1[1],512,bb);
  move(st[1],st1[1],length(st));

  TclientA(pu).sendString(st1);
end;


function fonctionTclientA_ReceiveString(var pu:typeUO):AnsiString;
begin
  verifierObjet(pu);
  result:=TclientA(pu).receiveString;
end;

function fonctionTclientA_ReceiveString512(var pu:typeUO):AnsiString;
begin
  verifierObjet(pu);
  result:=TclientA(pu).receiveString512;
end;

procedure proTclientA_SetRawBuffer(w:boolean;var pu:typeUO);
begin
  verifierObjet(pu);
  with TclientA(pu) do
  begin
    currentBuffer.Free;
    currentBuffer:=Tbuffer.create(w);
  end;
end;

{$ENDIF}
end.
