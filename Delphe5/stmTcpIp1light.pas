unit stmTcpIp1light;

interface
{$IFDEF FPC} {$mode delphi} {$DEFINE AcqElphy2} {$A1} {$Z1} {$ENDIF}

{$DEFINE NOTELPHY}
{ Est identique à stmTCPIP1 mais définit NOTELPHY

 Quand NOTELPHY est défini, toutes les réfrences à Elphy sont supprimées.
}



uses windows,classes,sysutils,Dialogs,extCtrls,forms,
     IdGlobal, IdIOHandler,IdTCPServer, IdTCPclient, IdSocketHandle, IdContext, IdStack, IdStreamVcl, IdAntiFreeze,
     util1
     {$IFNDEF NOTELPHY} ,stmdef,stmObj,stmDobj1, stmPG  {$ENDIF}
     ;


Const
   DefaultServerIP = '127.0.0.1';
   DefaultServerPort = 50190;

var
  idAntiFreeze:TidAntiFreeze;
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


type
  TbufferInfo=record
                id:string[20];
                idNum:integer;
                flagQuery:boolean;              
              end;


  Tbuffer=class

          private
            buf:TmemoryStream;

            function getBytecount:integer;
            procedure setByteCount(n:integer);

            function getIdent:AnsiString;
            procedure setIdent(st:AnsiString);

            function getIdNum:integer;
            procedure setIdNum(n:integer);

            function getIsQuery:boolean;
            procedure setIsQuery(w:boolean);

            procedure writeInfo(var info:TbufferInfo);
            procedure readInfo(var info:TbufferInfo);


          public
            constructor create;
            destructor destroy;override;
            property ByteCount:integer read getByteCount write setByteCount;
            property ident:AnsiString read getIdent write setIdent;
            property idNum:integer read getIdNum write setIdNum;
            property IsQuery:boolean read getIsQuery write setIsQuery;
                                                                             
            procedure Clear;
            procedure ResetIndex;                                    
            procedure init(stIdent:AnsiString;num:integer;query:boolean);

            procedure read(var x;nb:integer);
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
             onReceive:Tpg2event;
             {$ENDIF}
             procedure idServerConnect(AContext:TIdContext);
             procedure idServerExecute(AContext:TIdContext);
             procedure idServerDisconnect(AContext:TIdContext);


           public
             IP0:AnsiString;
             port0:integer;
             Active0:boolean;


             constructor create;{$IFNDEF NOTELPHY}override;{$ENDIF}
             destructor destroy;override;

             procedure setup(serverIP:AnsiString;ServerPort:integer;active:boolean);

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

             procedure setup(serverIP:AnsiString;ServerPort:integer;active:boolean);
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
procedure proTbuffer_ResetIndex(pu: Tbuffer);pascal;


procedure proTbuffer_ReadObject(var uo:typeUO; pu: Tbuffer); pascal;
procedure proTbuffer_writeObject(var uo:typeUO; pu: Tbuffer); pascal;

procedure proTbuffer_ReadString(var st:AnsiString; pu: Tbuffer);pascal;
procedure proTbuffer_ReadString_1(var st:PgString;sz:integer; pu: Tbuffer);pascal;

procedure proTbuffer_writeString(st:AnsiString; pu: Tbuffer);pascal;



procedure proTserverA_create(myIP:AnsiString; port:integer; var pu:typeUO);pascal;
procedure proTserverA_create_1(myIP:AnsiString; port:integer; TextMode1:boolean; var pu:typeUO);pascal;

procedure proTserverA_Active(w:boolean;var pu:typeUO); pascal;
function fonctionTserverA_Active(var pu: TypeUO):boolean; pascal;

procedure proTserverA_OnReceive(p:integer;var pu:typeUO);pascal;
function fonctionTserverA_OnReceive(var pu:typeUO):integer;pascal;

function fonctionTserverA_OutBuffer(var pu:typeUO):Tbuffer;pascal;
procedure proTserverA_sendBuffer(var pu:typeUO);pascal;

procedure proTserverA_SendString(st:AnsiString;var pu:typeUO);pascal;
procedure proTserverA_SendString512(st:AnsiString;bb:byte;var pu:typeUO);pascal;
function fonctionTserverA_ReceiveString(var pu:typeUO):AnsiString;pascal;


procedure proTclientA_create(serverIP:AnsiString; port:integer; active:boolean; var pu:typeUO);pascal;

function fonctionTclientA_OutBuffer(var pu:typeUO):Tbuffer;pascal;
procedure proTclientA_sendBuffer(var pu:typeUO);pascal;

