unit testDLLc;

interface

uses Windows,
     util1;

var
  func:function :integer;stdCall;

function InitDLL:boolean;

implementation

function getProc(hh:Thandle;st:string):pointer;
begin
  result:=GetProcAddress(hh,Pchar(st));
  if result=nil then messageCentral(st+'=nil')
                else messageCentral(st+' OK');
end;

var
  hh:integer;


function InitDLL:boolean;
begin
  result:=true;
  if hh<>0 then exit;

  {hh:=loadLibrary('c:\itc\test\testProject.dll');}

  hh:=loadLibrary('ntxdll.dll');
  result:=(hh<>0);
  if not result then exit;

  func:=getProc(hh,'fnNtxDll');
end;


initialization

finalization
  if hh<>0 then freeLibrary(hh);

end.