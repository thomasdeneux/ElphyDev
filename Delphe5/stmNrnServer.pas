unit StmNrnServer;

interface
{$IFDEF FPC} {$mode delphi} {$DEFINE AcqElphy2} {$A1} {$Z1} {$ENDIF}

uses windows,sysutils,classes,
     util1,stmObj,stmvec1, Ncdef2,stmPG;


type
  TNeuronServer= class(typeUO)
                   CreateOK:boolean;
                   hPipe:Thandle;
                   stError:AnsiString;

                   InputVec:Tstringlist;
                   OutputVec:Tstringlist;

                   function send(id,size:integer;var x):integer;
                   procedure Receive(var x; size:integer);
                   function ReceiveString:AnsiString;

                   constructor create;override;
                   destructor destroy;override;
                   procedure init(stF:AnsiString);
                   class function stmClassName:AnsiString;override;
                   procedure ProcessMessage(id:integer;source:typeUO;p:pointer);override;
                   procedure executeCommand(st:AnsiString);
                   procedure setValue(name:AnsiString;w:double);
                   function getValue(name:AnsiString):double;

                   procedure getStL(stL:TstringList;RootName:AnsiString);
                   function getSymList(cat:integer):TstringList;

                   procedure AddInputVec(vec:Tvector;name:AnsiString);
                   procedure ResetInputVec;
                   procedure AddOutputVec(vec:Tvector;name:AnsiString);
                   procedure ResetOutputVec;

                   procedure Run;

                   function ChooseSymbol:AnsiString;
                 end;


procedure proTNeuronServer_create(stF:AnsiString;var pu:typeUO);pascal;
procedure proTNeuronServer_execute(st:AnsiString;var pu:typeUO);pascal;

procedure proTNeuronServer_value(Name:AnsiString;w:float;var pu:typeUO);pascal;
function fonctionTNeuronServer_value(Name:AnsiString;var pu:typeUO):float;pascal;

procedure proTNeuronServer_resetVectors(var pu:typeUO);pascal;
procedure proTNeuronServer_setInputVector(name:AnsiString;var vec:Tvector;var pu:typeUO);pascal;
procedure proTNeuronServer_setOutputVector(name:AnsiString;var vec:Tvector;var pu:typeUO);pascal;

procedure proTNeuronServer_run(var pu:typeUO);pascal;
function fonctionTNeuronServer_ChooseSymbol(var pu:typeUO):AnsiString;pascal;


implementation

uses ChooseNrnName;

Const
  EM_Command   = 1;
  EM_SetValue  = 2;
  EM_GetValue  = 3;
  EM_RUN       = 4;
  EM_GetSymList= 5;

  EM_OK = 1000;

var
  NeuronServer:TNeuronServer;

type
  TpipeRecord= record
                 msg:integer;
                 msgSize:integer;
               end;


{ TNeuronServer }

constructor TNeuronServer.create;
begin
  inherited;
  NeuronServer:=self;

  InputVec:=Tstringlist.create;
  OutputVec:=Tstringlist.create;

end;

destructor TNeuronServer.destroy;
begin
  executeCommand('quit()');
  CloseHandle(hPipe);

  ResetInputVec;
  ResetOutputVec;

  InputVec.free;
  OutputVec.free;

  NeuronServer:=nil;
  inherited;
end;

procedure TneuronServer.init(stF:AnsiString);
var
  processInfo:TprocessInformation;
  {$IF CompilerVersion >=22}
  startUp:TstartUpInfoA;
  {$ELSE}
  startUp:TstartUpInfo;
  {$IFEND}
  
  flags,dwMode:Dword;

  ok:boolean;
  t0:integer;
const
  lpszPipename:AnsiString = '\\.\pipe\NrnServerPipe';