procedure proTclientA_sendElphyCommand(stCom,stParam:AnsiString;var pu:typeUO);pascal;

procedure proTclientA_SendString(st:AnsiString;var pu:typeUO);pascal;
procedure proTclientA_SendString512(st:AnsiString;bb:byte;var pu:typeUO);pascal;
function fonctionTclientA_ReceiveString(var pu:typeUO):AnsiString;pascal;
function fonctionTclientA_ReceiveString512(var pu:typeUO):AnsiString;pascal;
{$ENDIF}

implementation

{ Tbuffer }

function Tbuffer.getBytecount: integer;
begin
  result:=buf.size;
end;

procedure Tbuffer.setByteCount(n: integer);
begin
  buf.Size:=n;
end;

procedure Tbuffer.read(var x; nb: integer);      
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

{Place l'indice sur les premières données }
procedure Tbuffer.ResetIndex;
var
  info:TbufferInfo;
begin
  if buf.size<sizeof(TbufferInfo) then
  begin
    buf.clear;
    fillchar(info,sizeof(info),0);
    buf.WriteBuffer(info,sizeof(info));
  end
  else buf.Position:=sizeof(info);
end;


constructor Tbuffer.create;
begin
  buf:=TmemoryStream.create;
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
  readInfo(info);
  result:=info.id;
end;

procedure Tbuffer.setIdent(st: AnsiString);
var
  info:TbufferInfo;
begin
  readInfo(info);
  info.id:=st;
  writeInfo(Info);
end;

function Tbuffer.getIdNum: integer;
var
  info:TbufferInfo;
begin
  readInfo(info);
  result:=info.idNum;
end;


procedure Tbuffer.setIdNum(n: integer);
var
  info:TbufferInfo;
begin
  readInfo(info);
  info.idNum:=n;
  writeInfo(Info);
end;



function Tbuffer.getIsQuery:boolean;
var
  info:TbufferInfo;
begin
  readInfo(info);
  result:=info.flagQuery;
end;

procedure Tbuffer.setIsQuery(w:boolean);
var
  info:TbufferInfo;
begin
  readInfo(info);
  info.flagQuery:=w;
  writeInfo(info);
end;

procedure Tbuffer.init(stIdent: AnsiString; num: integer; query: boolean);
var
  info:TbufferInfo;
begin
  info.id:=stIdent;
  info.idNum:=num;
  info.flagQuery:=query;

  buf.Clear;
  buf.Write(info,sizeof(info));
end;



procedure Tbuffer.send(IOhandler: TidIOhandler);
var
  IdStream:TidStreamVcl;
begin
  IdStream:=TidStreamVcl.Create(buf);

  try
  IOHandler.Write(buf.Size);
  IOHandler.WriteBufferOpen;
  IOhandler.Write(IdStream);
  IOhandler.WriteBufferClose;

  finally
  IdStream.free;
  end;
end;

procedure Tbuffer.receive(IOhandler: TidIOhandler);
var
  IdStream:TidStreamVcl;
  size:integer;
begin
  size:=IOHandler.readInt64;
  if size>0 then
  begin
    buf.Clear;
    IdStream:=TIdStreamVcl.Create(buf);
    try
    IOhandler.ReadStream(IdStream,Size);
    finally
    IdStream.free;
    end;
  end
  else clear;

  resetIndex;
end;


procedure Tbuffer.readInfo(var info:TbufferInfo);
var
  old:integer;
begin
  old:=buf.Position;
  buf.Position:=0;
  buf.ReadBuffer(info,sizeof(info));
  buf.Position:=old;
end;

procedure Tbuffer.writeInfo(var info:TbufferInfo);
var
  old:integer;
begin
  old:=buf.Position;
  buf.Position:=0;
  buf.writeBuffer(info,sizeof(info));
  buf.Position:=old;
end;


{ TserverA }


{$IFNDEF NOTELPHY}
constructor TserverA.create;
begin
  inherited;

  if not assigned(idAntiFreeze)
    then idAntiFreeze:=TidAntiFreeze.Create(formStm);

  idServer:=TidTCPserver.Create(formstm);
  with idServer do
  begin
    onConnect:=idServerConnect;
    onDisConnect:=idServerDisConnect;
    onExecute:=idServerExecute;
  end;

  InBuffers:=TThreadList.create;
  OutBuffers:=TThreadList.create;

  FoutputBuffer:=Tbuffer.create;
end;

procedure TserverA.setup(serverIP:AnsiString;ServerPort:integer;active:boolean);
var
  Bindings: TIdSocketHandles;
begin
  if serverIP='' then serverIP:=DefaultServerIP;
  if serverPort=0 then serverPort:=DefaultServerPort;

  IP0:=serverIP;
  Port0:=ServerPort;
  Active0:=active;

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


  idServer.free;

  currentBuffer.Free;
  FoutputBuffer.free;
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
    FoutputBuffer:=Tbuffer.create;
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
  size:integer;
  buffer:Tbuffer;
  IdtmpStream : TIdStreamVcl;
  i:integer;
  st:AnsiString;
begin
  if not Acontext.Connection.Connected then exit;

  if not TextMode then { Mode buffer }
  begin
    {lire la taille du buffer = int64}
    Size := Acontext.Connection.IOhandler.ReadInt64;

    if size>0 then
    begin
      buffer:=Tbuffer.create;
      buffer.buf.clear;
      IdTmpStream:=TIdStreamVcl.Create(buffer.buf);

      {lire tout le buffer}
      Acontext.Connection.IOhandler.ReadStream(IdTmpStream,Size);

      IdTmpStream.free;

      if buffer.IsQuery then                { S'il s'agit d'une question }
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
      end
      else
      begin                                 { si ce n'est pas une question }
        try
          InBuffers.LockList.Add(buffer);   { on range le buffer dans la liste InBuffers }
        finally
          InBuffers.UnlockList;
        end;                                { et on informe le thread principal de l'arrivée d'un nouveau buffer }

        postMessage(formstm.Handle,msg_server,intG(self),0);
      end;
    end;
  end
  else
  begin     {mode Texte }
    st:=Acontext.Connection.IOhandler.Readln;
    buffer:=Tbuffer.create;             { on crée un buffer contenant la chaîne }
    buffer.ident:='_string';
    buffer.writeString(st);

    try
      InBuffers.LockList.Add(buffer);   { on range le buffer dans la liste InBuffers }
    finally
      InBuffers.UnlockList;
    end;
  end;
end;


procedure TserverA.ProcessBuffer(sender: Tobject);
var
  buffer:Tbuffer;
begin
  repeat
    buffer:=getBuffer;
    if assigned(buffer) and onReceive.valid then
    try
      with onReceive do
       pg.executerOnServerEvent(ad,typeUO(buffer));
    finally
      buffer.free;
    end
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



{ TclientA }


constructor TclientA.create;

begin
  inherited;

  if not assigned(idAntiFreeze)
    then idAntiFreeze:=TidAntiFreeze.Create(formStm);


  idClient:=TidTCPclient.Create(formstm);
  with idclient do
  begin

  end;

  currentBuffer:=Tbuffer.create;
end;

procedure TClientA.setup(serverIP:AnsiString;ServerPort:integer;active:boolean);
begin
  if serverIP='' then serverIP:=DefaultServerIP;
  if serverPort=0 then serverPort:=DefaultServerPort;

  try
    idClient.Host := ServerIP;
    idClient.Port := ServerPort;
    idClient.Connect;
  except
    on E: Exception do MessageDlg ('Error while connecting to Elphy server:'+#13+E.Message, mtError, [mbOk], 0);
  end;
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



{*********************************** Méthodes stm de TserverA **************************************}


procedure proTserverA_create(myIP:AnsiString; port:integer; var pu:typeUO);pascal;
begin
  createPgObject('',pu,TserverA);
  with TserverA(pu) do
  begin
    setup(myIP,port,true);
  end;
end;

procedure proTserverA_create_1(myIP:AnsiString; port:integer; TextMode1:boolean; var pu:typeUO);
begin
  createPgObject('',pu,TserverA);
  with TserverA(pu) do
  begin
    setup(myIP,port,true);
    TextMode:=TextMode1;
  end;
end;

procedure proTserverA_Active(w:boolean;var pu:typeUO);
begin
  verifierObjet(pu);
  with TserverA(pu) do
  begin
    active0:=w;
    setup(IP0,port0,active0);
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
  with TserverA(pu).onReceive do setAd(p);
end;

function fonctionTserverA_OnReceive(var pu:typeUO):integer;
begin
  verifierObjet(TypeUO(pu));
  result:=TserverA(pu).OnReceive.ad;
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


{*********************************** Méthodes stm de TclientA **************************************}


procedure proTclientA_create(serverIP:AnsiString; port:integer; active:boolean; var pu:typeUO);
begin
  createPgObject('',pu,TclientA);
  with TclientA(pu) do
  begin
    setup(serverIP,port,active);
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

{$ENDIF}
end.
