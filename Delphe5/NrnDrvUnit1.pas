unit NrnDrvUnit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, SynEdit, ExtCtrls,

  SynEditHighlighter,SynEditKeyCmds,

  util1, Gdos, Ddosfich, debug0, RTdef0 ;



Const
  NrnDLLname= 'NrnDll.dll' ;                                       // Nom habituel
  //NrnDLLname= 'D:\VSprojects10\nrnVS6\nrndlldebug\NrnDll.dll';       // Nom pour debug

type
  TNrnConsole = class(TForm)
    Panel1: TPanel;
    Panel2: TPanel;
    Panel4: TPanel;
    Editor: TSynEdit;
    Timer1: TTimer;
    procedure EditorProcessCommand(Sender: TObject;
      var Command: TSynEditorCommand; var AChar: Char; Data: Pointer);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
   private
    { Déclarations privées }
    Stack:TstringList;
    StackIndex:integer;
    MaxStackIndex:integer;

    StimPtr:array[1..32] of Pdouble; // pointeurs sur les variables associées aux sorties Elphy
    AcqPtr:array[1..32] of Pdouble;  // pointeurs sur les variables associées aux entrées Elphy
    TagPtr:array[1..32] of Pdouble;   // pointeurs sur les variables associées aux entrées Elphy logiques

    procedure EditorStatusChange(Sender: TObject;Changes: TSynStatusChanges);
    procedure PushLine(st:AnsiString);
    function PopLine:AnsiString;
    function PopLine2:AnsiString;

    procedure StartNrn(var Msg: Tmsg); message nc_start;

  public
    { Déclarations publiques }
    procedure ProcessLine(st:AnsiString);

    procedure Init;
    Procedure AddLine(st:AnsiString);

    function recInfo:PRTrecInfo;
    procedure InitAcqNrnPointer;
    function ProcessAg: integer;
    function getNrnValue(pst:PansiChar):double;
  end;

var
  NrnConsole: TNrnConsole;

implementation

{$R *.dfm}


var
  MainThreadID: integer;
  NrnBufferHnd: Thandle;
  NrnBuffer: PcomBuffer;
  EventHnd: Thandle;


const
  msg_NrnTextCommand= wm_user+1;

var
  hh: intG;
  ReadlineFlag: boolean;
  ReadLineId: integer;

type
  Tprintf= procedure (buf: PansiChar; len: integer);cdecl;
  Treadline = function (prompt: PansiChar): Pansichar; cdecl;

var
  NrnInit: procedure (ProcPrintf: Tprintf; ProcReadline: Treadline; stBin, stHoc: PAnsiChar);cdecl;
  NrnDone: procedure;cdecl;
  Gnrn_val_pointer: function(p: Pansichar): Pdouble;cdecl;
  Gnrn_fixed_step: procedure; cdecl;

  GetSymList: procedure (code: integer; Buf: pointer;var len: integer);cdecl;

  stBinFile, stHocFile:string;


procedure PrintLine(st:string);
begin
  if assigned(NrnConsole) then NrnConsole.AddLine(st);
end;

function InitNrnlib:boolean;
begin
  result:=true;
  if hh<>0 then exit;

//  messageCentral('Init NRN lib');

  hh:=GloadLibrary(NrnDllname);
  result:=(hh<>0);

  if not result then exit;

  NrnInit:= getProc(hh,'Init');
  NrnDone:= getProc(hh,'done');
  Gnrn_val_pointer:= getProc(hh,'Gnrn_val_pointer');
  Gnrn_fixed_step:= getProc(hh,'Gnrn_fixed_step');

  GetSymList:= getProc(hh,'GetSymList');
end;


procedure NrnPrintf(buf: PAnsichar; len:integer);cdecl;
var
  st:string;
begin
  setLength(st,len);

  move(buf^,st[1],len);
  while (st<>'') and (st[length(st)]<' ') do delete(st,length(st),1);
  if assigned(NrnConsole) then Nrnconsole.AddLine(st);
end;



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

  if assigned(NrnBuffer) then NrnBuffer^.command:= nc_dllQuit;

  res:= 'quit()'+#0;
  result:=@res[1];
  readlineFlag:=false;
end;


type
  TThreadCom = class( Tthread )
                 procedure execute;override;
               end;

var
  ThreadCom:TthreadCom;




{ TThreadCom }

Const
  MaxDelay=100;

procedure WaitReadLine;
var
  tick0:integer;
begin
  tick0:= getTickCount;
  repeat until ReadLineFlag or (getTickCount-tick0>MaxDelay);
end;

procedure NrnSendString(st:AnsiString);
var
  p: PtabOctet;
  tick0:integer;