begin
  stError:='';
  flags:=0;
  fillchar(startUp,sizeof(startUp),0);
  startUp.cb:=sizeof(startUp);

  CreateOK:= createProcessA(Pansichar(stF),nil,nil,nil,false,Flags,nil,nil,startUp,processInfo);

  t0:=getTickCount;
  repeat until (getTickCount-t0>1000);

  if not createOK then
  begin
    stError:='Unable to load '+stF;
    exit;
  end;

  ok:=false;
  while not ok do
  begin
    hPipe := CreateFileA(
         Pansichar(lpszPipename),   // pipe name
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
      if not WaitNamedPipeA(Pansichar(lpszPipename), 20000) then
      begin
        stError:='Could not open Nrn Server pipe : '+getLastErrorString;
        CreateOK:=false;
        exit;
      end;
    end;
  end;

  dwMode := PIPE_READMODE_MESSAGE;
  ok:= SetNamedPipeHandleState(
      hPipe,    // pipe handle
      dwMode,  // new pipe mode
      Nil,     // don't set max. bytes
      Nil);    // don't set max. time
  if not ok then
  begin
    stError:='SetNamedPipeHandleState Error';
    CreateOK:=false;
    exit;
  end;

end;


procedure TNeuronServer.executeCommand(st: AnsiString);
var
   cbRead, cbWritten:Dword;
   ok:boolean;
   rec:TpipeRecord;
begin
  stError:='';
  if length(st)=0 then exit;

  rec.msg:=EM_Command;
  rec.msgSize:=length(st);

  ok:= WriteFile( hPipe,rec, sizeof(rec), cbWritten, Nil);
  ok:= ok and WriteFile( hPipe,st[1], length(st), cbWritten, Nil);
  if not ok then
  begin
    stError:='WriteFile error';
    exit;
  end;

  ok:= ReadFile(hPipe,rec,sizeof(rec),cbRead,nil);
  if not ok and (GetLastError<> ERROR_MORE_DATA) then
  begin
    stError:='Read file error';
    exit;
  end;
  ok:=(rec.msg=EM_OK);
  if not ok then stError:='Invalid response from server';
end;


class function TNeuronServer.stmClassName: AnsiString;
begin
  result:='NeuronServer';
end;



function TNeuronServer.send(id,size:integer;var x):integer;
var
   cbRead, cbWritten:Dword;
   ok:boolean;
   rec:TpipeRecord;
begin
  stError:='';
  result:=0;

  rec.msg:=id;
  rec.msgSize:=size;

  ok:= WriteFile( hPipe,rec, sizeof(rec), cbWritten, Nil);
  ok:= ok and WriteFile( hPipe,x, size, cbWritten, Nil);
  if not ok then
  begin
    stError:='WriteFile error - '+getLastErrorString;
    exit;
  end;

  ok:= ReadFile(hPipe,rec,sizeof(rec),cbRead,nil);
  if not ok and (GetLastError<> ERROR_MORE_DATA) then
  begin
    stError:='Read file error';
    exit;
  end;
  ok:=(rec.msg=EM_OK);
  if not ok then stError:='Invalid response from server';

  result:=rec.msgSize;
end;


procedure TNeuronServer.Receive(var x;size:integer);
var
   cbRead:Dword;
   ok:boolean;
begin
  stError:='';

  ok:= ReadFile(hPipe,x,size,cbRead,nil);
  if not ok and (GetLastError<> ERROR_MORE_DATA) then
  begin
    stError:='Read file error';
    exit;
  end;
  if not ok then stError:='Invalid response from server';
end;

function TNeuronServer.ReceiveString:AnsiString;
var
  st:AnsiString;
  stSize:integer;

  cbRead:Dword;
  ok:boolean;
begin
  stError:='';

  ok:= ReadFile(hPipe,stSize,4,cbRead,nil);      { AnsiString length }
  if not ok then
  begin
    stError:='Read file error';
    exit;
  end;

  if (stSize<0) or (stSize>1000) then
  begin
    stError:='Huge AnsiString';
    exit;
  end;

  if stSize>0 then
  begin
    setLength(st,stSize);
    ok:= ReadFile(hPipe,st[1],stSize,cbRead,nil); {stSize characters }
    if not ok then
    begin
      stError:='Read file error';
      exit;
    end;
  end;

  result:=st;
end;


procedure TNeuronServer.setValue(name: AnsiString; w: double);
type
  Trec=record
          value:double;
          chars:array[1..255] of char;
       end;
var
  rec:Trec;
  res:integer;
begin
  if length(name)=0 then exit;
  rec.value:=w;
  move(name[1],rec.chars,length(name));

  res:=send(EM_setValue,8+length(name),rec);
  if (stError='') and (res<0) then stError:='unable to find '+name;
end;

function TNeuronServer.getValue(name: AnsiString): double;
var
   w:double;
   sz:integer;
begin
  w:=0;
  result:=0;
  if length(name)=0 then exit;

  sz:=send(EM_getValue,length(name),name[1]);
  if sz<>sizeof(double) then
  begin
    if sz<0 then stError:='unable to find '+name
    else stError:='Bad value';
  end
  else receive(w,sz);

  result:=w;
end;


procedure TNeuronServer.getStL(stL:TstringList;RootName:AnsiString);
var
  i,nb:integer;
  st:AnsiString;
begin
  if stError<>'' then exit;
  receive(nb,4);                          {Number of strings}
  stL.AddObject(RootName,pointer(nb));

  for i:=1 to nb do
  begin
    st:=ReceiveString;
    if stError<>'' then exit;
    if (length(st)>0) and (st[length(st)]='.')     { ex: 'Parent.' }
      then getStL(stL,st)
      else stL.Add(st);
  end;
end;

function TNeuronServer.getSymList(cat:integer):TstringList;
var
  nb,sz:integer;
begin
  result:=nil;
  sz:=send(EM_getSymList,sizeof(integer),cat);

  if sz<>0 then
  begin
    stError:='GetSymList error';
    exit;
  end;

  result:=TstringList.create;
  getStL(result,'Root');
end;


procedure TNeuronServer.AddInputVec(vec: Tvector;name:AnsiString);
var
  w:double;
begin
  if (InputVec.IndexOf(name)>=0) {or (InputVec.IndexOfObject(vec)>=0)} then
  begin
    stError:='The name already exists';
    exit;
  end
  else stError:='';

  w:=getValue(name);
  if stError<>'' then exit;

  InputVec.AddObject(name,vec);

  refObjet(typeUO(vec));
end;

procedure TNeuronServer.ResetInputVec;
var
  i:integer;
  vec:TypeUO;
begin
  with InputVec do
  begin
    for i:=0 to count-1 do
    begin
      vec:=TypeUO(objects[i]);
      derefObjet(vec);
    end;
    clear;
  end;
end;


procedure TNeuronServer.AddOutputVec(vec: Tvector;name:AnsiString);
var
  w:double;
begin
  if (OutputVec.IndexOf(name)>=0) {or (OutputVec.IndexOfObject(vec)>=0)} then
  begin
    stError:='The name already exists';
    exit;
  end
  else stError:='';

  w:=getValue(name);
  if stError<>'' then exit;

  OutputVec.AddObject(name,vec);

  refObjet(typeUO(vec));
end;

procedure TNeuronServer.ResetOutputVec;
var
  i:integer;
  vec:TypeUO;
begin
  with OutputVec do
  begin
    for i:=0 to count-1 do
    begin
      vec:=TypeUO(objects[i]);
      derefObjet(vec);
    end;
    clear;
  end;
end;


procedure TNeuronServer.ProcessMessage(id: integer; source: typeUO; p: pointer);
var
  i:integer;
begin
  inherited processMessage(id,source,p);
  case id of
    UOmsg_destroy:
      begin
        for i:=InputVec.Count-1 downto 0 do
          if (inputVec.Objects[i]=source)then
          begin
            inputVec.delete(i);
            derefObjet(source);
          end;

        for i:=OutputVec.Count-1 downto 0 do
          if (OutputVec.Objects[i]=source)then
          begin
            OutputVec.delete(i);
            derefObjet(source);
          end;
      end;
  end;
end;

procedure TNeuronServer.Run;
var
   cbRead, cbWritten:Dword;
   ok:boolean;
   rec:TpipeRecord;

   Nbpt,NvecI,NvecO:integer;
   i,j:integer;
   sz:integer;
   tbW:array of double;
   v0:Tvector;

begin
{  On envoie:
     Le pipeRecord avec code EM_RUN, puis:

     Nbpt          nb de points par vecteur      4 octets
     NvecI         nb vecteurs en entrée         4 octets
     NvecO         nb vecteurs en sortie         4 octets

     Les NvecI vecteurs d'entrée soit  nbpt*nbvecI*8 octets (type double)

     Les noms des variables d'entrée sous la forme longueur L(4octets) + L caractères
     Les noms des variables de sortie sous la forme longueur L(4octets) + L caractères

     Ensuite, on attend le pipeRecord de la réponse

     Puis on lit les NvecO vecteurs de sortie soit nbpt*nbvecO*8 octets (type double)
}

  NvecI:=InputVec.count;
  NvecO:=OutputVec.count;
  if (NvecI=0) or (NvecO=0) then exit;

  v0:=Tvector(InputVec.Objects[0]);
  nbpt:=maxEntierLong;
  for i:=0 to NvecI-1 do
    with Tvector(InputVec.Objects[i]) do
    begin
      if Icount<nbpt then nbpt:= Icount;
      if (dxu<>v0.dxu) or (x0u<>v0.X0u) or (Istart<>v0.Istart) then
      begin
        stError:='Bad parameters in input vectors';
        exit;
      end;
    end;

  for i:=0 to NvecO-1 do
    with Tvector(OutputVec.Objects[i]) do
    begin
      initTemp1(v0.Istart,v0.Istart+nbpt-1,tpNum);
      Dxu:=v0.Dxu;
      x0u:=v0.X0u;
    end;

  setValue('dt',v0.Dxu);

  stError:='';

  rec.msg:=EM_RUN;
  rec.msgSize:= 12 + NvecI*Nbpt*8;
  for i:=0 to NvecI-1 do inc(rec.msgSize,4+length(InputVec[i]));
  for i:=0 to NvecO-1 do inc(rec.msgSize,4+length(OutputVec[i]));

  ok:= WriteFile( hPipe,rec, sizeof(rec), cbWritten, Nil);
  ok:= ok and WriteFile( hPipe,Nbpt, 4, cbWritten, Nil);
  ok:= ok and WriteFile( hPipe,NvecI, 4, cbWritten, Nil);
  ok:= ok and WriteFile( hPipe,NvecO, 4, cbWritten, Nil);

  setlength(tbW,nbpt);

  for i:=0 to NvecI-1 do
  begin
    with Tvector(InputVec.Objects[i]) do
    for j:=0 to nbpt-1 do tbW[j]:=Yvalue[Istart+j];
    ok:= ok and WriteFile( hPipe,tbW[0], nbpt*8, cbWritten, Nil);
  end;

  for i:=0 to NvecI-1 do
  begin
    sz:=length(InputVec[i]);
    ok:= ok and WriteFile( hPipe,sz, 4, cbWritten, Nil);
    ok:= ok and WriteFile( hPipe,InputVec[i][1], sz, cbWritten, Nil);
  end;

  for i:=0 to NvecO-1 do
  begin
    sz:=length(OutputVec[i]);
    ok:= ok and WriteFile( hPipe,sz, 4, cbWritten, Nil);
    ok:= ok and WriteFile( hPipe,OutputVec[i][1], sz, cbWritten, Nil);
  end;




  if not ok then
  begin
    stError:='WriteFile error - '+getLastErrorString;
    exit;
  end;

  ok:= ReadFile(hPipe,rec,sizeof(rec),cbRead,nil);
  if not ok and (GetLastError<> ERROR_MORE_DATA) then
  begin
    stError:='Read file error';
    exit;
  end;
  ok:=(rec.msg=EM_OK) and (rec.msgSize=nbpt*NvecO*8);;
  if not ok then
  begin
    stError:='Invalid response from server';
    exit;
  end;

  for i:=0 to NvecO-1 do
  begin
    ok:= ReadFile(hPipe,tbW[0],nbpt*8,cbRead,nil);
    if ok then
      with Tvector(OutputVec.Objects[i]) do
      for j:=0 to nbpt-1 do Yvalue[Istart+j]:=tbW[j]
    else break;
  end;

  if not ok then stError:='Unable to read output vector';

end;


function TNeuronServer.ChooseSymbol: AnsiString;
var
  stL1,stL2,stL3,stL4:TstringList;
begin
  stL1:=nil;
  stL2:=nil;
  stL3:=nil;
  stL4:=nil;

  stL1:=getSymList(304);
  if stError='' then stL2:=getSymList(320);
  if stError='' then stL3:=getSymList(263);
  if stError='' then stL4:=getSymList(321);

  result:=ChooseNrnSym.execute(stL1,stL2,stL3,stL4);

end;


{************************************* Méthodes stm ************************************}



procedure proTNeuronServer_create(stF:AnsiString;var pu:typeUO);
begin
  if assigned(NeuronServer) and (NeuronServer<>pu)
    then sortieErreur('Neuron Server already exists. Only one instance can be created.');
  createPgObject('',pu,TNeuronServer);
  NeuronServer:=TNeuronServer(pu);

  with TNeuronServer(pu) do
  begin
    init(stF);
    if not createOK then sortieErreur('TNeuronServer.create :'+stError);
  end;
end;

procedure proTNeuronServer_execute(st:AnsiString;var pu:typeUO);
begin
  verifierObjet(pu);
  with TneuronServer(pu) do
  begin
    executeCommand(st);
    if stError<>'' then sortieErreur(stError);
  end;
end;

procedure proTNeuronServer_value(Name:AnsiString;w:float;var pu:typeUO);
begin
  verifierObjet(pu);
  with TneuronServer(pu) do
  begin
    setValue(Name,w);
    if stError<>'' then sortieErreur('TNeuronServer.value : '+stError);
  end;
end;

function fonctionTNeuronServer_value(Name:AnsiString;var pu:typeUO):float;
begin
  verifierObjet(pu);
  with TneuronServer(pu) do
  begin
    result:=getValue(Name);
    if stError<>'' then sortieErreur('TNeuronServer.value : '+stError);
  end;
end;

procedure proTNeuronServer_setInputVector(name:AnsiString;var vec:Tvector;var pu:typeUO);
begin
  verifierObjet(pu);
  with TneuronServer(pu) do
  begin
    AddInputVec(vec,name);
    if stError<>'' then sortieErreur('TNeuronServer.SetInputVector : '+stError);
  end;
end;

procedure proTNeuronServer_setOutputVector(name:AnsiString;var vec:Tvector;var pu:typeUO);
begin
  verifiervecteurTemp(vec);
  with TneuronServer(pu) do
  begin
    AddOutputVec(vec,name);
    if stError<>'' then sortieErreur('TNeuronServer.SetInputVector : '+stError);
  end;
end;

procedure proTNeuronServer_resetVectors(var pu:typeUO);
begin
  verifierObjet(pu);
  TneuronServer(pu).ResetInputVec;
  TneuronServer(pu).ResetOutputVec;
end;

procedure proTNeuronServer_run(var pu:typeUO);
begin
  verifierObjet(pu);
  with TneuronServer(pu) do
  begin
    Run;
    if stError<>'' then sortieErreur('TNeuronServer.Run : '+stError);
  end;
end;

function fonctionTNeuronServer_ChooseSymbol(var pu:typeUO):AnsiString;
begin
  verifierObjet(pu);
  with TneuronServer(pu) do
  begin
    result:=ChooseSymbol;
  end;
end;


end.
