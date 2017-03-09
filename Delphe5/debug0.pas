unit debug0;


{Le premier appel à Affdebug(st) crée le fichier d:\delphe5\debug.txt
 et range la chaine st dans ce fichier.
 Les autre appels rangent st à la suite dans le fichier s'il existe.

 Ce mécanisme existe si la directive conditionnelle DEBUG est activée.

 Warning: il faut veiller à ne pas activer DEBUG dans les DLL appelées par
 le programme principal.
}

interface
{$IFDEF FPC}
   {$mode delphi}
   {$DEFINE AcqElphy2}
   {$DEFINE DEBUG}
   {$A1} {$Z1}
{$ENDIF}

uses math, util1;

const
  debugGroups:set of byte = [132];

procedure affDebug(st:AnsiString;numG:integer);

procedure affDebugMem(st:AnsiString);

implementation

const
  nbFflag:integer=0;

procedure affDebug(st:AnsiString;numG:integer);
const
  open:boolean=false;
  ok:boolean=true;
  stf:AnsiString='';

  {Flag évitant la réentrance}
  Fflag:boolean=false;

var
  f:text;

begin

  {$IFDEF DEBUG}
  if not ok  or not GDebugMode or (numG<>DebugCode) then exit;

  if Fflag then
    begin
      inc(nbFflag);
      exit;
    end;

  //if not (numG in DebugGroups) then exit;
  stf:=AppData+'debug.txt';
  Fflag:=true;
  if not open then
  begin
    
    try
    assignFile(f,stf);
    rewrite(f);
    writeln(f,'__');
    closeFile(f);
    open:=true;

    except
      {$I-}closeFile(f);{$I+}
      ok:=false;
      Fflag:=false;
      exit;
    end;
  end;

  {$I-}
  assignFile(f,stf);
  append(f);
  writeln(f,st);
  closeFile(f);
  {$I+}

  Fflag:=false;

  {$ENDIF}
end;


procedure affDebugMem(st:AnsiString);
begin
  {$IFDEF DEBUG}
  affdebug(st+'  MEM='+Istr(AllocatedMem),0);
  {$ENDIF}
end;

Initialization
AffDebug('Initialization debug0' ,0);

finalization
affdebug('nbFflag='+Istr(nbFflag),0);

(*
const
  maxList=50000;

var
  PointerList:array[0..maxList] of pointer ;
  pointerCount:integer;

  GetMemCount: Integer=0;
  FreeMemCount: Integer=0;
  ReallocMemCount: Integer=0;

  CurCount:integer=0;
  maxCount:integer=0;

var
  OldMemMgr: TMemoryManager;


function NewGetMem(Size: Integer): Pointer;
begin
  Inc(GetMemCount);
  inc(curCount);
  if curCount>maxCount then maxCount:=curCount;
  Result := OldMemMgr.GetMem(Size);

  if pointerCount=maxList then exit;
  pointerList[pointerCount]:=result;
  inc(pointerCount);
end;

function NewFreeMem(P: Pointer): Integer;
var
  i:integer;
begin
  Inc(FreeMemCount);
  dec(curCount);
  Result := OldMemMgr.FreeMem(P);

  for i:=0 to pointerCount-1 do
    if pointerList[i]=p then
      begin
        move(pointerList[i+1],pointerList[i],4*(pointerCount-i-1));
        dec(pointerCount);
        exit;
      end;

end;

function NewReallocMem(P: Pointer; Size: Integer): Pointer;
begin

  Inc(ReallocMemCount);
  Result := OldMemMgr.ReallocMem(P, Size);
end;

const
  NewMemMgr: TMemoryManager = (
  GetMem: NewGetMem;
  FreeMem: NewFreeMem;
  ReallocMem: NewReallocMem);

procedure SetNewMemMgr;
begin
  GetMemoryManager(OldMemMgr);
  SetMemoryManager(NewMemMgr);
end;


{$IFDEF DEBUG}
initialization

affdebug('Debug0 Initialization');
SetNewMemMgr;

finalization

{affdebug('PointerList.count='+Istr(pointerList.count));}
affdebug('Debug0 counts='+Istr(GetMemCount)+' '+Istr(FreeMemCount)
                         +' '+Istr(ReallocMemCount)+' '+Istr(maxCount));



{$ENDIF}
*)

end.