const
  id:integer=0;
begin
  if st='' then exit;

  WaitReadLine;

  getmem(p,length(st)+4);
  Plongint(p)^:=length(st);
  move(st[1],p^[4], length(st));

  inc(id);
  tick0:= getTickCount;

  PostThreadMessage(MainThreadID, Msg_NrnTextCommand , intG(p),id);
  repeat until (ReadLineId=id) or (getTickCount-tick0>MaxDelay);

  PrintLine(st+'   ==>'+Bstr(ReadLineId=id) );
end;


var
  CntCom: integer;

procedure TThreadCom.execute;
var
  len:integer;
begin
  repeat
    if WaitForSingleObject(EventHnd, 250) = WAIT_OBJECT_0 then
    begin
      inc(CntCom);
      case NrnBuffer^.command of
         nc_quit: begin
                    NrnSendString('quit()');
                    NrnBuffer^.command:=0;
                  end;
         nc_sendString:
           begin
             NrnSendString( PshortString(@NrnBuffer^.data)^);
             NrnBuffer^.command:=0;
           end;

         nc_getSymList:
           begin
             WaitReadLine;
             getSymList( Pinteger(@NrnBuffer^.data)^, @NrnBuffer^.data, len);
             NrnBuffer^.command:=0;
           end;

         nc_InitAcqNrnPointer:
           begin
             NrnConsole.InitAcqNrnPointer;
             NrnBuffer^.command:=0;
           end;
         nc_ProcessAg:
           begin
             NrnBuffer^.command:= NrnConsole.ProcessAg;
           end;
         nc_getNrnValue:
           begin
             NrnBuffer^.Dresult:= NrnConsole.getNrnValue(PansiChar(@NrnBuffer^.data));
             NrnBuffer^.command:=0;
           end;

         nc_ShowConsole:
           begin
             nrnConsole.Show;
             NrnBuffer^.command:=0;
           end;
      end;

      resetEvent(EventHnd);
    end;
  until false;
end;



var
  LastFile:AnsiString;

procedure TNrnConsole.EditorStatusChange(Sender: TObject; Changes: TSynStatusChanges);
var
  p:integer;
begin
  if [scCaretX,scCaretY]*Changes<>[] then
  begin
    p:=TsynEdit(sender).CaretY;
    with TsynEdit(sender) do
    begin
      readOnly:= ( p<>lines.Count) and (lines.count<>0);
    end;
  end;

end;

procedure TNrnConsole.Init;
begin

  editor.OnStatusChange:= EditorStatusChange;
end;

procedure TNrnConsole.PushLine(st:AnsiString);
begin
  stack.Add(st);
  while stack.count>MaxStackIndex do stack.Delete(0);
  StackIndex:=stack.count-1;
end;

function TNrnConsole.PopLine:AnsiString;
begin
  if stack.count=0 then exit;
  result:=stack[stackIndex];
  if stackIndex>0 then dec(stackIndex) else stackIndex:=stack.Count-1;
end;

function TNrnConsole.PopLine2:AnsiString;
begin
  if stack.count=0 then exit;

  if stackIndex<stack.Count-1 then inc(stackIndex) else stackIndex:=0;
  result:=stack[stackIndex];

end;


procedure TNrnConsole.EditorProcessCommand(Sender: TObject; var Command: TSynEditorCommand; var AChar: Char; Data: Pointer);
var
  st:AnsiString;
begin
  with TsynEdit(sender) do
  case command of
    ecLineBreak, ecInsertLine:
      begin
        if (CaretY=lines.Count) then
        begin
          CaretX:= length(lines[lines.count-1]) +1;
          PushLine(lines[lines.count-1]);
          ProcessLine(lines[lines.count-1]);
        end;
      end;

    ecDeleteLastChar:
      begin
        if (caretY=lines.Count) and (caretX=1) then command:=ecNone;
      end;

    ecUp:
      begin
        if CaretY=lines.Count then
        begin
          command:=ecNone;
          lines[lines.count-1]:=PopLine;
          caretX:=length(lines[lines.count-1])+1;
        end;
      end;

    ecDown:
      begin
        if CaretY=lines.Count then
        begin
          command:=ecNone;
          lines[lines.count-1]:=PopLine2;
          caretX:=length(lines[lines.count-1])+1;
        end;
      end;
  end;
end;

procedure TNrnConsole.AddLine(st: AnsiString);
begin
  with editor do
  begin
    if st<>'' then
      if (lines.Count>0) and ( lines[lines.Count-1]='')
        then Lines[lines.Count-1]:=st
        else Lines.Add(st);

    Lines.Add('');
    caretY:=Lines.Count;
    caretX:=1;
    invalidate;
  end;
