unit NrnDll1;


interface

uses windows, classes, sysutils, messages,
     util1, consoleNrn1;

Const
  StNrnDll = 'NrnDll.dll'; // 'D:\VSprojects\nrnVS6\NrnDLLdebug\NrnDll.dll';

type
  Tprintf= procedure (buf: PansiChar; len: integer);cdecl;
  Treadline = function (prompt: PansiChar): Pansichar; cdecl;

var
  NrnInit: procedure (ProcPrintf: Tprintf; ProcReadline: Treadline; stBin, stHoc: PAnsiChar);cdecl;
  NrnDone: procedure;cdecl;
  Gnrn_val_pointer: function(p: Pansichar): Pdouble;cdecl;
  Gnrn_fixed_step: procedure; cdecl;

  GetSymList: procedure (code: integer; Buf: pointer;var len: integer);cdecl;



function InitNrnDLL(stBinFile, stHocFile:AnsiString):boolean;
procedure NrnSendString(st:AnsiString);

function RTconsole:TconsoleNrn;

implementation

var
  hh: intG;

const
  msg_NrnTextCommand= wm_user+1;

function InitNrnlib:boolean;
begin
  result:=true;
  if hh<>0 then exit;

  hh:=GloadLibrary(stNrnDll);
  result:=(hh<>0);

  if not result then exit;

  NrnInit:= getProc(hh,'Init');
  NrnDone:= getProc(hh,'done');
  Gnrn_val_pointer:= getProc(hh,'Gnrn_val_pointer');
  Gnrn_fixed_step:= getProc(hh,'Gnrn_fixed_step');

  GetSymList:= getProc(hh,'GetSymList');
end;



type
  TThreadNRN = class( Tthread )
                 procedure execute;override;
               end;

  TconsoleTool=class
                 procedure ProcessLine(st:AnsiString);
               end;

var
  threadNrn: TThreadNrn;

  consoleG:TconsoleNrn;
  ConsoleTool: TconsoleTool;

  ReadlineFlag: boolean;
  ReadLineId: integer;

procedure NrnSendString(st:AnsiString);
var
  p: PtabOctet;
  tick0:integer;
const
  id:integer=0;
begin
  if st='' then exit;

  tick0:= getTickCount;
  repeat until ReadLineFlag or (getTickCount-tick0>20);

  getmem(p,length(st)+4);
  Plongint(p)^:=length(st);
  move(st[1],p^[4], length(st));

  inc(id);
  tick0:= getTickCount;

  PostThreadMessage(ThreadNrn.ThreadID, Msg_NrnTextCommand , intG(p),id);
  repeat until (ReadLineId=id) or (getTickCount-tick0>20);
end;



procedure TconsoleTool.ProcessLine(st:AnsiString);
begin
  NrnSendString(st);
end;



function RTconsole:TconsoleNrn;
begin
  if not assigned(consoleTool) then consoleTool:=TconsoleTool.Create;
  if not assigned(consoleG) then
  begin
    consoleG:=TconsoleNrn.Create(nil);
    consoleG.Caption:='NEURON console';
    consoleG.Init;
    consoleG.ProcessLine:=consoleTool.ProcessLine;

  end;

  result:=consoleG;
end;


procedure NrnPrintf(buf: PAnsichar; len:integer);cdecl;
var
  st:string;
begin
  setLength(st,len);

  move(buf^,st[1],len);
  while (st<>'') and (st[length(st)]<' ') do delete(st,length(st),1);
  if assigned(ConsoleG) then consoleG.AddLine(st);
end;


type
  Enrn=class(exception);


function NrnReadline(prompt:Pansichar) : Pansichar;cdecl;
var
  msg: Tmsg;
  p:PtabOctet;
  id:integer;
  st:string;
Const
  res:ShortString ='';

begin
  msg.message :=0;
  readlineFlag:=true;
  while GetMessage(msg, 0, 0, 0) do
  begin
    res:='';
    if (msg.message=Msg_NrnTextCommand) then
    begin
      p:= PtabOctet(msg.wParam);
      id:=msg.lparam;

      if id<>ReadLineId then
      begin
        res[0]:=Pansichar(p)^;
        move(p^[4],res[1],length(res));
        res[length(res)+1]:=#0;

        freemem(p);

        result:=@res[1];

        if result='ZUT' then break;
        readlineFlag:=false;
        ReadLineId:=Id;
        exit;
      end;
    end
    else
    begin
      TranslateMessage(msg);
      DispatchMessage(msg);
    end;
  end;

  res:= 'quit()'+#0;
  result:=@res[1];
  readlineFlag:=false;
end;

var
  stBinFile1, stHocFile1:AnsiString;

procedure TThreadNRN.execute;
begin
  NrnInit(NrnPrintf, NrnReadline,PansiChar(stBinFile1), PansiChar(stHocFile1));

  messageCentral('Sortie NRN');
end;


procedure FreeNrnDLL;
begin
  NrnDone;
  NrnSendString('printf("good bye \n")');

end;


function InitNrnDll(stBinFile, stHocFile:AnsiString): boolean;
begin
  stBinFile1:= stBinFile;
  stHocFile1:= stHocFile;

  result:=initNrnLib;

  if not result then exit;

  RTconsole.show;  // Crée la console
  ThreadNrn:=TthreadNrn.create(false);

end;





end.