end;


procedure TNrnConsole.FormDestroy(Sender: TObject);
begin
  stack.free;

  UnmapViewOfFile(NrnBuffer);
  CloseHandle(NrnBufferHnd);
  closeHandle(EventHnd);
end;



procedure TNrnConsole.FormCreate(Sender: TObject);
begin
  stack:=TstringList.create;
  MaxStackIndex:=1000;

  MainThreadId:= getCurrentThreadId;

  if paramCount>0 then stBinFile:=paramStr(1) else stBinFile:= 'C:\nrnRT2\bin\neuron.exe';
  if paramCount>1 then stHocFile:=paramStr(2) else stHocFile:= 'C:\nrnRT2\lib\hoc\nrngui.hoc';

  //messageCentral(stBinFile+crlf+stHocFile);

  if not initNrnLib then
  begin
    messageCentral('Nrn Dll not found');
    halt;
  end;



  NrnBufferHnd := OpenFileMapping(FILE_MAP_ALL_ACCESS,false,stDrvBuffer);
  NrnBuffer := MapViewOfFile(NrnBufferHnd,FILE_MAP_ALL_ACCESS,0,0,0);

  if NrnBuffer =Nil then
  begin
    messageCentral('No NrnBuffer File');
    //exit;
  end;

  EventHnd := OpenEvent(windows.SYNCHRONIZE, TRUE, stDrvEvent);
  if EventHnd=0 then
  begin
    messageCentral('No Nrn Event');
    //exit;
  end;

  ThreadCom:= TthreadCom.create(false);

  PostMessage(handle,nc_start,0,0);
end;



procedure TNrnConsole.StartNrn(var Msg: Tmsg);
begin
  NrnInit(NrnPrintf, NrnReadline,PansiChar(stBinFile), PansiChar(stHocFile));

end;

procedure TNrnConsole.ProcessLine(st: AnsiString);
begin
  NrnSendString(st);
end;

procedure TNrnConsole.Timer1Timer(Sender: TObject);
begin
  Panel2.Caption:=Istr(CntCom);
end;


var
  DumVar:array[1..50] of double;
  NdumVar:integer;

function TNrnConsole.recInfo:PRTrecInfo;
begin
  result:=@NrnBuffer^.rec;
end;

procedure TNrnConsole.InitAcqNrnPointer;
var
  i:integer;

  function G_val_pointer1(p:Pansichar):Pdouble;
  begin
    result:= Gnrn_val_pointer(p);
    if result=nil then
    begin
      result:=@DumVar[NdumVar];
      inc(NdumVar);
    end;

  end;

begin
  NdumVar:=1;
  fillchar(DumVar,sizeof(Dumvar),0);

  with recInfo^ do
  begin
    for i:=1 to NbAcq do
    begin
      AcqPtr[i] := G_val_pointer1(AcqSymb[i]);
      Printline(getNrnName(AcqSymb[i]) +'     '+ longtohexa(longint(AcqPtr[i])));
    end;

    for i:=1 to NbTag do
    begin
      TagPtr[i] := G_val_pointer1(TagSymb[i]);
      Printline(getNrnName(TagSymb[i]) +'     '+ longtohexa(longint(TagPtr[i])));
    end;

    for i:=1 to NbStim do
    begin
      StimPtr[i] := G_val_pointer1(StimSymb[i]);
      Printline(getNrnName(StimSymb[i]) +'     '+ longtohexa(longint(StimPtr[i])));
    end;

    NrnSendString('dt='+Estr(SampleInt/1000,3));
  end;
end;


function TNrnConsole.ProcessAg: integer;
var
  i:integer;
  DIOvalue:word;
begin
  result:=0;
  with recInfo^ do
  begin
    for i:=1 to NbStim do
      StimPtr[i]^:=NrnBuffer^.OutBuffer[i];

    if FNeuron then
    begin
      try
        Gnrn_fixed_step;
      except
        result:=nc_DLLerror;
      end;
    end;
    for i:=1 to nbAcq do
      NrnBuffer^.InBuffer[i] :=AcqPtr[i]^;

    if NbTag>0 then
    begin
      DioValue := 0;
      for i:=0  to NbTag do
        if (TagPtr[i] <>nil) and ( TagPtr[i]^ > 0)
          then DioValue := DioValue or (1 shl TagNum[i]);

        NrnBuffer^.TagBuffer:= DIOvalue;
     end;
  end;

end;

function TNrnConsole.getNrnValue(pst:PansiChar):double;
var
  p: Pdouble;
begin
  p:=Gnrn_val_pointer(pst);
  if assigned(p) then result:=p^;
end;

initialization

finalization
freeLibrary(hh);

end.
